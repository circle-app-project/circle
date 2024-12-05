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

class SignInScreen extends ConsumerStatefulWidget {
  static const String id = "sign_in";
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
    final authNotifier = ref.read(authProvider.notifier);
    final userNotifier = ref.read(userProvider.notifier);

    AppUser user = ref.watch(userProvider).value!;
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
                  isLoading: ref.watch(authProvider).isLoading || ref.watch(userProvider).isLoading,
                  label: "Sign In",
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await authNotifier.signInWithEmailAndPassword(
                        email: emailController.text.trim(),
                        password: passwordController.text.trim(),
                      );
                      await userNotifier.getSelfUserData();
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

                      ///Notify users when all operations are completed or fails
                      Future.microtask(() {
                        if (context.mounted) {
                          if (authNotifier.isSuccessful &&
                              userNotifier.isSuccessful) {
                            showCustomSnackBar(
                              context: context,
                              message: "Signed in successfully",
                              mode: SnackBarMode.success,
                            );
                          } else if (authNotifier.errorMessage != null ||
                              userNotifier.errorMessage != null) {
                            showCustomSnackBar(
                              context: context,
                              message: authNotifier.errorMessage!,
                              mode: SnackBarMode.error,
                            );
                          }
                        }
                      });
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
                        context.goNamed(RegisterScreen.id);
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
