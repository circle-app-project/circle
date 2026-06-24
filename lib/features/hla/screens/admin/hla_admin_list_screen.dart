import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:gap/gap.dart';

import '../../../../components/components.dart';
import '../../../../core/core.dart';
import '../../../../core/extensions/date_time_formatter.dart';
import '../../hla.dart';

/// Admin: the full request queue, filterable by status (US-7). Role-gated at
/// the entry point and enforced by Firestore rules.
@RoutePage(name: HlaAdminListScreen.name)
class HlaAdminListScreen extends ConsumerStatefulWidget {
  static const String path = "/hla_admin";
  static const String name = "HlaAdminListScreen";
  const HlaAdminListScreen({super.key});

  @override
  ConsumerState<HlaAdminListScreen> createState() => _HlaAdminListScreenState();
}

class _HlaAdminListScreenState extends ConsumerState<HlaAdminListScreen> {
  HlaTestStatus? _filter;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(hlaAdminNotifierProviderImpl.notifier).getAllRequests();
    });
    super.initState();
  }

  void _applyFilter(HlaTestStatus? status) {
    setState(() => _filter = status);
    ref.read(hlaAdminNotifierProviderImpl.notifier).getAllRequests(status: status);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final requestsAsync = ref.watch(hlaAdminNotifierProviderImpl);

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () =>
            context.router.pushNamed(HlaAdminSlotsScreen.path),
        icon: const Icon(FluentIcons.calendar_24_regular),
        label: const Text("Slots"),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: kPadding16),
              child: CustomAppBar(pageTitle: "HLA Admin"),
            ),
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: kPadding16),
                children: [
                  _FilterChip(
                    label: "All",
                    selected: _filter == null,
                    onTap: () => _applyFilter(null),
                  ),
                  for (final status in HlaTestStatus.values)
                    Padding(
                      padding: const EdgeInsets.only(left: kPadding8),
                      child: _FilterChip(
                        label: status.label,
                        selected: _filter == status,
                        onTap: () => _applyFilter(status),
                      ),
                    ),
                ],
              ),
            ),
            const Gap(kPadding16),
            Expanded(
              child: requestsAsync.when(
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(
                  child: Text(
                    (error is Failure) ? error.message : "Couldn't load queue",
                    style: AppTextStyles.bodyMedium
                        .copyWith(color: theme.colorScheme.error),
                  ),
                ),
                data: (requests) {
                  if (requests.isEmpty) {
                    return Center(
                      child: Text(
                        "No requests",
                        style: AppTextStyles.bodyLarge
                            .copyWith(color: AppColours.neutral50),
                      ),
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: kPadding16),
                    itemCount: requests.length,
                    separatorBuilder: (_, __) => const Gap(kPadding12),
                    itemBuilder: (context, index) {
                      final request = requests[index];
                      return InkWell(
                        borderRadius: BorderRadius.circular(kPadding16),
                        onTap: () => context.router.pushNamed(
                          "${HlaAdminDetailScreen.path}/${request.uid}",
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(kPadding16),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(kPadding16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      request.patientName.isEmpty
                                          ? "Unknown patient"
                                          : request.patientName,
                                      style: theme.textTheme.bodyLarge
                                          ?.copyWith(fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  HlaStatusChip(status: request.status),
                                ],
                              ),
                              const Gap(kPadding8),
                              Text(
                                request.appointmentDate != null
                                    ? request.appointmentDate!
                                        .toLocal()
                                        .formatDateWithTime(context)
                                    : "No appointment",
                                style: AppTextStyles.bodySmall
                                    .copyWith(color: AppColours.neutral50),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: kPadding16),
        decoration: BoxDecoration(
          color: selected
              ? theme.colorScheme.primary
              : theme.colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(kPadding24),
        ),
        child: Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: selected
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
