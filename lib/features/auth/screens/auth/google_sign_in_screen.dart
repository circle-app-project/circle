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
    final authNotifier = ref.read(authNotifierProviderIml.notifier);
    final userNotifier = ref.read(userNotifierProviderImpl.notifier);
    AppUser user = ref.watch(userNotifierProviderImpl).value!;
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
                      ref.watch(authNotifierProviderIml).isLoading ||
                      ref.watch(userNotifierProviderImpl).isLoading,
                  color: theme.colorScheme.primary,
                  overrideIconColor: false,
                  buttonType: ButtonType.secondary,
                  iconPath: "assets/svg/google.svg",
                  onPressed: () async {
                    await authNotifier.singInWithGoogle();
                    await userNotifier.getSelfUserData();

                    ///Notify users when all operations are completed or fails
                    if (context.mounted) {
                      if (ref.watch(userNotifierProviderImpl).hasError) {
                        showCustomSnackBar(
                          context: context,
                          error: ref.watch(userNotifierProviderImpl).error!,
                          mode: SnackBarMode.error,
                        );
                      } else {
                        // Assume Successful
                        showCustomSnackBar(
                          context: context,
                          message: "Signed in successfully",
                          mode: SnackBarMode.success,
                        );
                        user = ref.watch(userNotifierProviderImpl).value!;
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
                      }
                    }
                  },
                  label: "Continue",
                )
                .animate()
                .fade(delay: 100.ms, duration: 300.ms)
                .moveY(
                  delay: 100.ms,
                  duration: 300.ms,
                  begin: 64,
                  end: 0,
                  curve: Curves.easeInOutQuart,
                ),
            const Gap(kPadding16),
            FittedBox(
              child: AppButton(
                buttonType: ButtonType.text,
                onPressed: () {
                  context.pushNamed(SignInScreen.id);
                },
                label: "Continue with Email",
              ).animate().fade(delay: 300.ms, duration: 200.ms),
            ),
            const Gap(64),
          ],
        ),
      ),
    );
  }
}
