import 'package:auto_route/auto_route.dart';
import 'package:circle/features/meds/screens/components/medication_reminder_card.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../components/components.dart';
import '../../../core/core.dart';
import '../meds.dart';
import '../models/medication.dart';
import '../providers/med_notifier.dart';

@RoutePage(name: MedsScreen.name)
class MedsScreen extends ConsumerStatefulWidget {
  static const String path = "/meds";
  static const String name = "MedsScreen";
  const MedsScreen({super.key});

  @override
  ConsumerState<MedsScreen> createState() => _MedsScreenState();
}

class _MedsScreenState extends ConsumerState<MedsScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(medNotifierProviderImpl.notifier).getMedications();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MedNotifier medsNotifier = ref.watch(medNotifierProviderImpl.notifier);

    List<Medication> medications =
        ref.watch(medNotifierProviderImpl).value ?? [];

    if (medications.isEmpty) {
      print("No medications");
    } else {
      print(
        "number of medication actity records for this medciation: ${medications.first.activityRecord.length}",
      );
    }

    final ThemeData theme = Theme.of(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: kPadding16),
              child: CustomAppBar(pageTitle: "Medication"),
            ),

            if (medications.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: kPadding16),
                child: Column(
                  spacing: kPadding12,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Next Dose", style: theme.textTheme.titleMedium),
                    MedicationReminderCard(
                      medication: medications.first,
                      isEmphasized: true,
                      onMarkAsSkipped: (String? skipReason) async {
                        await medsNotifier.markDoseAsSkipped(
                          medication: medications.first,
                          skipReason: skipReason,
                        );
                        if (context.mounted) {
                          if (ref.watch(medNotifierProviderImpl).hasError) {
                            showCustomSnackBar(
                              context: context,
                              error: ref.watch(medNotifierProviderImpl).error,
                            );
                          } else {
                            showCustomSnackBar(
                              context: context,
                              message: "Dose skipped",
                              mode: SnackBarMode.notification,
                            );
                          }
                        }
                      },
                      onMarkAsTaken: () async {
                        await medsNotifier.markDoseAsTaken(
                          medication: medications.first,
                        );
                        if (ref.watch(medNotifierProviderImpl).hasError) {
                          showCustomSnackBar(
                            context: context,
                            error: ref.watch(medNotifierProviderImpl).error,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),

            const Gap(16),
            if (medications.isNotEmpty) const Gap(48),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(
                kPadding16,
                0,
                0,
                0,
              ),
              child: Text("My Medications", style: theme.textTheme.titleMedium),
            ),
            const Gap(kPadding16),

            SizedBox(
              height: 200,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    const Gap(kPadding16),
                    if (medications.isNotEmpty) ...[
                      ListView.separated(
                        itemCount: medications.length,
                        scrollDirection: Axis.horizontal,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        separatorBuilder:
                            (context, index) => const Gap(kPadding16),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return MedicationCard(
                            medication: medications[index],
                            viewportWidthFraction: .9,
                          );
                        },
                      ),
                      const Gap(kPadding16),
                    ],
                    AddMedicationButton(
                      viewportWidthFraction: medications.isNotEmpty ? .9 : 1,
                      onPressed: () {
                        context.router.pushNamed(AddMedsScreen.path);
                      },
                    ),

                    const Gap(kPadding16),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),
            AppButton(
              icon: FluentIcons.add_24_regular,
              onPressed: () {
                context.router.pushNamed(AddMedsScreen.path);
                // showAdaptiveDialog(
                //   context: context,
                //   builder: (context) => SicklerAlertDialog(
                //     child: Column(
                //       mainAxisSize: MainAxisSize.min,
                //       crossAxisAlignment: CrossAxisAlignment.center,
                //       children: [
                //         Text(
                //           "Are you sure you want to delete this log?",
                //           textAlign: TextAlign.center,
                //         ),
                //         Gap(24),
                //         Row(
                //           mainAxisAlignment: MainAxisAlignment.end,
                //           children: [
                //             SicklerButton(
                //                 isChipButton: true,
                //                 icon: FluentIcons.dismiss_20_regular,
                //                 buttonType: ButtonType.text,
                //                 onPressed: () {
                //                   context.pop();
                //                 },
                //                 label: "Cancel"),
                //             Gap(12),
                //             SicklerButton(
                //                 isChipButton: true,
                //                 icon: FluentIcons.delete_20_regular,
                //                 color: theme.colorScheme.error,
                //                 buttonType: ButtonType.text,
                //                 onPressed: () {},
                //                 label: "Delete")
                //           ],
                //         )
                //       ],
                //     ),
                //     title: "Delete Log?",
                //   ),
                // );
              },
              label: "Add Medication",
              buttonType: ButtonType.secondary,
            ),
            const SizedBox(height: 48),
            Row(
              children: [
                Text("Today's History", style: theme.textTheme.titleLarge),
                const Spacer(),
                IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {},
                  icon: SvgPicture.asset("assets/svg/filter.svg"),
                ),
              ],
            ),
            const SizedBox(height: 12),
            DateSwitcher(
              onNextPressed: () {},
              onPreviousPressed: () {},
              label: "Today",
            ),
            const Gap(12),
            const MedsHistoryItem(mode: MedsHistoryMode.weekly),
            const MedsHistoryItem(),
            const MedsHistoryItem(),
            const SizedBox(height: 64),
          ],
        ),
      ),
    );
  }
}

class AddMedicationButton extends StatelessWidget {
  const AddMedicationButton({
    super.key,
    required this.onPressed,
    this.viewportWidthFraction = 1,
  }) : assert(viewportWidthFraction >= 0 && viewportWidthFraction <= 1);
  final VoidCallback onPressed;
  final double viewportWidthFraction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      splashFactory: InkSparkle.splashFactory,
      splashColor: theme.colorScheme.secondary.withValues(alpha: .2),

      borderRadius: BorderRadius.circular(kPadding24),
      onTap: onPressed,
      child: Ink(
        height: 200,
        width: MediaQuery.sizeOf(context).width * viewportWidthFraction,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(kPadding24),
          color: theme.colorScheme.secondaryContainer,
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                HugeIcons.strokeRoundedAdd01,
                color: theme.colorScheme.secondary,
              ),
              Text(
                "Add Medication",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.secondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
