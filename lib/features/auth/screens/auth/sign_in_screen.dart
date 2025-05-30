import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

import '../../../../components/bottom_nav_bar.dart';
import '../../../../components/components.dart';
import '../../../../core/core.dart';
import '../../../profile/profile.dart';
import '../../auth.dart';

@RoutePage(name: SignInScreen.name)
class SignInScreen extends ConsumerStatefulWidget {
  static const String path = "/sign_in";
  static const String name = "SignInScreen";
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscureText = true;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
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
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: kPadding16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomAppBar(pageTitle: "Sign In", showBackButton: false),
                Text("Email", style: theme.textTheme.bodyMedium),
                const Gap(8),
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: AppInputDecoration.inputDecoration(
                    context,
                  ).copyWith(hintText: "Email"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please input an email";
                    } else {
                      return null;
                    }
                  },
                ),
                const Gap(24),
                Text("Password", style: theme.textTheme.bodyMedium),
                const Gap(8),
                TextFormField(
                  controller: passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: _obscureText,
                  decoration: AppInputDecoration.inputDecoration(
                    context,
                  ).copyWith(
                    hintText: "Password",
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                      icon: SvgPicture.asset(
                        _obscureText
                            ? "assets/svg/eye.svg"
                            : "assets/svg/eye-off.svg",
                        colorFilter: ColorFilter.mode(
                          theme.iconTheme.color!,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please input a password";
                    } else if (value.length < 8) {
                      return "Password cannot be less than 8 characters";
                    } else {
                      return null;
                    }
                  },
                ),

                const Gap(16),
                const Spacer(),

                ///Buttons
                AppButton(
                  isLoading:
                      ref.watch(authNotifierProviderIml).isLoading ||
                      ref.watch(userNotifierProviderImpl).isLoading,
                  label: "Sign In",
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await authNotifier.signInWithEmailAndPassword(
                        email: emailController.text.trim(),
                        password: passwordController.text.trim(),
                      );
                      await userNotifier.getSelfUserData();

                      ///Notify users when all operations are completed or fails
                      if (context.mounted) {
                        /// If error occurs
                        if (ref.watch(authNotifierProviderIml).hasError ||
                            ref.watch(userNotifierProviderImpl).hasError) {
                          showCustomSnackBar(
                            context: context,
                            error:
                                ref.watch(authNotifierProviderIml).error ??
                                ref.watch(userNotifierProviderImpl).error,
                          );
                        } else {
                          /// If successful
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
                    }
                  },
                ),
                const Gap(kPadding16),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "or",
                    style: theme.textTheme.bodyMedium!.copyWith(
                      color: AppColours.neutral50,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: FittedBox(
                    child: AppButton(
                      isChipButton: true,
                      buttonType: ButtonType.text,
                      onPressed: () {
                        context.router.pushNamed(RegisterScreen.path);
                      },
                      label: "Create an Account",
                    ),
                  ),
                ),
                const Gap(48),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
