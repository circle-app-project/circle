import 'package:auto_route/auto_route.dart';
import 'package:circle/features/meds/models/scheduled_doses.dart';
import 'package:circle/features/meds/providers/med_schedule_notifier.dart';
import 'package:circle/features/meds/screens/components/medication_reminder_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  List<ScheduledDose> upcomingDosesForToday = [];
  List<ScheduledDose> allDosesForToday = [];
  List<ScheduledDose> pastDosesForToday = [];



  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(medNotifierProviderImpl.notifier).getMedications();
      await ref.read(medScheduleNotifierProviderImpl.notifier).calculateDosesForToday();
      upcomingDosesForToday =
          ref.watch(medScheduleNotifierProviderImpl.notifier).upcomingDosesForToday;
      pastDosesForToday =
          ref.watch(medScheduleNotifierProviderImpl.notifier).pastDosesForToday;
      allDosesForToday =
          ref.watch(medScheduleNotifierProviderImpl.notifier).allDosesForToday;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Medication> medications =
        ref.watch(medNotifierProviderImpl).value ?? [];
    List<ScheduledDose> medicationSchedule =
        ref.watch(medScheduleNotifierProviderImpl).value ?? [];

    if (medications.isEmpty) {
      print("No medications");
    } else {
      print(
        "number of medication activity records for this medication: ${medications.first.activityRecord.length}",
      );

      print(
        "LIST OF DOSES FOR TODAY FOR THIS MEDICATION IS : $upcomingDosesForToday",
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

            if (upcomingDosesForToday.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: kPadding16),
                child: Column(
                  spacing: kPadding12,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Next Dose", style: theme.textTheme.titleMedium),
                    MedicationReminderCard(
                      medSchedule: upcomingDosesForToday.first,
                      isEmphasized: true,
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

            /// Upcoming Doses

            ///Todo: subtract the first does from this list because its already in the emphasized next dose seciont at the top
            /// then prolly show some nice illustration saying you;re all done for the day or smth
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kPadding16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text("Upcoming Doses", style: theme.textTheme.titleMedium),
                  const Gap(kPadding8),
                  ListView.separated(
                    itemCount: upcomingDosesForToday.length,
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    separatorBuilder: (context, index) => const Gap(kPadding8),
                    itemBuilder: (context, index) {
                      return MedicationReminderCard(
                        medSchedule: upcomingDosesForToday[index],
                        isEmphasized: false,
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            /// Past Doses
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kPadding16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text("Past Doses", style: theme.textTheme.titleMedium),
                  const Gap(kPadding8),
                  ListView.separated(
                    itemCount: pastDosesForToday.length,
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    separatorBuilder: (context, index) => const Gap(kPadding8),
                    itemBuilder: (context, index) {
                      return MedicationReminderCard(
                        medSchedule: pastDosesForToday[index],
                        isEmphasized: false,
                      );
                    },
                  ),
                ],
              ),
            ),
            const Gap( 64),
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
