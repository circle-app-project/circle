import 'package:auto_route/auto_route.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

import '../../../components/components.dart';
import '../../../core/core.dart';
import '../meds.dart';

@RoutePage(name: MedsScreen.name)
class MedsScreen extends StatelessWidget {
  static const String path = "/meds";
  static const String name = "MedsScreen";
  const MedsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const CustomAppBar(pageTitle: "Medication"),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Upcoming",
                    style: theme.textTheme.titleMedium,
                  ),
                  const Gap(16),
                  const MedsScreenReminderCard(),
                  const Gap(48),
                  Text(
                    "My Medications",
                    style: theme.textTheme.titleMedium,
                  ),
                  const Gap(16),
                  const MyMedsCard(),
                  const Gap(12),
                  const MyMedsCard(),
                  const Gap(12),
                  const MyMedsCard(),
                  const SizedBox(
                    height: 32,
                  ),
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
                  const SizedBox(
                    height: 48,
                  ),
                  Row(
                    children: [
                      Text(
                        "Today's History",
                        style: theme.textTheme.titleLarge,
                      ),
                      const Spacer(),
                      IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {},
                          icon: SvgPicture.asset("assets/svg/filter.svg"))
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  DateSwitcher(
                      onNextPressed: () {},
                      onPreviousPressed: () {},
                      label: "Today"),
                  const Gap(12),
                  const MedsHistoryItem(
                    mode: MedsHistoryMode.weekly,
                  ),
                  const MedsHistoryItem(),
                  const MedsHistoryItem(),
                  const SizedBox(
                    height: 64,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
