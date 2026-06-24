import 'package:auto_route/auto_route.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../../../components/components.dart';
import '../../../core/core.dart';
import '../health_connect.dart';

@RoutePage(name: HealthScreen.name)
class HealthScreen extends ConsumerStatefulWidget {
  static const String path = "/health";
  static const String name = "HealthScreen";

  const HealthScreen({super.key});

  @override
  ConsumerState<HealthScreen> createState() => _HealthScreenState();
}

class _HealthScreenState extends ConsumerState<HealthScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final HealthPermissionStatus? status =
          ref.read(healthPermissionNotifierProviderImpl).value;
      if (status == HealthPermissionStatus.granted) {
        await ref
            .read(healthSummaryNotifierProviderImpl.notifier)
            .getHealthSummary();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AsyncValue<HealthPermissionStatus> permissionAsync =
        ref.watch(healthPermissionNotifierProviderImpl);
    final AsyncValue<HealthSummary> summaryAsync =
        ref.watch(healthSummaryNotifierProviderImpl);

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: kPadding16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomAppBar(pageTitle: "Health"),
              permissionAsync.when(
                loading: () => const Padding(
                  padding: EdgeInsets.only(top: kPadding64),
                  child: Center(child: CircularProgressIndicator.adaptive()),
                ),
                error: (error, _) => _buildMessage(
                  theme,
                  "Something went wrong while checking Health Connect.",
                ),
                data: (status) {
                  switch (status) {
                    case HealthPermissionStatus.notAvailable:
                      return _buildMessage(
                        theme,
                        "Health Connect is not available on this device.",
                      );
                    case HealthPermissionStatus.granted:
                      return summaryAsync.when(
                        loading: () => const Padding(
                          padding: EdgeInsets.only(top: kPadding64),
                          child: Center(
                            child: CircularProgressIndicator.adaptive(),
                          ),
                        ),
                        error: (error, _) => _buildMessage(
                          theme,
                          "Could not load your health data.",
                        ),
                        data: (summary) => _buildData(theme, summary),
                      );
                    case HealthPermissionStatus.unknown:
                    case HealthPermissionStatus.denied:
                      return _buildPermissionRequest(theme);
                  }
                },
              ),
              const SizedBox(height: kPadding64 * 2),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessage(ThemeData theme, String message) => Padding(
        padding: const EdgeInsets.only(top: kPadding64),
        child: Center(
          child: Text(
            message,
            style: theme.textTheme.bodyLarge!
                .copyWith(color: AppColours.neutral50),
            textAlign: TextAlign.center,
          ),
        ),
      );

  Widget _buildPermissionRequest(ThemeData theme) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Connect your health data", style: theme.textTheme.titleLarge),
          const Gap(kPadding8),
          Text(
            "Allow Circle to read your steps, heart rate, and blood oxygen "
            "from Health Connect to keep track of your wellbeing.",
            style: theme.textTheme.bodyMedium!
                .copyWith(color: AppColours.neutral50),
          ),
          const Gap(kPadding24),
          AppButton(
            label: "Grant Health Connect Access",
            onPressed: () => ref
                .read(healthPermissionNotifierProviderImpl.notifier)
                .requestPermissions(),
          ),
        ],
      );

  Widget _buildData(ThemeData theme, HealthSummary summary) {
    final DateFormat formatter = DateFormat('h:mm a');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Steps ──────────────────────────────────────────────────────────
        const _SectionHeader(
          icon: FluentIcons.person_walking_24_regular,
          title: "Steps Today",
        ),
        const Gap(kPadding8),
        Text(
          summary.stepsToday != null ? "${summary.stepsToday}" : "No data",
          style: theme.textTheme.displaySmall!
              .copyWith(fontWeight: FontWeight.w700),
        ),
        const Gap(kPadding32),

        // ── Heart rate ─────────────────────────────────────────────────────
        const _SectionHeader(
          icon: FluentIcons.heart_pulse_24_regular,
          title: "Heart Rate",
        ),
        const Gap(kPadding8),
        if (summary.latestHeartRate != null) ...[
          Text(
            "${summary.latestHeartRate!.bpm} bpm",
            style: theme.textTheme.headlineSmall!
                .copyWith(fontWeight: FontWeight.w700),
          ),
          Text(
            "Last reading ${formatter.format(summary.latestHeartRate!.timestamp)}",
            style: theme.textTheme.bodySmall!
                .copyWith(color: AppColours.neutral50),
          ),
        ] else
          Text("No data", style: theme.textTheme.bodyMedium),
        const Gap(kPadding16),
        ...summary.recentHeartRates.take(10).map(
              (record) => _ReadingTile(
                timestamp: record.timestamp,
                value: "${record.bpm} bpm",
                formatter: formatter,
              ),
            ),
        const Gap(kPadding32),

        // ── Blood oxygen ───────────────────────────────────────────────────
        const _SectionHeader(
          icon: FluentIcons.drop_24_regular,
          title: "Blood Oxygen (SpO2)",
        ),
        const Gap(kPadding8),
        if (summary.latestBloodOxygen != null) ...[
          Text(
            "${summary.latestBloodOxygen!.percentage.toStringAsFixed(1)}%",
            style: theme.textTheme.headlineSmall!
                .copyWith(fontWeight: FontWeight.w700),
          ),
          Text(
            "Last reading ${formatter.format(summary.latestBloodOxygen!.timestamp)}",
            style: theme.textTheme.bodySmall!
                .copyWith(color: AppColours.neutral50),
          ),
        ] else
          Text("No data", style: theme.textTheme.bodyMedium),
        const Gap(kPadding16),
        ...summary.recentBloodOxygenReadings.take(10).map(
              (record) => _ReadingTile(
                timestamp: record.timestamp,
                value: "${record.percentage.toStringAsFixed(1)}%",
                formatter: formatter,
              ),
            ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  const _SectionHeader({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, color: theme.colorScheme.primary),
        const Gap(kPadding8),
        Text(title, style: theme.textTheme.titleMedium),
      ],
    );
  }
}

class _ReadingTile extends StatelessWidget {
  final DateTime timestamp;
  final String value;
  final DateFormat formatter;

  const _ReadingTile({
    required this.timestamp,
    required this.value,
    required this.formatter,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDarkMode = theme.brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: kPadding8),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: kPadding16,
          vertical: kPadding12,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(kPadding12),
          color: isDarkMode ? AppColours.neutral10 : AppColours.neutral95,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(formatter.format(timestamp), style: theme.textTheme.bodyMedium),
            Text(value, style: theme.textTheme.titleSmall),
          ],
        ),
      ),
    );
  }
}
