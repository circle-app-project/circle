import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:circle/core/core.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../components/bottom_nav_bar.dart';
import '../../../components/components.dart';
import '../../auth/auth.dart';
import '../water.dart';

@RoutePage(name: SuggestedWaterDailyGoalScreen.name)
class SuggestedWaterDailyGoalScreen extends ConsumerStatefulWidget {
  static const String path = "/suggested_daily_goal";
  static const String name = "SuggestedWaterDailyGoalScreen";
  const SuggestedWaterDailyGoalScreen({super.key});

  @override
  ConsumerState<SuggestedWaterDailyGoalScreen> createState() =>
      _SuggestedWaterDailyGoalScreenState();
}

double defaultDailyGoal = 2000;

class _SuggestedWaterDailyGoalScreenState
    extends ConsumerState<SuggestedWaterDailyGoalScreen> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    WaterPrefsNotifier waterPrefsNotifier =
        ref.watch(waterPrefsNotifierProviderImpl.notifier);
    WaterPreferences? preferences = ref.watch(waterPrefsNotifierProviderImpl).value;
    AppUser user = ref.watch(userNotifierProviderImpl).value!;

    return Scaffold(
      body: Column(
        spacing: kPadding16,
        children: [
          CustomAppBar(
            showTitle: false,
            pageTitle: "Your daily goal",
            actions: [
              AppButton(
                  isChipButton: true,
                  onPressed: () {
                    context.router.pushNamed(BottomNavBar .path);
                  },
                  label: "Skip",
                  buttonType: ButtonType.text),
            ],
          ),
          Text(
            "Your daily goal",
            style: theme.textTheme.headlineMedium,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
                "Based on the information you submitted, we suggest you drink this much water in a day",
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium),
          ),
          const Gap(48),
          Text("$defaultDailyGoal ml",
              style: theme.textTheme.displaySmall!
                  .copyWith(color: theme.colorScheme.primary)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
                "We’ll remind you periodically to drink, you can also change your reminder preferences here.",
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              spacing: kPadding16,
              children: [
                AppButton(
                  isLoading: ref.watch(waterPrefsNotifierProviderImpl).isLoading,
                  onPressed: () async {
                    preferences = preferences?.copyWith(
                      defaultDailyGoal: defaultDailyGoal,
                    );
                    await waterPrefsNotifier.putWaterPreferences(
                        preferences: preferences!, user: user);
                    if (context.mounted) {
                      if(ref.watch(waterPrefsNotifierProviderImpl).hasError){
                        showCustomSnackBar(
                            context: context,
                            message: "Failed to add data",
                            mode: SnackBarMode.error);
                      }else{
                        showCustomSnackBar(
                            context: context,
                            message: "Preferences Updated",
                            mode: SnackBarMode.success);
                        context.router.pushNamed(BottomNavBar .path);
                      }
                    }
                  },
                  label: "Accept Goal & Continue",
                ),
                AppButton(
                  label: "Change Goal",
                  icon: HugeIcons.strokeRoundedPencilEdit02,
                  buttonType: ButtonType.outline,

                  onPressed: () async {
                    await showModalBottomSheet(
                      context: context,
                      builder: (context) => AppBottomSheet(
                        title: "Select Volume",
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: ListWheelScrollViewPicker(
                          primaryInitialValue: 1000,
                          primaryFinalValue: 5000,
                          primaryValueInterval: 100,
                          primaryUnitLabels: const ["ml"],
                          onSelectedItemChanged: (selectedValue) {
                            setState(() {
                              defaultDailyGoal = selectedValue;
                            });
                          },
                        ),
                      ),
                    );
                  },

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
