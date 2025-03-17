import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:springster/springster.dart';

import '../../../../components/components.dart';
import '../../../../../core/core.dart';
import '../../meds.dart';
import '../../models/medication.dart';

class MedicationCard extends StatefulWidget {
  const MedicationCard({
    required this.medication,
    super.key,
    this.viewportWidthFraction = 1,
  }) : assert(viewportWidthFraction >= 0 && viewportWidthFraction <= 1);

  final Medication medication;

  /// The fraction of the horizontal viewport width this widget should take, should be between 0.0 & 1.0
  final double viewportWidthFraction;
  @override
  State<MedicationCard> createState() => _MedicationCardState();
}

class _MedicationCardState extends State<MedicationCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
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
          color:  theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: theme.colorScheme.surfaceContainer),
        ),
        child: AnimatedContainer(
          width:
              (MediaQuery.sizeOf(context).width *
                  widget.viewportWidthFraction),
          duration: 500.ms,
          curve: Spring.bouncy.toCurve,
          padding: const EdgeInsetsDirectional.fromSTEB(20, 16, 16, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: kPadding12,
                    vertical: kPadding8,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(kPadding12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [


                      AppIcon(
                        icon: med.type!.iconFilled,
                        iconPath: (med.type?.iconFilled != null && med.type?.iconPath != null) ? null: med.type!.iconPath,
                        color: theme.colorScheme.secondary,
                        size: 24,
                      ),
                      const Gap(8),
                      Text(
                        widget.medication.type!.label,
                        style: theme.textTheme.bodyMedium!.copyWith(
                          color: theme.colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const Gap(kPadding16),

              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "${med.name},",
                      style: theme.textTheme.titleLarge?.copyWith(
                        // color: theme.colorScheme.onSecondary,
                      ),
                    ),
                    TextSpan(
                      text:
                          " ${widget.medication.dose?.dose.toStringAsFixed(0) ?? ""} ${widget.medication.dose?.unit.symbol ?? ""}",
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(kPadding16),
              Row(
                spacing: kPadding8,
                children: [
                  // Container(
                  //   padding: const EdgeInsets.symmetric(
                  //     horizontal: kPadding12,
                  //     vertical: kPadding8,
                  //   ),
                  //   decoration: BoxDecoration(
                  //     color: theme.colorScheme.secondaryContainer,
                  //     borderRadius: BorderRadius.circular(kPadding12),
                  //   ),
                  //   child: RichText(
                  //     text: TextSpan(
                  //       children: [
                  //         TextSpan(
                  //           text:
                  //               widget.medication.dose?.dose.toStringAsFixed(
                  //                 0,
                  //               ) ??
                  //               "",
                  //           style: theme.textTheme.bodyLarge?.copyWith(
                  //             color: theme.colorScheme.onSecondaryContainer,
                  //           ),
                  //         ),
                  //         TextSpan(
                  //           text:
                  //               " ${widget.medication.dose?.unit.symbol ?? ""}",
                  //           style: theme.textTheme.bodyLarge?.copyWith(
                  //             color: theme.colorScheme.onSecondaryContainer,
                  //           ),
                  //         ),
                  //         TextSpan(
                  //           text: "/pill",
                  //           style: theme.textTheme.bodyLarge?.copyWith(
                  //             color: theme.colorScheme.onSecondaryContainer,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  AppChip(
                    label:
                        "${med.dose?.dose.toInt() ?? ""} ${med.dose?.unit.symbol ?? ""}/pill",
                    icon: FluentIcons.pill_16_regular,
                    color: theme.colorScheme.onSecondaryContainer,
                    backgroundColor: theme.colorScheme.surfaceContainerLow,
                    borderRadius: kPadding12,
                  ),

                  AppChip(
                    label: "1 Pill",
                    icon: FluentIcons.pill_16_regular,
                    color: theme.colorScheme.onSecondaryContainer,
                    backgroundColor: theme.colorScheme.surfaceContainerLow,
                    borderRadius: kPadding12,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//  Row(
// ///The Compressed Mode
// children: [
// Container(
// height: 40,
// width: 40,
// decoration: BoxDecoration(
// shape: BoxShape.circle,
// color: theme.colorScheme.primaryContainer),
// child: Center(
// child: SvgPicture.asset(
// "assets/svg/medication.svg",
// colorFilter: ColorFilter.mode(
// theme.colorScheme.primary, BlendMode.srcIn),
// ),
// ),
// ),
// const Gap(16),
// RepaintBoundary(
// child: Column(
// mainAxisSize: MainAxisSize.min,
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// Text(
// "Hydroxyl Urea",
// style: theme.textTheme.bodyLarge,
// )
//     .animate()
//     .slideX(
// curve: Curves.easeOut,
// duration: 500.ms,
// begin: .3,
// end: 0)
//     .fadeIn(
// delay: 200.ms,
// curve: Curves.easeOut,
// duration: 500.ms),
// SizedBox(height: widget.isCurrent ? 16 : 8),
// Text(
// "8:00 pm",
// style: theme.textTheme.bodyMedium,
// )
//     .animate(delay: 500.ms)
//     .fadeIn(
// delay: 200.ms,
// curve: Curves.easeOut,
// duration: 500.ms)
//     .slideX(
// curve: Curves.easeOut,
// duration: 500.ms,
// begin: .3,
// end: 0),
// ],
// ),
// ),
// const Spacer(),
// SicklerButton(
// isChipButton: true,
// icon: FluentIcons.check_20_regular,
// buttonType: ButtonType.outline,
// onPressed: () {},
// label: "Taken")
// ],
// ),
