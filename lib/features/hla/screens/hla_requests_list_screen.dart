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

/// The patient's current and past HLA requests, active first (US-6).
@RoutePage(name: HlaRequestsListScreen.name)
class HlaRequestsListScreen extends ConsumerStatefulWidget {
  static const String path = "/hla_requests";
  static const String name = "HlaRequestsListScreen";
  const HlaRequestsListScreen({super.key});

  @override
  ConsumerState<HlaRequestsListScreen> createState() =>
      _HlaRequestsListScreenState();
}

class _HlaRequestsListScreenState extends ConsumerState<HlaRequestsListScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final AppUser user =
          ref.read(userNotifierProviderImpl).value ?? AppUser.empty;
      if (user.isNotEmpty) {
        ref
            .read(hlaRequestsNotifierProviderImpl.notifier)
            .getRequests(user: user);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final requestsAsync = ref.watch(hlaRequestsNotifierProviderImpl);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: kPadding16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomAppBar(pageTitle: "My Requests"),
              requestsAsync.when(
                loading: () => const Padding(
                  padding: EdgeInsets.only(top: kPadding64),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (error, _) => _ErrorState(
                  message: (error is Failure)
                      ? error.message
                      : "Couldn't load your requests",
                ),
                data: (requests) {
                  if (requests.isEmpty) {
                    return const _EmptyState();
                  }
                  final sorted = [...requests]..sort((a, b) {
                      final bool aActive =
                          !a.isCancelled && !a.status.isTerminal;
                      final bool bActive =
                          !b.isCancelled && !b.status.isTerminal;
                      if (aActive != bActive) return aActive ? -1 : 1;
                      return (b.createdAt ?? DateTime(0))
                          .compareTo(a.createdAt ?? DateTime(0));
                    });
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: sorted.length,
                    separatorBuilder: (_, __) => const Gap(kPadding12),
                    itemBuilder: (context, index) =>
                        _RequestCard(request: sorted[index]),
                  );
                },
              ),
              const Gap(kPadding64),
            ],
          ),
        ),
      ),
    );
  }
}

class _RequestCard extends StatelessWidget {
  const _RequestCard({required this.request});

  final HlaTestRequest request;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(kPadding16),
      onTap: () => context.router
          .pushNamed("${HlaStatusScreen.path}/${request.uid}"),
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
                HlaStatusChip(status: request.status),
                const Spacer(),
                const Icon(
                  FluentIcons.chevron_right_24_regular,
                  size: 18,
                  color: AppColours.neutral50,
                ),
              ],
            ),
            const Gap(kPadding12),
            Text(
              request.appointmentDate != null
                  ? "Appointment: ${request.appointmentDate!.toLocal().formatDateWithTime(context)}"
                  : "No appointment booked yet",
              style: AppTextStyles.bodyMedium
                  .copyWith(color: AppColours.neutral50),
            ),
            const Gap(kPadding4),
            Text(
              "${request.subjects.length} subject(s) in panel",
              style: AppTextStyles.bodySmall
                  .copyWith(color: AppColours.neutral50),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: kPadding64),
      child: Center(
        child: Column(
          children: [
            const Icon(
              FluentIcons.document_24_regular,
              size: 48,
              color: AppColours.neutral60,
            ),
            const Gap(kPadding16),
            Text(
              "You have no HLA requests yet",
              style: theme.textTheme.bodyLarge
                  ?.copyWith(color: AppColours.neutral50),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: kPadding64),
      child: Center(
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyMedium
              .copyWith(color: Theme.of(context).colorScheme.error),
        ),
      ),
    );
  }
}
