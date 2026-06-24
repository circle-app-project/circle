import 'package:auto_route/auto_route.dart';
import 'package:circle/core/extensions/titlecase.dart';
import 'package:circle/features/auth/auth.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../components/components.dart';
import '../../../core/core.dart';
import '../../../gen/assets.gen.dart';
import '../../hla/hla.dart';
import '../../water/water.dart';
import '../profile.dart';

@RoutePage(name: ProfileScreen.name)
class ProfileScreen extends ConsumerWidget {
  static const String path = "/profile";
  static const String name = "ProfileScreen";
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final bool isDarkMode = theme.colorScheme.brightness == Brightness.dark;

    final userState = ref.watch(userNotifierProviderImpl);
    final AppUser selfUser = userState.value!;
    //AppUser selfUser = AppUser.sample;
    final UserProfile userProfile = selfUser.profile.target ?? UserProfile.empty;

    return PopScope(
      canPop: true,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: kPadding16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomAppBar(pageTitle: "Profile"),
                Align(
                  alignment: Alignment.center,
                  child: EditableAvatar(
                    onEditPressed: () {
                      context.router.pushNamed(ProfileBasicInfoScreen.path);
                    },
                    imagePath:
                        userProfile.photoUrl ?? Assets.images.memoji2.path,
                  ),
                ),
                const Gap(16),
                Align(
                  alignment: Alignment.center,
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "${userProfile.name?.split(" ").first} ",
                          style: theme.textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextSpan(
                          text: userProfile.name?.split(" ").last,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w300,
                          ),
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
                    AppChip(
                      label: "${userProfile.age} Yrs",
                      icon: HugeIcons.strokeRoundedCalendar02,
                      //backgroundColor: theme.colorScheme.primaryContainer,
                      //color: theme.colorScheme.primary,
                    ),
                    AppChip(
                      label: "${userProfile.gender?.name.toTitleCase()}",
                      icon: HugeIcons.strokeRoundedDna,
                      //  backgroundColor: theme.colorScheme.primaryContainer,
                      //  color: theme.colorScheme.primary,
                    ),
                    AppChip(
                      label: "${userProfile.genotype?.name.toUpperCase()}",
                      icon: HugeIcons.strokeRoundedDna,
                      //  backgroundColor: theme.colorScheme.primaryContainer,
                      //  color: theme.colorScheme.primary,
                    ),
                  ],
                ),
                const Gap(24),
                _HlaProfileSection(
                  isAdmin: userProfile.role == UserRole.admin,
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
                    Text("Vitals", style: theme.textTheme.titleMedium),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        context.router.pushNamed(ProfileVitalsInfoScreen.path);
                      },
                      icon: Icon(
                        HugeIcons.strokeRoundedPencilEdit02,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: .5,
                        ),
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
                          context.router.pushNamed(
                            ProfileVitalsInfoScreen.path,
                          );
                        },
                        label:
                            "Height", //Todo:Create a store for height and weight logs.
                        value:
                            userProfile.height != null
                                ? userProfile.height!.toInt().toString()
                                : "N/A",
                        unit:
                            " ${selfUser.preferences?.unitPreferences?.heightUnit?.symbol}",
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
                          context.router.pushNamed(
                            ProfileVitalsInfoScreen.path,
                          );
                        },
                        label: "Weight",
                        value:
                            userProfile.weight != null
                                ? userProfile.weight.toString()
                                : "N/A",
                        unit:
                            " ${selfUser.preferences?.unitPreferences?.weightUnit?.symbol}",
                        color:
                            isDarkMode ? Colors.white : theme.colorScheme.error,
                        backgroundColor:
                            isDarkMode
                                ? theme.colorScheme.surfaceContainerLow
                                : theme.colorScheme.errorContainer,
                        icon: SvgPicture.asset(
                          "assets/svg/weight.svg",
                          colorFilter: ColorFilter.mode(
                            isDarkMode ? Colors.white : theme.colorScheme.error,
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
                          context.router.pushNamed(WaterScreen.path);
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
                        value:
                            userProfile.bmi != null
                                ? userProfile.bmi!.toStringAsFixed(2)
                                : "N/A",
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
                      style: theme.textTheme.titleMedium?.copyWith(
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

                if (userProfile.allergies?.isNotEmpty ?? false)
                  Wrap(
                    alignment: WrapAlignment.start,
                    runAlignment: WrapAlignment.start,
                    spacing: 8,
                    runSpacing: -4,
                    children: List.generate(
                      userProfile.allergies?.length ?? 0,
                      (index) {
                        return AppChip(label: userProfile.allergies![index]);
                      },
                    ),
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
                  children: List.generate(
                    userProfile.medicalConditions?.length ?? 0,
                    (index) {
                      return AppChip(
                        label: userProfile.medicalConditions![index],
                      );
                    },
                  ),
                ),

                const Gap(kPadding24),

                Align(
                  child: TextButton(
                    onPressed: () async {
                      final Uri url = Uri.parse('https://github.com/circle-app-project/circle/blob/main/PRIVACY_POLICY.md');
                      await launchUrl(url);
                    },
                    child: const Text("Privacy Policy"),
                  ),
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

/// HLA typing entry points on the profile: a patient-facing tile for everyone
/// and a staff-only admin tile gated on [isAdmin] (the role read). The server
/// also enforces the admin boundary via Firestore rules.
class _HlaProfileSection extends StatelessWidget {
  const _HlaProfileSection({required this.isAdmin});

  final bool isAdmin;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("HLA Typing", style: theme.textTheme.titleMedium),
        const Gap(kPadding8),
        _HlaNavTile(
          icon: FluentIcons.organization_24_regular,
          label: "HLA typing & transplant matching",
          onTap: () => context.router.pushNamed(HlaIntroScreen.path),
        ),
        if (isAdmin) ...[
          const Gap(kPadding8),
          _HlaNavTile(
            icon: FluentIcons.shield_task_24_regular,
            label: "HLA admin",
            onTap: () => context.router.pushNamed(HlaAdminListScreen.path),
          ),
        ],
      ],
    );
  }
}

class _HlaNavTile extends StatelessWidget {
  const _HlaNavTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(kPadding16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(kPadding16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(kPadding16),
        ),
        child: Row(
          children: [
            Icon(icon, color: theme.colorScheme.primary),
            const Gap(kPadding12),
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.bodyLarge
                    ?.copyWith(fontWeight: FontWeight.w500),
              ),
            ),
            const Icon(
              FluentIcons.chevron_right_24_regular,
              size: 18,
              color: AppColours.neutral50,
            ),
          ],
        ),
      ),
    );
  }
}
