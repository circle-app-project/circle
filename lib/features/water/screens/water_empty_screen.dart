import 'package:auto_route/annotations.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:circle/core/core.dart';

import '../../../components/components.dart';

@RoutePage(name: WaterEmptyScreen.name)
class WaterEmptyScreen extends StatefulWidget {
  static const String path = "/water_goal_empty";
  static const String name = "WaterEmptyScreen";
  const WaterEmptyScreen({super.key});

  @override
  State<WaterEmptyScreen> createState() => _WaterEmptyScreenState();
}

int dailyGoal = 2000;

class _WaterEmptyScreenState extends State<WaterEmptyScreen> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      body: Column(
        children: [
          const CustomAppBar(
            showTitle: true,
            pageTitle: "Water Intake",
            actions: [],
          ),
          const Gap(66),
          Container(
            height: 200,
            width: 200,
            decoration: BoxDecoration(
                color: AppColours.blue80,
                borderRadius: BorderRadius.circular(100)),
          ),
          const Gap(16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
                "you do not have any water goal. Click on the button below to add a water goal.",
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const Gap(16),
                AppButton(
                  onPressed: () {},
                  icon: FluentIcons.add_24_regular,
                  label: "Add Goal ",
                ),
              ],
            ),
          ),
          const Gap(64)
        ],
      ),
    );
  }
}
