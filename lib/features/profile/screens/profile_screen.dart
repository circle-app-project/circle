import 'package:circle/features/auth/auth.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../components/components.dart';
import '../../../core/core.dart';
import '../../water/water.dart';
import '../profile.dart';

class ProfileScreen extends ConsumerWidget {
  static const String id = "profile";
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final bool isDarkMode = theme.colorScheme.brightness == Brightness.dark;

    final userState = ref.watch(userNotifierProviderImpl);
    final AppUser selfUser = userState.value!;
    //AppUser selfUser = AppUser.sample;
    final UserProfile userProfile = selfUser.profile.target!;

    return PopScope(
      canPop: true,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              const CustomAppBar(pageTitle: "Profile"),
              EditableAvatar(
                onEditPressed: () {
                  context.pushNamed(ProfileBasicInfoScreen.id);
                },
                imagePath: userProfile.photoUrl ?? "assets/images/memoji2.jpg",
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Gap(16),
                    Align(
                      alignment: Alignment.center,
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "${userProfile.name!.split(" ").first} ",
                              style: theme.textTheme.titleLarge!.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            TextSpan(
                              text: userProfile.name!.split(" ").last,
                              style: theme.textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w300),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Gap(16),
                    Row(
                      spacing: 8,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ///Todo: Properly reimplement these chips.
                        AppChip(label: "${userProfile.age} Yrs"),
                        AppChip(label: "${userProfile.gender?.name}"),
                        AppChip(label: "${userProfile.genotype?.name.toUpperCase()}"),
                      ],
                    ),
                   // const Gap(16),
                    // Container(
                    //   padding: const EdgeInsets.all(16),
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(24),
                    //     color:
                    //         isDarkMode
                    //             ? theme.cardColor
                    //             : theme.colorScheme.secondaryContainer,
                    //   ),
                    //   child: Row(
                    //     children: [
                    //       const Expanded(
                    //         child: Text(
                    //           "Your water intake looks good, Good Job!",
                    //         ),
                    //       ),
                    //       const Gap(16),
                    //       Container(
                    //         height: 72,
                    //         width: 72,
                    //         decoration: BoxDecoration(
                    //           shape: BoxShape.circle,
                    //           color:
                    //               isDarkMode
                    //                   ? AppColours.neutral30
                    //                   : AppColours.orange90,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    const Gap(24),
                    Row(
                      children: [
                        Text("Vitals", style: theme.textTheme.headlineSmall),
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            context.pushNamed(ProfileVitalsInfoScreen.id);
                          },
                          icon: Icon(
                            FluentIcons.edit_24_regular,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const Gap(8),
                    Row(
                      children: [
                        Expanded(
                          child: VitalsItemCard(
                            onPressed: () {
                              context.pushNamed(ProfileVitalsInfoScreen.id);
                            },
                            label:
                                "Height", //Todo:Create a store for height and weight logs.
                            value: userProfile.height!.toInt().toString(),
                            unit: " cm",
                            color:
                                isDarkMode
                                    ? Colors.white
                                    : theme.colorScheme.primary,
                            backgroundColor:
                                isDarkMode
                                    ? theme.colorScheme.surfaceContainerLow
                                    : theme.cardColor,
                            icon: Transform.rotate(
                              angle: 0.789,

                              /// = 45 deg in radians
                              child: Icon(
                                FluentIcons.ruler_24_regular,
                                color:
                                    isDarkMode
                                        ? Colors.white
                                        : theme.colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                        const Gap(12),
                        Expanded(
                          child: VitalsItemCard(
                            onPressed: () {
                              context.pushNamed(ProfileVitalsInfoScreen.id);
                            },
                            label: "Weight",
                            value: userProfile.weight.toString(),
                            unit:
                                " kg", //Todo: replace this with unit preferences
                            color:
                                isDarkMode
                                    ? Colors.white
                                    : theme.colorScheme.error,
                            backgroundColor:
                                isDarkMode
                                    ? theme.colorScheme.surfaceContainerLow
                                    : theme.colorScheme.errorContainer,
                            icon: SvgPicture.asset(
                              "assets/svg/weight.svg",
                              colorFilter: ColorFilter.mode(
                                isDarkMode
                                    ? Colors.white
                                    : theme.colorScheme.error,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Gap(12),
                    Row(
                      children: [
                        Expanded(
                          child: VitalsItemCard(
                            onPressed: () {
                              context.pushNamed(WaterScreen.id);
                            },
                            label: "Water",
                            value: "1200",
                            unit: " ml",
                            backgroundColor:
                                isDarkMode
                                    ? theme.colorScheme.surfaceContainerLow
                                    : AppColours.blue95,
                            color:
                                isDarkMode
                                    ? Colors.white
                                    : theme.colorScheme.tertiary,
                            icon: SvgPicture.asset(
                              "assets/svg/droplet-alt.svg",
                              colorFilter: ColorFilter.mode(
                                isDarkMode
                                    ? Colors.white
                                    : theme.colorScheme.tertiary,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                        const Gap(12),
                        Expanded(
                          child: VitalsItemCard(
                            onPressed: () {},
                            label: "BMI",
                            value: userProfile.bmi!.toStringAsFixed(2),
                            // unit: " normal",
                            color:
                                isDarkMode
                                    ? Colors.white
                                    : theme.colorScheme.secondary,
                            backgroundColor:
                                isDarkMode
                                    ? theme.colorScheme.surfaceContainerLow
                                    : theme.colorScheme.secondaryContainer,
                            icon: SvgPicture.asset(
                              "assets/svg/dna.svg",
                              colorFilter: ColorFilter.mode(
                                isDarkMode
                                    ? Colors.white
                                    : theme.colorScheme.secondary,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Gap(24),
                    Row(
                      children: [
                        Text(
                          "Allergies",
                          style: theme.textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            ///Todo: Add Add Allergies Method
                          },
                          icon: Icon(
                            FluentIcons.add_24_regular,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),

                     if(userProfile.allergies?.isNotEmpty ?? false)
                       Wrap(
                      alignment: WrapAlignment.start,
                      runAlignment: WrapAlignment.start,
                      spacing: 8,
                      runSpacing: -4,
                      children:
                        List.generate(userProfile.allergies?.length ?? 0, (
                          index,
                        ) {
                          return AppChip(
                            chipType: ChipType.info,
                            label: userProfile.allergies![index],
                          );
                        }),
                    ),
                    const Gap(16),
                    Row(
                      children: [
                        Text(
                          "Medical Conditions",
                          style: theme.textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            ///Todo: Add Medical Conditions Method
                          },
                          icon: Icon(
                            FluentIcons.add_24_regular,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    Wrap(
                      alignment: WrapAlignment.start,
                      runAlignment: WrapAlignment.start,
                      spacing: 8,
                      runSpacing: -4,
                      children:    List.generate(userProfile.medicalConditions?.length ?? 0, (
                          index,
                          ) {
                        return AppChip(
                          chipType: ChipType.info,
                          label: userProfile.medicalConditions![index],
                        );
                      }),
                    ),
                    const Gap(64),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
