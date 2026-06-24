import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/core.dart';
import '../../../health_connect/health_connect.dart';

/// Home-screen card summarising the latest Health Connect metrics.
///
/// Lives alongside [WaterCard] in the home feature because it is a home
/// dashboard element. It watches the health providers directly and adapts to
/// the permission state.
class HealthSummaryCard extends ConsumerWidget {
  final VoidCallback onPressed;

  const HealthSummaryCard({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final bool isDarkMode = theme.brightness == Brightness.dark;

    final AsyncValue<HealthPermissionStatus> permissionAsync =
        ref.watch(healthPermissionNotifierProviderImpl);
    final AsyncValue<HealthSummary> summaryAsync =
        ref.watch(healthSummaryNotifierProviderImpl);

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(24),
      splashFactory: InkSparkle.splashFactory,
      splashColor: theme.colorScheme.primary.withValues(alpha: .2),
      child: Ink(
        padding: const EdgeInsets.all(kPadding16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isDarkMode ? AppColours.neutral10 : AppColours.neutral95,
          ),
        ),
        child: permissionAsync.when(
          loading: () => const _CardMessage(message: null),
          error: (_, __) =>
              const _CardMessage(message: "Couldn't load health data"),
          data: (status) {
            switch (status) {
              case HealthPermissionStatus.notAvailable:
                return const _CardMessage(
                  message: "Health Connect is not available on this device",
                );
              case HealthPermissionStatus.granted:
                return summaryAsync.when(
                  loading: () => const _CardMessage(message: null),
                  error: (_, __) =>
                      const _CardMessage(message: "Couldn't load health data"),
                  data: (summary) => _CardData(
                    summary: summary,
                    theme: theme,
                  ),
                );
              case HealthPermissionStatus.unknown:
              case HealthPermissionStatus.denied:
                return _CardPermissionRequest(
                  theme: theme,
                  onRequest: () => ref
                      .read(healthPermissionNotifierProviderImpl.notifier)
                      .requestPermissions(),
                );
            }
          },
        ),
      ),
    );
  }
}

/// Shows a centred message, or a spinner when [message] is null.
class _CardMessage extends StatelessWidget {
  final String? message;
  const _CardMessage({required this.message});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return SizedBox(
      height: 72,
      child: Center(
        child: message == null
            ? const CircularProgressIndicator.adaptive()
            : Text(
                message!,
                style: theme.textTheme.bodySmall!
                    .copyWith(color: AppColours.neutral50),
                textAlign: TextAlign.center,
              ),
      ),
    );
  }
}

class _CardPermissionRequest extends StatelessWidget {
  final ThemeData theme;
  final VoidCallback onRequest;
  const _CardPermissionRequest({required this.theme, required this.onRequest});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Icon(FluentIcons.heart_pulse_24_regular,
                color: theme.colorScheme.primary),
            const Gap(kPadding4),
            Text(
              "Health",
              style: theme.textTheme.bodyLarge!
                  .copyWith(color: theme.colorScheme.primary),
            ),
          ],
        ),
        const Gap(kPadding8),
        Text(
          "Connect Health Connect to see your steps, heart rate, and SpO2.",
          style:
              theme.textTheme.bodySmall!.copyWith(color: AppColours.neutral50),
        ),
        const Gap(kPadding12),
        TextButton(
          onPressed: onRequest,
          style: TextButton.styleFrom(padding: EdgeInsets.zero),
          child: const Text("Grant Access"),
        ),
      ],
    );
  }
}

class _CardData extends StatelessWidget {
  final HealthSummary summary;
  final ThemeData theme;
  const _CardData({required this.summary, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Icon(FluentIcons.heart_pulse_24_regular,
                color: theme.colorScheme.primary),
            const Gap(kPadding4),
            Text(
              "Health",
              style: theme.textTheme.bodyLarge!
                  .copyWith(color: theme.colorScheme.primary),
            ),
          ],
        ),
        const Gap(kPadding16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _MetricChip(
              icon: FluentIcons.person_walking_24_regular,
              label: "Steps",
              value: summary.stepsToday != null ? "${summary.stepsToday}" : "--",
              theme: theme,
            ),
            _MetricChip(
              icon: FluentIcons.heart_pulse_24_regular,
              label: "Heart Rate",
              value: summary.latestHeartRate != null
                  ? "${summary.latestHeartRate!.bpm} bpm"
                  : "--",
              theme: theme,
            ),
            _MetricChip(
              icon: FluentIcons.drop_24_regular,
              label: "SpO2",
              value: summary.latestBloodOxygen != null
                  ? "${summary.latestBloodOxygen!.percentage.toStringAsFixed(1)}%"
                  : "--",
              theme: theme,
            ),
          ],
        ),
      ],
    );
  }
}

class _MetricChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final ThemeData theme;

  const _MetricChip({
    required this.icon,
    required this.label,
    required this.value,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        const Gap(kPadding4),
        Text(value, style: theme.textTheme.titleSmall),
        Text(
          label,
          style:
              theme.textTheme.bodySmall!.copyWith(color: AppColours.neutral50),
        ),
      ],
    );
  }
}
