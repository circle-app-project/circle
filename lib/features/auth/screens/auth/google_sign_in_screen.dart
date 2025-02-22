import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import 'package:hugeicons/hugeicons.dart';
import 'package:springster/springster.dart';

import '../../../../components/bottom_nav_bar.dart';
import '../../../../components/components.dart';
import '../../../../core/core.dart';
import '../../../../gen/assets.gen.dart';
import '../../../profile/profile.dart';
import '../../auth.dart';
@RoutePage(name: GoogleSignInScreen.name)
class GoogleSignInScreen extends ConsumerStatefulWidget {
  static const String path = "/google_sign_in";
  static const String name = "GoogleSignInScreen";
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
                iconIgnoresLabelColor: true,
                  buttonType: ButtonType.primary,
                  iconPath: Assets.svg.googleLogoColor,
                  label: "Continue",
                  onPressed: () async {
                    await authNotifier.singInWithGoogle();
                    if (ref.watch(authNotifierProviderIml).hasError) {
                      if (context.mounted) {
                        showCustomSnackBar(
                          context: context,
                          error: ref.watch(authNotifierProviderIml).error,
                          mode: SnackBarMode.error,
                        );
                      }
                    } else {
                      await userNotifier.getSelfUserData();

                      ///Notify users when all operations are completed or fails
                      if (context.mounted) {
                        if (ref.watch(userNotifierProviderImpl).hasError) {
                          showCustomSnackBar(
                            context: context,
                            error: ref.watch(userNotifierProviderImpl).error,
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
                              context.router.pushNamed(AuthSuccessScreen.path);
                            }
                          } else {
                            if (userPreferences.isOnboarded) {
                              context.router.pushNamed(BottomNavBar.path);
                            } else {
                              context.router.pushNamed(ProfileBasicInfoScreen.path);
                            }
                          }
                        }
                      }
                    }
                  },

                )
                .animate()
                .fadeIn(duration: 300.ms)
                .moveY(
                  delay: 200.ms,
                  duration: 800.ms,
                  begin: 64,
                  end: 0,
                  curve: Spring.defaultIOS.toCurve,
                ),
            const Gap(kPadding16),
            AppButton(
                  buttonType: ButtonType.outline,
                  onPressed: () {
                    context.router.pushNamed(SignInScreen.path);
                  },
                  color: theme.colorScheme.onSurface,
                  icon: HugeIcons.strokeRoundedMail01,
                  label: "Continue with Email",
                )
                .animate(delay: 300.ms)
                .fadeIn(duration: 300.ms)
                .moveY(
                  duration: 800.ms,
                  begin: 64,
                  end: 0,
                  curve: Spring.defaultIOS.toCurve,
                ),

            const Gap(64),
          ],
        ),
      ),
    );
  }
}
