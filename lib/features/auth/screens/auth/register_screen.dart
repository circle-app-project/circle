import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../components/bottom_nav_bar.dart';
import '../../../../components/components.dart';
import '../../../../core/core.dart';
import '../../../profile/profile.dart';
import '../../auth.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  static const String id = "register";
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscurePasswordText = true;
  bool _obscureConfirmPasswordText = true;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    bool isDarkMode = theme.brightness == Brightness.dark;
    final authNotifier = ref.read(authNotifierProviderIml.notifier);
    final userNotifier = ref.read(userNotifierProviderImpl.notifier);
    AppUser user = ref.watch(userNotifierProviderImpl).value!;
    UserPreferences userPreferences = user.preferences ?? UserPreferences.empty;

    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const CustomAppBar(pageTitle: "Register", showBackButton: false),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
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
                        obscureText: _obscurePasswordText,
                        decoration: AppInputDecoration.inputDecoration(
                          context,
                        ).copyWith(
                          hintText: "Password",
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscurePasswordText = !_obscurePasswordText;
                              });
                            },
                            icon: SvgPicture.asset(
                              _obscurePasswordText
                                  ? "assets/svg/eye.svg"
                                  : "assets/svg/eye-off.svg",
                              colorFilter: ColorFilter.mode(
                                !isDarkMode
                                    ? theme.colorScheme.primary
                                    : theme.iconTheme.color!,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please input an password";
                          } else if (value.length < 8) {
                            return "Password cannot be less than 8 characters";
                          } else {
                            return null;
                          }
                        },
                      ),
                      const Gap(24),
                      Text(
                        "Confirm Password",
                        style: theme.textTheme.bodyMedium,
                      ),
                      const Gap(8),
                      TextFormField(
                        controller: confirmPasswordController,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: _obscureConfirmPasswordText,
                        decoration: AppInputDecoration.inputDecoration(
                          context,
                        ).copyWith(
                          hintText: "Confirm Password",
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscureConfirmPasswordText =
                                    !_obscureConfirmPasswordText;
                              });
                            },
                            icon: SvgPicture.asset(
                              _obscureConfirmPasswordText
                                  ? "assets/svg/eye.svg"
                                  : "assets/svg/eye-off.svg",
                              colorFilter: ColorFilter.mode(
                                !isDarkMode
                                    ? theme.colorScheme.primary
                                    : theme.iconTheme.color!,
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
                          } else if (value != passwordController.text.trim()) {
                            return "Passwords don't match";
                          } else {
                            return null;
                          }
                        },
                      ),
                      const Gap(32),
                      const Spacer(),

                      ///Buttons
                      AppButton(
                        isLoading:
                            ref.watch(authNotifierProviderIml).isLoading ||
                            ref.watch(userNotifierProviderImpl).isLoading,
                        label: "Sign Up",
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await authNotifier.registerWithEmailAndPassword(
                              email: emailController.text.trim(),
                              password: passwordController.text.trim(),
                            );
                            await userNotifier.getSelfUserData();

                            ///Notify users when all operations are completed or fails
                            if (context.mounted) {
                              if (ref.watch(authNotifierProviderIml).hasError ||
                                  ref
                                      .watch(userNotifierProviderImpl)
                                      .hasError) {
                                showCustomSnackBar(
                                  context: context,
                                  error:
                                      ref
                                          .watch(authNotifierProviderIml)
                                          .error ??
                                      ref.watch(userNotifierProviderImpl).error,
                                );
                              } else {
                                showCustomSnackBar(
                                  context: context,
                                  message: "Signed in successfully",
                                  mode: SnackBarMode.success,
                                );
                                user =
                                    ref.watch(userNotifierProviderImpl).value!;

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
                                      context.goNamed(
                                        ProfileBasicInfoScreen.id,
                                      );
                                    }
                                  }
                                }
                              }
                            }
                          }
                        },
                      ),
                      const Gap(16),

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
                              // context.pushReplacementNamed(SignInScreen.id);

                              context.goNamed(SignInScreen.id);

                              // Navigator.push(context, MaterialPageRoute(builder: (context)=> const SignInScreen()));
                            },
                            label: "Sign In Instead",
                          ),
                        ),
                      ),
                      const Gap(32),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
