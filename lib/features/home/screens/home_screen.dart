import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/core.dart';
import '../../auth/auth.dart';
import '../../emergency/emergency.dart';
import '../../profile/profile.dart';
import '../../water/water.dart';
import '../home.dart';

@RoutePage(name: HomeScreen.name)
class HomeScreen extends ConsumerStatefulWidget {
  static const String path = "/home";
  static const String name = "HomeScreen";
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    //Todo: Initialize all data here
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.watch(userNotifierProviderImpl.notifier).getSelfUserData();
      await ref.watch(waterLogNotifierProviderIml.notifier).getWaterLogs();
      await ref.watch(waterPrefsNotifierProviderImpl.notifier).getWaterPreferences();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final AppUser user = ref.watch(userNotifierProviderImpl).value!;

    final waterLogNotifier = ref.watch(waterLogNotifierProviderIml.notifier);

    List<WaterLog>? totalLogsToday = ref.watch(waterLogNotifierProviderIml).value!;

    //Todo: This calculation should be done somewhere in the water notifier and the value just returned.
    double totalToday =
        waterLogNotifier.calculateTotalFromLogs(logs: totalLogsToday);
    //WaterPreferences waterPrefs = ref.watch(waterPreferencesProvider).value!;
    double percentComplete = ((totalToday / 2000) * 100);
    int remaining = 2000 - totalToday.toInt();

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const Gap(64 + 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                                text: "Welcome,",
                                style: theme.textTheme.bodyLarge!
                                    .copyWith(color: AppColours.neutral50)),
                          ],
                        ),
                      ),
                      Text(user.getDisplayName(),
                          style: theme.textTheme.headlineLarge!
                              .copyWith(fontWeight: FontWeight.w700)),
                    ],
                  ),
                  const Spacer(),
                  InkWell(
                    splashColor:
                        theme.colorScheme.primary.withValues(alpha: .2),
                    splashFactory: InkSparkle.splashFactory,
                    borderRadius: BorderRadius.circular(kPadding64),
                    onTap: () {
                      context.router.pushNamed(ProfileScreen.path);
                    },
                    child: CircleAvatar(
                      backgroundImage: user.photoUrl != null
                          ? NetworkImage(user.photoUrl!)
                          : const AssetImage("assets/images/memoji.png")
                              as ImageProvider,
                      radius: 32,
                      backgroundColor: AppColours.neutral90,
                    ),
                  ),
                ],
              ),
              const Gap(kPadding24),
              const FeelingCard(),
              const Gap(kPadding16),
              WaterCard(
                  remaining: remaining,
                  percentageCompleted: percentComplete,
                  totalToday: totalToday.toInt(),
                  onPressed: () {
                    context.router.pushNamed(WaterScreen.path);
                  },
                  unit: Units.millilitres.symbol),
              const Gap(kPadding32),
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Your Health Info",
                    style: theme.textTheme.titleMedium),
              ),
              // const Gap(kPadding16),
              // GestureDetector(
              //     onTap: () {
              //       context.goNamed(MedsScreen.path);
              //     },
              //     child: const MedsReminderCard()),
              const Gap(kPadding16),
              EmergencySharingCard(
                onPressed: () {
                  context.router.pushNamed(EmergencyScreen.path);
                },
              ),
              const SizedBox(
                height: kPadding64 * 2,
              )
            ],
          ),
        ),
      ),
    );
  }
}
