import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth.dart';
import 'package:circle/core/routes/routes.gr.dart' as route;


@RoutePage(name: LoadingScreen.name)
class LoadingScreen extends ConsumerStatefulWidget {
  static const String name = "LoadingScreen";
  static const String path = "/loading";
  const LoadingScreen({super.key});

  @override
  ConsumerState<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends ConsumerState<LoadingScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await evaluateInitialLocation(context);
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    //Todo:Replace this scaffold with either a static or animated splash screen;
    return const Scaffold(
        //     backgroundColor: Colors.red,
        //      body: Center(
        //        child: FittedBox(child: CircularProgressIndicator()),
        //      ),
        );
  }

  Future<void> evaluateInitialLocation(BuildContext context) async {
    log("Evaluating Initial Route", name: "Loading Screen");
    final userNotifier = ref.watch(userNotifierProviderImpl.notifier);
    await userNotifier.getSelfUserData();
    final AppUser user = ref.watch(userNotifierProviderImpl).value!;
    UserPreferences userPreferences =
        user.preferences ?? UserPreferences.empty;
    final bool isFirstTime = userPreferences.isFirstTime;
    final bool isOnboardingComplete = userPreferences.isOnboarded;
    final bool isLoggedIn = user.isNotEmpty;
    if (context.mounted) {
      //Todo: Add logs to this page
      if (isLoggedIn) {
        if (!isOnboardingComplete) {
          ///not onboarded
          context.router.popAndPush(route.ProfileBasicInfoScreen());
        } else {
          ///Logged in and onboarded
          context.router.popAndPush(const route.BottomNavBar());
        }
      } else {
        ///Is not Logged In
        if (isFirstTime) {
          context.router.popAndPush(const route.OnboardingBaseScreen());
        } else {
          context.router.popAndPush(const route.GoogleSignInScreen());
        }
      }
    }
  }
}
