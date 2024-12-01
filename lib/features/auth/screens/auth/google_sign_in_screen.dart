import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../components/bottom_nav_bar.dart';
import '../../../../components/components.dart';
import '../../../../core/core.dart';
import '../../../profile/profile.dart';
import '../../auth.dart';


class GoogleSignInScreen extends ConsumerStatefulWidget {
  static const String id = "google_sign_in";
  const GoogleSignInScreen({super.key});

  @override
  ConsumerState<GoogleSignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<GoogleSignInScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final authNotifier = ref.read(authProvider.notifier);
    final userNotifier = ref.read(userProvider.notifier);
    AppUser user = ref.watch(userProvider).value!;
    UserPreferences userPreferences = user.preferences.target ?? UserPreferences.empty;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kPadding16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            AppButton(
                    isLoading: ref.watch(authProvider).isLoading,
                    color: theme.colorScheme.primary,
                    overrideIconColor: false,
                    buttonType: ButtonType.secondary,
                    iconPath: "assets/svg/google.svg",
                    onPressed: () async {
                      await authNotifier.singInWithGoogle();

                      if (authNotifier.isSuccessful) {
                        await userNotifier.getCurrentUserData(); //Might not be super necessary tho, should probably set up a stream to just listen for changes to the user.
                        if (context.mounted) {
                          showCustomSnackBar(
                              context: context,
                              message: "Signed in successfully",
                              mode: SnackBarMode.success);
                          if (userPreferences.isFirstTime) {
                            ///Set as is Not First Time
                            await userNotifier.putUserData(
                                user: user.copyWith(
                                    preferences: userPreferences
                                        .copyWith(isFirstTime: false)));

                            if (context.mounted) {
                              context.goNamed(AuthSuccessScreen.id);
                            }
                          } else {
                            if (userPreferences.isOnboarded) {
                              context.goNamed(BottomNavBar.id);
                            } else {
                              context.goNamed(ProfileBasicInfoScreen.id);
                            }
                          }
                        }
                      } else if (authNotifier.errorMessage != null) {
                        if (context.mounted) {
                          showCustomSnackBar(
                              context: context,
                              message: authNotifier.errorMessage!,
                              mode: SnackBarMode.error);
                        }
                      }
                    },
                    label: "Continue")
                .animate()
                .fade(delay: 300.ms, duration: 600.ms)
                .moveY(
                    delay: 300.ms,
                    duration: 600.ms,
                    begin: 64,
                    end: 0,
                    curve: Curves.easeInOut),
            const Gap(kPadding16),
            const Text("Or").animate().fade(delay: 600.ms, duration: 200.ms),
            FittedBox(
              child: AppButton(
                      buttonType: ButtonType.text,
                      onPressed: () {
                        context.pushNamed(SignInScreen.id);
                      },
                      label: "Continue with Email")
                  .animate()
                  .fade(delay: 700.ms, duration: 200.ms),
            ),
            const Gap(kPadding32),
          ],
        ),
      ),
    );
  }
}
