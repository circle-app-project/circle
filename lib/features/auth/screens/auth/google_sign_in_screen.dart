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
    UserPreferences? userPreferences =
        user.preferences ?? UserPreferences.empty;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kPadding16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            AppButton(
                  isLoading:
                      ref.watch(authProvider).isLoading ||
                      ref.watch(userProvider).isLoading,
                  color: theme.colorScheme.primary,
                  overrideIconColor: false,
                  buttonType: ButtonType.secondary,
                  iconPath: "assets/svg/google.svg",
                  onPressed: () async {
                    await authNotifier.singInWithGoogle();
                    await userNotifier.getSelfUserData();

                    ///Notify users when all operations are completed or fails
                    if (context.mounted) {
                      if (authNotifier.isSuccessful &&
                          userNotifier.isSuccessful) {
                        showCustomSnackBar(
                          context: context,
                          message: "Signed in successfully",
                          mode: SnackBarMode.success,
                        );
                        user = ref.watch(userProvider).value!;

                        /// Update User
                        if (context.mounted) {
                          if (userPreferences.isFirstTime) {
                            ///Set as is Not First Time
                            user = user.copyWith(
                              preferences: userPreferences.copyWith(
                                isFirstTime: false,
                              ),
                            );
                            await userNotifier.putUserData(
                              user: user,
                              updateRemote: true,
                            );
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
                      } else if (authNotifier.errorMessage != null ||
                          userNotifier.errorMessage != null) {
                        showCustomSnackBar(
                          context: context,
                          message: authNotifier.errorMessage!,
                          mode: SnackBarMode.error,
                        );
                      }
                    }
                  },
                  label: "Continue",
                )
                .animate()
                .fade(delay: 300.ms, duration: 600.ms)
                .moveY(
                  delay: 300.ms,
                  duration: 600.ms,
                  begin: 64,
                  end: 0,
                  curve: Curves.easeInOut,
                ),
            const Gap(kPadding16),
            const Text("Or").animate().fade(delay: 600.ms, duration: 200.ms),
            FittedBox(
              child: AppButton(
                buttonType: ButtonType.text,
                onPressed: () {
                  context.pushNamed(SignInScreen.id);
                },
                label: "Continue with Email",
              ).animate().fade(delay: 700.ms, duration: 200.ms),
            ),
            const Gap(96),
          ],
        ),
      ),
    );
  }
}
