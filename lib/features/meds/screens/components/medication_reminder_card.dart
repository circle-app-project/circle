import 'package:circle/features/meds/models/med_schedule.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:springster/springster.dart';

import '../../../../components/components.dart';
import '../../../../../core/core.dart';
import '../../meds.dart';
import '../../models/medication.dart';
import '../../providers/med_schedule_notifier.dart';

class MedicationReminderCard extends ConsumerStatefulWidget {
  const MedicationReminderCard({
    required this.medSchedule,
    super.key,
    this.viewportWidthFraction = 1,
    this.isEmphasized = false,
  }) : assert(viewportWidthFraction >= 0 && viewportWidthFraction <= 1);

  final MedSchedule medSchedule;

  /// The fraction of the horizontal viewport width this widget should take, should be between 0.0 & 1.0
  final double viewportWidthFraction;
  final bool isEmphasized;

  @override
  ConsumerState<MedicationReminderCard> createState() => _MedicationReminderCardState();
}

class _MedicationReminderCardState extends ConsumerState<MedicationReminderCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;
  final TextEditingController skipReasonController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isSkipReasonFieldVisible = false;
  late final Medication medication;


  @override
  void initState() {

    animationController = AnimationController(vsync: this);
    medication = widget.medSchedule.medication!;
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    skipReasonController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    MedScheduleNotifier medScheduleNotifier = ref.watch(medScheduleNotifierProviderImpl.notifier);
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      splashFactory: InkSparkle.splashFactory,
      splashColor: theme.colorScheme.secondary.withValues(alpha: .2),
      onTap: () {
        showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (context) => const MedsDetailsScreen(),
        );
      },
      child: Ink(
        decoration: BoxDecoration(
          color:
              widget.isEmphasized
                  ? theme.colorScheme.secondary
                  : theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(widget.isEmphasized ? 24 : 16),
          border: Border.all(color: theme.colorScheme.surfaceContainer),
        ),

        ///Todo: Animate the visibility of the skip field
        child: AnimatedContainer(
          width:
              (MediaQuery.sizeOf(context).width * widget.viewportWidthFraction),
          duration: 500.ms,
          curve: Spring.bouncy.toCurve,
          padding: const EdgeInsetsDirectional.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                if (widget.isEmphasized) ...[
                  Text(
                    "Up Next",
                    style: theme.textTheme.bodyMedium!.copyWith(
                      color:
                          widget.isEmphasized
                              ? Colors.white.withValues(alpha: .5)
                              : theme.colorScheme.onSurface.withValues(
                                alpha: .5,
                              ),
                    ),
                  ),
                  const Gap(kPadding8),
                ],
                // Row(
                //   children: [
                //     Text(
                //       "Up Next",
                //       style: theme.textTheme.bodyMedium!.copyWith(
                //         color:
                //         widget.isEmphasized
                //             ? Colors.white
                //             : theme.colorScheme.secondary,
                //       ),
                //     ),
                //
                //     Spacer(),
                //     Align(
                //       alignment: Alignment.centerRight,
                //       child: Container(
                //         padding: const EdgeInsets.symmetric(
                //           horizontal: kPadding12,
                //           vertical: kPadding8,
                //         ),
                //         decoration: BoxDecoration(
                //           color:
                //               widget.isEmphasized
                //                   ? Colors.white.withValues(alpha: .2)
                //                   : theme.colorScheme.secondaryContainer,
                //           borderRadius: BorderRadius.circular(kPadding12),
                //         ),
                //         child: Row(
                //           mainAxisSize: MainAxisSize.min,
                //           children: [
                //             AppIcon(
                //               icon: widget.medication.type!.iconFilled,
                //               iconPath: widget.medication.type!.iconPath,
                //               color:
                //                   widget.isEmphasized
                //                       ? Colors.white
                //                       : theme.colorScheme.secondary,
                //               size: 24,
                //             ),
                //             const Gap(8),
                //             Text(
                //               widget.medication.type!.label,
                //               style: theme.textTheme.bodyMedium!.copyWith(
                //                 color:
                //                     widget.isEmphasized
                //                         ? Colors.white
                //                         : theme.colorScheme.secondary,
                //               ),
                //             ),
                //           ],
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "${medication.name},",
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontSize: widget.isEmphasized ? 22 : 18,
                          color: widget.isEmphasized ? Colors.white : null,
                        ),
                      ),
                      TextSpan(
                        text:
                            " ${widget.medSchedule.dose.amount.toStringAsFixed(0)} ${widget.medSchedule.dose.unit.symbol}",
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontSize: widget.isEmphasized ? 22 : 18,
                          color:
                              widget.isEmphasized
                                  ? Colors.white.withValues(alpha: .5)
                                  : theme.colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(kPadding16),

                /// Dose and Time
                Row(
                  children: [
                    Row(
                      spacing: 8,
                      children: [
                        AppIcon(
                          icon: HugeIcons.strokeRoundedAlertCircle,
                          color:
                              widget.isEmphasized
                                  ? Colors.white
                                  : theme.colorScheme.onSurface.withValues(
                                    alpha: .4,
                                  ),
                        ),
                        Text(
                          "${widget.medSchedule.dose.number.toStringAsFixed(0)} ${medication.type?.label}",
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color:
                                widget.isEmphasized
                                    ? Colors.white
                                    : theme.colorScheme.onSurface.withValues(
                                      alpha: .4,
                                    ),
                          ),
                        ),
                      ],
                    ),

                    const Gap(kPadding24),
                    Row(
                      spacing: 8,
                      children: [
                        AppIcon(
                          icon: HugeIcons.strokeRoundedClock01,
                          color:
                              widget.isEmphasized
                                  ? Colors.white
                                  : theme.colorScheme.onSurface.withValues(
                                    alpha: .4,
                                  ),
                        ),
                        Text(
                          " At ${TimeOfDay.fromDateTime(widget.medSchedule.date).format(context)}",
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color:
                                widget.isEmphasized
                                    ? Colors.white
                                    : theme.colorScheme.onSurface.withValues(
                                      alpha: .4,
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                /// Skip reason text form field
                if (isSkipReasonFieldVisible) ...[
                  const Gap(kPadding16),
                  TextFormField(
                    controller: skipReasonController,
                    maxLines: 3,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSecondary,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please add a reason for skipping this dose";
                      } else {
                        return null;
                      }
                    },
                    decoration: AppInputDecoration.inputDecoration(
                      context,
                    ).copyWith(
                      hintText: "Reason for Skipping",
                      fillColor: theme.colorScheme.onSecondary.withValues(
                        alpha: .2,
                      ),
                      hintStyle: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSecondary.withValues(
                          alpha: .8,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: theme.colorScheme.onSecondary.withValues(
                            alpha: .5,
                          ),
                        ),
                        borderRadius: BorderRadius.circular(kPadding12),
                      ),

                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: theme.colorScheme.onSecondary.withValues(
                            alpha: .5,
                          ),
                        ),
                        borderRadius: BorderRadius.circular(kPadding12),
                      ),

                      errorStyle: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSecondary,
                      ),
                    ),
                  ),
                  const Gap(kPadding16),
                ],

                /// Buttons
                if (widget.isEmphasized) ...[
                  const Gap(kPadding16),
                  Row(
                    spacing: kPadding16,
                    children: [
                      Expanded(
                        child: AppButton(
                          onPressed:
                              isSkipReasonFieldVisible
                                  ? () async {
                                    if (_formKey.currentState!.validate()) {

                                      await medScheduleNotifier.markDoseAsSkipped(
                                        medSchedule: widget.medSchedule,
                                        skipReason: skipReasonController.text.trim(),
                                      );

                                      Future.delayed(
                                        const Duration(milliseconds: 300),
                                        () {
                                          setState(() {
                                            skipReasonController.text = "";
                                            isSkipReasonFieldVisible = false;
                                          });
                                        },
                                      );

                                      if (context.mounted) {
                                        if (ref.watch(medScheduleNotifierProviderImpl).hasError) {
                                          showCustomSnackBar(
                                            context: context,
                                            error: ref.watch(medScheduleNotifierProviderImpl).error,
                                          );
                                        } else {
                                          showCustomSnackBar(
                                            context: context,
                                            message: "Dose skipped",
                                            mode: SnackBarMode.notification,
                                          );
                                        }
                                      }
                                    }
                                  }
                                  : () {
                                    /// Skip field is not visible, so make it visible
                                    setState(() {
                                      isSkipReasonFieldVisible =
                                          !isSkipReasonFieldVisible;
                                    });
                                  },
                          icon: HugeIcons.strokeRoundedStepOver,
                          color: widget.isEmphasized ? Colors.white : null,
                          label: isSkipReasonFieldVisible ? "Continue" : "Skip",
                          isChipButton: true,
                          buttonType: ButtonType.secondary,
                          backgroundColor:
                              widget.isEmphasized
                                  ? Colors.white.withValues(alpha: .3)
                                  : theme.colorScheme.secondaryContainer,
                        ),
                      ),
                      Expanded(
                        child: AppButton(
                          onPressed: () async {
                            await medScheduleNotifier.markDoseAsCompleted(
                              medSchedule: widget.medSchedule,
                            );
                            if (ref.watch(medScheduleNotifierProviderImpl).hasError) {
                              if(context.mounted){
                                showCustomSnackBar(
                                  context: context,
                                  error: ref.watch(medScheduleNotifierProviderImpl).error,
                                );
                              }
                            }
                          },
                          label: "Taken",
                          backgroundColor: AppColours.black,
                          color: AppColours.white,
                          isChipButton: true,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
