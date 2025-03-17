import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:springster/springster.dart';

import '../../../../components/components.dart';
import '../../../../../core/core.dart';
import '../../meds.dart';
import '../../models/medication.dart';

class MedicationReminderCard extends StatefulWidget {
  const MedicationReminderCard({
    required this.medication,
    super.key,
    this.viewportWidthFraction = 1,
    this.isEmphasized = false,
    required this.onMarkAsSkipped,
    required this.onMarkAsTaken,
  }) : assert(viewportWidthFraction >= 0 && viewportWidthFraction <= 1);

  final Medication medication;

  /// The fraction of the horizontal viewport width this widget should take, should be between 0.0 & 1.0
  final double viewportWidthFraction;
  final bool isEmphasized;
  final VoidCallback onMarkAsTaken;
  final VoidCallback onMarkAsSkipped;

  @override
  State<MedicationReminderCard> createState() => _MedicationReminderCardState();
}

class _MedicationReminderCardState extends State<MedicationReminderCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;
  final TextEditingController skipReasonController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isSkipReasonFieldVisible = false;

  @override
  void initState() {
    animationController = AnimationController(vsync: this);
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
    Medication med = widget.medication;
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
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: theme.colorScheme.surfaceContainer),
        ),
        ///Todo: Animate the visibilty of the skip field
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
                Text(
                  "Up Next",
                  style: theme.textTheme.bodyMedium!.copyWith(
                    color:
                        widget.isEmphasized
                            ? Colors.white.withValues(alpha: .5)
                            : theme.colorScheme.onSurface.withValues(alpha: .5),
                  ),
                ),
                const Gap(kPadding8),
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
                        text: "${med.name},",
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: widget.isEmphasized ? Colors.white : null,
                        ),
                      ),
                      TextSpan(
                        text:
                            " ${widget.medication.dose?.dose.toStringAsFixed(0) ?? ""} ${widget.medication.dose?.unit.symbol ?? ""}",
                        style: theme.textTheme.titleLarge?.copyWith(
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
                Row(
                  children: [
                    Row(
                      spacing: 8,
                      children: [
                        AppIcon(
                          icon: HugeIcons.strokeRoundedAlertCircle,
                          color: widget.isEmphasized ? Colors.white : null,
                        ),
                        Text(
                          "1 pill",
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: widget.isEmphasized ? Colors.white : null,
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
                          color: widget.isEmphasized ? Colors.white : null,
                        ),
                        Text(
                          " At ${med.frequency?.times?.first.format(context)}", // Todo: Properly sort this to find the date of the next dose.
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: widget.isEmphasized ? Colors.white : null,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Gap(kPadding16),
                if (isSkipReasonFieldVisible)
           ...[  TextFormField(
                  controller: skipReasonController,
                  maxLines: 3,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSecondary
                  ),
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
                    )
                      , focusedBorder:  OutlineInputBorder(
                    borderSide: BorderSide(
                      color: theme.colorScheme.onSecondary,

                  ),
                    borderRadius: BorderRadius.circular(kPadding12),

                  ),
                ),),
                const Gap(kPadding16)],
                Row(
                  spacing: kPadding16,
                  children: [
                    Expanded(
                      child: AppButton(
                        onPressed: () async {

                          if(!isSkipReasonFieldVisible){
                            setState(() {
                              isSkipReasonFieldVisible = !isSkipReasonFieldVisible;
                            });
                          }

                          if(isSkipReasonFieldVisible){
                            widget.onMarkAsSkipped.call();
                          }

                        },
                        icon: HugeIcons.strokeRoundedStepOver,
                        color: widget.isEmphasized ? Colors.white : null,
                        label: isSkipReasonFieldVisible? "Continue": "Skip",
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
                        onPressed: widget.onMarkAsTaken,
                        label: "Taken",
                        backgroundColor: AppColours.black,
                        color: AppColours.white,
                        isChipButton: true,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
