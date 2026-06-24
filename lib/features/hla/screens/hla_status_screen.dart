import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:gap/gap.dart';

import '../../../components/components.dart';
import '../../../core/core.dart';
import '../../../core/extensions/date_time_formatter.dart';
import '../../auth/auth.dart';
import '../hla.dart';

/// The journey timeline for a single request, updated in near real time via a
/// Firestore snapshot stream (US-4). Hosts the book-appointment, cancel, and
/// view-results actions.
@RoutePage(name: HlaStatusScreen.name)
class HlaStatusScreen extends ConsumerWidget {
  static const String path = "/hla_status";
  static const String name = "HlaStatusScreen";

  const HlaStatusScreen({super.key, @PathParam('requestId') required this.requestId});

  final String requestId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AppUser user =
        ref.watch(userNotifierProviderImpl).value ?? AppUser.empty;
    final requestAsync = ref.watch(hlaRequestStreamProvider(requestId));

    // Surface booking/cancel failures from the actions notifier.
    ref.listen(hlaRequestsNotifierProviderImpl, (previous, next) {
      next.whenOrNull(
        error: (error, _) =>
            showCustomSnackBar(context: context, error: error),
      );
    });

    return Scaffold(
      body: SafeArea(
        child: requestAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => _Centered(
            child: Text(
              (error is Failure) ? error.message : "Couldn't load this request",
              style: AppTextStyles.bodyMedium
                  .copyWith(color: theme.colorScheme.error),
            ),
          ),
          data: (request) {
            if (request == null) {
              return const _Centered(
                child: Text("This request could not be found"),
              );
            }
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: kPadding16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomAppBar(pageTitle: "Test Status"),
                  Row(
                    children: [
                      HlaStatusChip(status: request.status),
                      const Spacer(),
                    ],
                  ),
                  if (request.appointmentDate != null) ...[
                    const Gap(kPadding16),
                    _AppointmentCard(
                      date: request.appointmentDate!,
                      location: request.collectionLocation,
                    ),
                  ],
                  const Gap(kPadding24),
                  if (request.hasResults) ...[
                    AppButton(
                      label: "View results",
                      icon: FluentIcons.document_checkmark_24_regular,
                      onPressed: () => context.router
                          .pushNamed("${HlaResultsScreen.path}/${request.uid}"),
                    ),
                    const Gap(kPadding24),
                  ],
                  Text("Journey", style: theme.textTheme.titleMedium),
                  const Gap(kPadding16),
                  HlaStatusTimeline(
                    currentStatus: request.status,
                    history: request.statusHistory,
                  ),
                  const Gap(kPadding16),
                  if (request.status == HlaTestStatus.requested)
                    AppButton(
                      label: "Book a collection appointment",
                      icon: FluentIcons.calendar_add_24_regular,
                      onPressed: () => _bookAppointment(context, ref, request, user),
                    ),
                  if (request.status.isPatientCancellable) ...[
                    const Gap(kPadding8),
                    AppButton(
                      label: "Cancel request",
                      buttonType: ButtonType.text,
                      color: theme.colorScheme.error,
                      onPressed: () => _confirmCancel(context, ref, request, user),
                    ),
                  ],
                  const Gap(kPadding64),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _bookAppointment(
    BuildContext context,
    WidgetRef ref,
    HlaTestRequest request,
    AppUser user,
  ) async {
    final slot = await showModalBottomSheet<HlaAppointmentSlot>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _SlotPickerSheet(),
    );
    if (slot != null) {
      await ref
          .read(hlaRequestsNotifierProviderImpl.notifier)
          .bookAppointment(request: request, slot: slot, user: user);
    }
  }

  Future<void> _confirmCancel(
    BuildContext context,
    WidgetRef ref,
    HlaTestRequest request,
    AppUser user,
  ) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AppAlertDialog(
        title: "Cancel request?",
        message:
            "This will cancel your HLA typing request and free any booked "
            "appointment slot. This cannot be undone.",
        actions: [
          AppButton(
            label: "Keep request",
            buttonType: ButtonType.outline,
            onPressed: () => Navigator.pop(context, false),
          ),
          const Gap(kPadding8),
          AppButton(
            label: "Cancel request",
            backgroundColor: Theme.of(context).colorScheme.error,
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref
          .read(hlaRequestsNotifierProviderImpl.notifier)
          .cancelRequest(request: request, user: user);
    }
  }
}

class _AppointmentCard extends StatelessWidget {
  const _AppointmentCard({required this.date, this.location});

  final DateTime date;
  final String? location;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(kPadding16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(kPadding16),
      ),
      child: Row(
        children: [
          Icon(
            FluentIcons.calendar_checkmark_24_regular,
            color: theme.colorScheme.onPrimaryContainer,
          ),
          const Gap(kPadding12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Collection appointment",
                  style: AppTextStyles.bodySmall.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
                const Gap(kPadding4),
                Text(
                  date.toLocal().formatDateWithTime(context),
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (location != null)
                  Text(
                    location!,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Bottom sheet listing available slots; pops with the chosen slot.
class _SlotPickerSheet extends ConsumerStatefulWidget {
  const _SlotPickerSheet();

  @override
  ConsumerState<_SlotPickerSheet> createState() => _SlotPickerSheetState();
}

class _SlotPickerSheetState extends ConsumerState<_SlotPickerSheet> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(hlaSlotsNotifierProviderImpl.notifier).getAvailableSlots();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final slotsAsync = ref.watch(hlaSlotsNotifierProviderImpl);

    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? theme.colorScheme.surfaceContainerLowest
            : theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(20, kPadding24, 20, kPadding32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Pick a collection slot",
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const Gap(kPadding16),
          slotsAsync.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(kPadding24),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, _) => Text(
              (error is Failure) ? error.message : "Couldn't load slots",
              style: AppTextStyles.bodyMedium
                  .copyWith(color: theme.colorScheme.error),
            ),
            data: (slots) {
              if (slots.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: kPadding24),
                  child: Text(
                    "No appointment slots are available right now. "
                    "Please check back soon.",
                    style: AppTextStyles.bodyMedium
                        .copyWith(color: AppColours.neutral50),
                  ),
                );
              }
              return ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.sizeOf(context).height * 0.5,
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: slots.length,
                  separatorBuilder: (_, __) => const Gap(kPadding8),
                  itemBuilder: (context, index) => HlaSlotTile(
                    slot: slots[index],
                    onTap: () => Navigator.pop(context, slots[index]),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _Centered extends StatelessWidget {
  const _Centered({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(kPadding24),
        child: child,
      ),
    );
  }
}
