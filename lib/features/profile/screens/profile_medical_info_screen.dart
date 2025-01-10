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
    WidgetsBinding.instance.addPostFrameCallback((_) async {});

    Future.microtask(() async {
      await ref.watch(userNotifierProviderImpl.notifier).getSelfUserData();
      AppUser user = ref.watch(userNotifierProviderImpl).value!;
      UserProfile? userProfile = user.profile.target;
      if (userProfile != null) {
        medicalConditions = userProfile.medicalConditions ?? [];
        allergies = userProfile.allergies ?? [];
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final userNotifier = ref.watch(userNotifierProviderImpl.notifier);
    AppUser user = ref.watch(userNotifierProviderImpl).value!;
    UserProfile userProfile = user.profile.target ?? UserProfile.empty;
    UserPreferences userPreferences = user.preferences ?? UserPreferences.empty;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
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
                ),
              ],
            ),
            Text(
              "Allergies",
              style: theme.textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.w700,
              ),
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
              decoration: AppInputDecoration.inputDecoration(context).copyWith(
                hintText: "e.g. Peanuts",
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      allergies.add(allergiesController.text.trim());
                      allergiesController.clear();
                    });
                  },
                  icon: const Icon(FluentIcons.checkmark_24_filled),
                ),
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
            const Gap(12),
            Text(
              "Medical Conditions",
              style: theme.textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const Gap(12),
            TextFormField(
              controller: medicalConditionsController,
              textCapitalization: TextCapitalization.sentences,
              onFieldSubmitted: (String value) {
                setState(() {
                  medicalConditions.add(
                    medicalConditionsController.text.trim(),
                  );
                  medicalConditionsController.clear();
                });
              },
              decoration: AppInputDecoration.inputDecoration(context).copyWith(
                hintText: "e.g. Acute Chest Syndrome",
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      medicalConditions.add(
                        medicalConditionsController.text.trim(),
                      );
                      medicalConditionsController.clear();
                    });
                  },
                  icon: const Icon(FluentIcons.checkmark_24_filled),
                ),
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

            Spacer(),
            AppButton(
              isLoading: ref.watch(userNotifierProviderImpl).isLoading,
              onPressed: () async {
                user = user.copyWith(
                  preferences: userPreferences.copyWith(isOnboarded: true),
                  profile: userProfile.copyWith(
                    allergies: allergies,
                    medicalConditions: medicalConditions,
                    bmi: userProfile.calculateBMI(),
                  ),
                );

                //Send data to firebase
                await userNotifier.putUserData(user: user, updateRemote: true);

                if (context.mounted) {
                  if (ref.watch(userNotifierProviderImpl).hasError) {
                    showCustomSnackBar(
                      context: context,
                      message: "Something went wrong",
                      error: ref.watch(userNotifierProviderImpl).error,
                    );
                  } else {
                    showCustomSnackBar(
                      context: context,
                      message: "Profile Updated",
                      mode: SnackBarMode.success,
                    );
                    context.pushNamed(SuggestedWaterDailyGoalScreen.id);
                  }
                }
              },
              label: "Continue",
            ),
            const Gap(64),
          ],
        ),
      ),
    );
  }
}
