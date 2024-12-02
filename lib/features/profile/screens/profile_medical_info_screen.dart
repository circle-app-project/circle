import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../components/bottom_nav_bar.dart';
import '../../../components/components.dart';
import '../../../core/core.dart';
import '../../auth/auth.dart';
import '../../water/water.dart';

class ProfileMedicalInfoScreen extends ConsumerStatefulWidget {
  static const String id = "medical_info";
  final bool? isEditing;
  const ProfileMedicalInfoScreen({super.key, this.isEditing = false});

  @override
  ConsumerState<ProfileMedicalInfoScreen> createState() =>
      _ProfileMedicalInfoScreenState();
}

class _ProfileMedicalInfoScreenState
    extends ConsumerState<ProfileMedicalInfoScreen> {
  final TextEditingController allergiesController = TextEditingController();
  final TextEditingController medicalConditionsController =
      TextEditingController();

  bool labelSelected = false;
  List<String> medicalConditions = [];
  List<String> allergies = [];

  ///Todo: Setup crisis frequency selection
  List<String> crisisFrequency = [];

  @override
  void dispose() {
    allergiesController.dispose();
    medicalConditionsController.dispose();
    super.dispose();
  }

  // void _showSnackBar(String message) {
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       content: Text(message),
  //     ));
  //   });
  // }
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {

    });

    Future.microtask(() async {
      await ref.watch(userProvider.notifier).getCurrentUserData();
      await ref.watch(userProvider.notifier).getCurrentUserData();
      AppUser user = ref.watch(userProvider).value!;
      UserProfile? userProfile = user.profile.target;
      if(userProfile != null){
        medicalConditions = userProfile.medicalConditions ?? [];
        allergies = userProfile.allergies ?? [];
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final userNotifier = ref.watch(userProvider.notifier);
    AppUser user = ref.watch(userProvider).value!;
    UserProfile userProfile = user.profile.target ?? UserProfile.empty;
    UserPreferences userPreferences =
        user.preferences.target ?? UserPreferences.empty;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomAppBar(
              pageTitle: "Medical\nInfo",
              actions: [
                AppButton(
                  isChipButton: true,
                  onPressed: () {
                    context.goNamed(BottomNavBar.id);
                  },
                  label: "Skip",
                  buttonType: ButtonType.text,
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Crises frequency",
                    style: theme.textTheme.bodyLarge!
                        .copyWith(fontWeight: FontWeight.w700),
                  ),
                  const Gap(16),
                  Text(
                    "How often do you experience a Sickle Cell crises?",
                    style: theme.textTheme.bodyMedium,
                  ),

                  //Todo: Replace with selectable chip
                  Wrap(
                    direction: Axis.horizontal,
                    spacing: 12,
                    runSpacing: 4,
                    children: [
                      AppChip(
                        label: "Daily",
                        onSelected: (value) {},
                      ),
                      AppChip(
                        label: "Weekly",
                        onSelected: (value) {},
                      ),
                      AppChip(
                        label: "Monthly",
                        onSelected: (value) {},
                      ),
                      AppChip(
                        label: "Custom",
                        onSelected: (value) {},
                      ),
                    ],
                  ),
                  const Gap(16),
                  Text(
                    "Pain Severity?",
                    style: theme.textTheme.bodyMedium,
                  ),

                  ///Todo: Make a Sickler Slider component
                  Slider(min: 0, max: 10, value: 7, onChanged: (value) {}),
                  const Gap(24),
                  Text(
                    "Allergies",
                    style: theme.textTheme.bodyLarge!
                        .copyWith(fontWeight: FontWeight.w700),
                  ),
                  const Gap(12),

                  TextFormField(
                    controller: allergiesController,
                    textCapitalization: TextCapitalization.sentences,
                    onFieldSubmitted: (String value) {
                      setState(() {
                        allergies.add(allergiesController.text.trim());
                        allergiesController.clear();
                      });
                    },
                    decoration:
                        AppInputDecoration.inputDecoration(context).copyWith(
                      hintText: "e.g. Peanuts",
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              allergies.add(allergiesController.text.trim());
                              allergiesController.clear();
                            });
                          },
                          icon: const Icon(
                            FluentIcons.checkmark_24_filled,
                          )),
                    ),
                  ),
                  const Gap(12),
                  Wrap(
                    direction: Axis.horizontal,
                    spacing: 12,
                    runSpacing: 4,
                    children: [
                      for (String allergy in allergies)
                        AppChip(
                          label: allergy,
                          chipType: ChipType.info,
                          onDeleted: () {
                            setState(() {
                              allergies.remove(allergy);
                            });
                          },
                        ),
                    ],
                  ),
                  const Gap(24),
                  Text(
                    "Medical Conditions",
                    style: theme.textTheme.bodyLarge!
                        .copyWith(fontWeight: FontWeight.w700),
                  ),
                  const Gap(12),

                  TextFormField(
                    controller: medicalConditionsController,
                    textCapitalization: TextCapitalization.sentences,
                    onFieldSubmitted: (String value) {
                      setState(() {
                        medicalConditions
                            .add(medicalConditionsController.text.trim());
                        medicalConditionsController.clear();
                      });
                    },
                    decoration:
                        AppInputDecoration.inputDecoration(context).copyWith(
                      hintText: "e.g. Acute Chest Syndrome",
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              medicalConditions
                                  .add(medicalConditionsController.text.trim());
                              medicalConditionsController.clear();
                            });
                          },
                          icon: const Icon(
                            FluentIcons.checkmark_24_filled,
                          )),
                    ),
                  ),
                  const Gap(12),
                  Wrap(
                    direction: Axis.horizontal,
                    spacing: 12,
                    runSpacing: 4,
                    children: [
                      for (String medicalCondition in medicalConditions)
                        AppChip(
                          label: medicalCondition,
                          chipType: ChipType.info,
                          onDeleted: () {
                            setState(() {
                              medicalConditions.remove(medicalCondition);
                            });
                          },
                        ),
                    ],
                  ),
                  const Gap(32),
                  AppButton(
                      onPressed: () async {
                        user = user.copyWith(
                            preferences:
                                userPreferences.copyWith(isOnboarded: true),
                            profile: userProfile.copyWith(
                                allergies: allergies,
                                medicalConditions: medicalConditions,
                                bmi: userProfile.calculateBMI()));

                        //Send data to firebase

                        if (widget.isEditing!) {
                          await userNotifier.putUserData(
                              user: user, updateRemote: true);
                        } else {
                          await userNotifier.putUserData(
                              user: user, updateRemote: false);
                        }

                        if (context.mounted) {
                          if (userNotifier.isSuccessful) {
                            showCustomSnackBar(
                                context: context,
                                message: "Profile Updated",
                                mode: SnackBarMode.success);
                            context.pushNamed(SuggestedWaterDailyGoalScreen.id);
                          } else if (userNotifier.errorMessage != null) {
                            showCustomSnackBar(
                                context: context,
                                message: "Something went wrong",
                                mode: SnackBarMode.error);
                          }
                        }
                      },
                      label: "Continue"),
                  const Gap(64)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
