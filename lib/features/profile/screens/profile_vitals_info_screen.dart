import 'package:auto_route/auto_route.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';


import '../../../components/components.dart';
import '../../../core/core.dart';
import '../../auth/auth.dart';
import '../profile.dart';

@RoutePage(name: ProfileVitalsInfoScreen.name)
class ProfileVitalsInfoScreen extends ConsumerStatefulWidget {
  static const String path = "/vital_info";
  static const String name = "ProfileVitalsInfoScreen";
  
  final bool? isEditing;
  const ProfileVitalsInfoScreen({super.key, this.isEditing = false});

  @override
  ConsumerState<ProfileVitalsInfoScreen> createState() =>
      _ProfileVitalsInfoScreenState();
}

class _ProfileVitalsInfoScreenState
    extends ConsumerState<ProfileVitalsInfoScreen> {
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Genotype selectedGenotype = Genotype.unknown;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.watch(userNotifierProviderImpl.notifier).getSelfUserData();
      AppUser user = ref.watch(userNotifierProviderImpl).value!;
      UserProfile userProfile = user.profile.target ?? UserProfile.empty;
      heightController.text =
          userProfile.height != null ? userProfile.height.toString() : "";
      weightController.text =
          userProfile.weight != null ? userProfile.weight.toString() : "";

      if (userProfile.genotype != null) {
        setState(() {
          selectedGenotype = userProfile.genotype!;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    heightController.dispose();
    weightController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final UserNotifier userNotifier = ref.watch(
      userNotifierProviderImpl.notifier,
    );
    AppUser user = ref.watch(userNotifierProviderImpl).value!;
    UserProfile userProfile = user.profile.target ?? UserProfile.empty;

    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height,
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  CustomAppBar(
                    pageTitle:
                        widget.isEditing! ? "Edit Vitals" : "Vitals Info",
                    actions:
                        !widget.isEditing!
                            ? [
                              AppButton(
                                isChipButton: true,
                                onPressed: () {
                                  //Todo: Skip Page
                                },
                                label: "Skip",
                                buttonType: ButtonType.text,
                              ),
                            ]
                            : null,
                  ),

                  ///Content
                  Row(
                    children: [
                      SvgPicture.asset(
                        "assets/svg/ruler.svg",
                        colorFilter: ColorFilter.mode(
                          theme.colorScheme.primary,
                          BlendMode.srcIn,
                        ),
                      ),
                      const Gap(4),
                      Text("Your Height", style: theme.textTheme.bodyMedium),
                    ],
                  ),
                  const Gap(8),
                  TextFormField(
                    controller: heightController,
                    keyboardType: TextInputType.number,
                    decoration: AppInputDecoration.inputDecoration(
                      context,
                    ).copyWith(hintText: "Height"),
                  ),
                  const Gap(24),
                  Row(
                    children: [
                      SvgPicture.asset(
                        "assets/svg/weight.svg",
                        colorFilter: ColorFilter.mode(
                          theme.colorScheme.primary,
                          BlendMode.srcIn,
                        ),
                      ),
                      const Gap(4),
                      Text("Your Weight", style: theme.textTheme.bodyMedium),
                    ],
                  ),
                  const Gap(8),
                  TextFormField(
                    controller: weightController,
                    keyboardType: TextInputType.number,
                    decoration: AppInputDecoration.inputDecoration(
                      context,
                    ).copyWith(hintText: "Weight"),
                  ),
                  const Gap(24),
                  Row(
                    children: [
                      SvgPicture.asset(
                        "assets/svg/dna.svg",
                        colorFilter: ColorFilter.mode(
                          theme.colorScheme.primary,
                          BlendMode.srcIn,
                        ),
                      ),
                      const Gap(4),
                      Text("Your Genotype", style: theme.textTheme.bodyMedium),
                    ],
                  ),
                  const Gap(8),
                  GenotypeSelector(
                    onGenotypeSelect: (Genotype genotype) {
                      setState(() {
                        selectedGenotype = genotype;
                      });
                    },
                  ),

                  const Spacer(),

                  ///Buttons
                  AppButton(
                    icon:
                        widget.isEditing!
                            ? FluentIcons.checkmark_24_regular
                            : null,
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        user = user.copyWith(
                          profile: userProfile.copyWith(
                            height: double.tryParse(
                              heightController.text.trim(),
                            ),
                            weight: double.tryParse(
                              weightController.text.trim(),
                            ),
                            genotype: selectedGenotype,
                          ),
                        );

                        if (widget.isEditing!) {
                          ///Always update remote when the user is editing data.
                          ///But do not do that when the user is adding data because
                          ///the user is onboarding for the first time,
                          ///the data will be gathered and saved at the
                          ///end of the onboard process

                          await userNotifier.putUserData(
                            user: user,
                            updateRemote: true,
                          );

                          ///Also show snack bars when making remote calls
                          if (context.mounted) {
                            if (ref.watch(userNotifierProviderImpl).hasError) {
                              showCustomSnackBar(
                                context: context,
                                message: "Something went wrong",
                                mode: SnackBarMode.error,
                              );
                            } else {
                              showCustomSnackBar(
                                context: context,
                                message: "Profile Updated",
                                mode: SnackBarMode.success,
                              );
                            }
                          }
                        } else {
                          await userNotifier.putUserData(
                            user: user,
                            updateRemote: false,
                          );
                          if (context.mounted) {
                            if (ref.watch(userNotifierProviderImpl).hasError) {
                              showCustomSnackBar(
                                context: context,
                                message: "Something went wrong",
                                mode: SnackBarMode.error,
                              );
                            } else {
                              context.router.pushNamed(ProfileMedicalInfoScreen.path);
                            }
                          }
                        }
                      }
                    },
                    label: widget.isEditing! ? "Save" : "Continue",
                  ),
                  const Gap(64),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
