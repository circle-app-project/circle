import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../components/components.dart';
import '../../../../core/core.dart';
import '../../../profile/profile.dart';
import '../../auth.dart';

class AuthSuccessScreen extends ConsumerWidget {
  static const id = "auth_success";
  const AuthSuccessScreen({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    AppUser user = ref.watch(userProvider).value!;
    String userName = user.getDisplayName();

    //Todo: Rearrange animation timing;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Spacer(),
            Text(
              "Hey there,",
              style: theme.textTheme.titleLarge,
            )
                .animate()
                .moveY(
                    duration: 800.ms,
                    curve: Curves.easeInOutQuart,
                    begin: 150,
                    end: 0)
                .fadeIn(duration: 600.ms, delay: 600.ms),
            const Gap(kPadding16),
            Text(
              userName.split(" ").first,
              style: theme.textTheme.displayLarge!.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.primary),
            )
                .animate(delay: 1000.ms)
                .moveY(
                    duration: 1500.ms,
                    curve: Curves.easeInOutQuart,
                    begin: 120,
                    end: 0)
                .fadeIn(duration: 800.ms, delay: 600.ms),
            const Gap(kPadding48),
            Text(
              "We're glad you're here!",
              style: theme.textTheme.titleLarge,
            )
                .animate(delay: 1500.ms)
                .moveY(
                    duration: 1500.ms,
                    curve: Curves.easeInOutQuart,
                    begin: 120,
                    end: 0)
                .fadeIn(duration: 800.ms, delay: 600.ms),

            const Spacer(),
            AppButton(
                    onPressed: () {
                      context.goNamed(ProfileBasicInfoScreen.id);
                    },
                    label: "Continue")
                .animate(delay: 3500.ms)
                .moveY(
                    duration: 1500.ms,
                    curve: Curves.easeInOutQuart,
                    begin: 150,
                    end: 0)
                .fadeIn(duration: 800.ms, delay: 600.ms),
            const Gap(64),
          ],
        ),
      ),
    );
  }
}
