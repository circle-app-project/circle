import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../components/components.dart';
import '../../../core/core.dart';
import '../../auth/auth.dart';
import '../profile.dart';

class ProfileBasicInfoScreen extends ConsumerStatefulWidget {
  static const String id = "basic_info";
  final bool? isEditing;

  const ProfileBasicInfoScreen({super.key, this.isEditing = false});

  @override
  ConsumerState<ProfileBasicInfoScreen> createState() =>
      _ProfileBasicInfoScreenState();
}

class _ProfileBasicInfoScreenState
    extends ConsumerState<ProfileBasicInfoScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Gender selectedRadioValue = Gender.male;
  final List<String> listData = ["1", "2", "3", "4", "5", "6"];

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    ageController.dispose();
    //  addressController.dispose();
  }

  @override
  void initState() {
    Future.microtask(() async {
      await ref.watch(userProvider.notifier).getCurrentUserData();
      AppUser user = ref.watch(userProvider).value!;
      UserProfile? userProfile = user.profile.target;

      if (userProfile != null) {
        setState(() {
          selectedRadioValue = userProfile.gender ?? Gender.male;
          nameController.text =
              userProfile.displayName ?? userProfile.name ?? "";
          ageController.text = userProfile.age !=null ? userProfile.age.toString() : "";
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final userNotifier = ref.watch(userProvider.notifier);
    AppUser user = ref.watch(userProvider).value!;
    UserProfile? userProfile = user.profile.target;

    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: kPadding16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomAppBar(
                  pageTitle:
                      widget.isEditing!
                          ? "Edit Profile"
                          : "Tell us more\nabout you",
                ),

                if(widget.isEditing!)
                  EditableAvatar(
                    onEditPressed: () {
                      ///Todo: Implement on Edit Pressed;
                    },
                    imagePath: "assets/images/memoji2.jpg",
                  ),
                if(widget.isEditing!)  const Gap(32),
                Text("Full Names", style: theme.textTheme.bodyMedium),
                const Gap(8),
                TextFormField(
                  controller: nameController,
                  keyboardType: TextInputType.name,
                  decoration: AppInputDecoration.inputDecoration(
                    context,
                  ).copyWith(hintText: "Names"),
                ),
                const Gap(24),
                Text("Age", style: theme.textTheme.bodyMedium),
                const Gap(8),
                TextFormField(
                  readOnly: true,
                  showCursor: true,
                  controller: ageController,
                  keyboardType: TextInputType.number,
                  decoration: AppInputDecoration.inputDecoration(
                    context,
                  ).copyWith(hintText: "Age"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your age";
                    }
                    return null;
                  },
                  onTap: () async {
                    await showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder:
                          (context) => AppBottomSheet(
                            title: "Age",
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: ListWheelScrollViewPicker(
                              itemExtent: 48,
                              onSelectedItemChanged: (selectedValue) {
                                setState(() {
                                  ageController.text =
                                      selectedValue.toString();
                                });
                              },
                              primaryInitialValue: 0,
                              primaryFinalValue: 100,
                            ),
                          ),
                    );
                  },
                ),

                const Gap(24),
                Text("Sex", style: theme.textTheme.bodyMedium),
                const Gap(8),
                Row(
                  children: [
                    Expanded(
                      child: AppRadio<Gender>(
                        label: "Female",
                        value: Gender.female,
                        groupValue: selectedRadioValue,
                        onChanged: (Gender? value) {
                          setState(() {
                            selectedRadioValue = value!;
                          });
                        },
                      ),
                    ),
                    const Gap(16),
                    Expanded(
                      child: AppRadio<Gender>(
                        label: "Male",
                        value: Gender.male,
                        groupValue: selectedRadioValue,
                        onChanged: (Gender? value) {
                          setState(() {
                            selectedRadioValue = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const Gap(64),

                ///Buttons
                AppButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      user = user.copyWith(
                        profile: userProfile?.copyWith(
                          name: nameController.text.trim(),
                          gender: selectedRadioValue,
                          age: int.tryParse(ageController.text.trim()),
                        ),
                      );
                      if (widget.isEditing!) {
                        /// Always update remote when the user is editing data.
                        /// But do not do that when the user is adding data because
                        /// the user is onboarding for the first time,
                        /// the data will be gathered and saved at the
                        /// end of the onboard process
                        await userNotifier.putUserData(
                          user: user,
                          updateRemote: true,
                        );

                        /// Also show snack bars when making remote calls
                        if (context.mounted) {
                          if (userNotifier.isSuccessful) {
                            showCustomSnackBar(
                              context: context,
                              message: "Profile Updated",
                              mode: SnackBarMode.success,
                            );
                          } else {
                            showCustomSnackBar(
                              context: context,
                              message: "Failed to update user",
                              mode: SnackBarMode.error,
                            );
                          }
                        }
                      } else {
                        await userNotifier.putUserData(
                          user: user,
                          updateRemote: false,
                        );
                        if (context.mounted) {
                          context.pushNamed(ProfileVitalsInfoScreen.id);
                        }
                      }
                    }
                  },
                  label: "Continue",
                ),

                const Gap(64),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
