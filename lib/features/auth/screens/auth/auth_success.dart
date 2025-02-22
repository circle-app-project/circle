import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:springster/springster.dart';
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
    AppUser selfUser = ref.watch(userNotifierProviderImpl).value!;
    String userName = selfUser.getDisplayName();
    //Todo: Rearrange animation timing;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Spacer(flex: 2),
            Text(
                  "Hey there,",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.normal,
                    fontSize: 22,
                  ),
                )
                .animate(delay: 200.ms)
                .fadeIn(duration: 500.ms)
                .blur(
                  duration: 500.ms,
                  begin: const Offset(10, 10),
                  end: const Offset(0, 0),
                  curve: Spring.defaultIOS.toCurve,
                )
                .moveY(
                  duration: 1000.ms,
                  curve: Spring.defaultIOS.toCurve,
                  begin: 100,
                  end: 0,
                ),


            if(userName.isNotEmpty)
     ...[         const Gap(kPadding16),
            Text(
             userName.split(" ").first,
                  style: theme.textTheme.headlineMedium!.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                )
                .animate(delay: 1000.ms)
                .fadeIn(duration: 500.ms)
                .blur(
                  duration: 500.ms,
              begin: const Offset(50, 50),
                  end: const Offset(0, 0),
                  curve: Spring.defaultIOS.toCurve,
                )
                .moveY(
                  duration: 1000.ms,
                  curve: Spring.defaultIOS.toCurve,
                  begin: 100,
                  end: 0,
                )],
            const Gap(kPadding16),
            Text(
                  "We're glad you're here!",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.normal,
                    fontSize: 22,
                  ),
                )
                .animate(delay: 2000.ms)
                .fadeIn(duration: 500.ms)
                .blur(
                  duration: 500.ms,
                  begin: const Offset(50, 50),
                  end: const Offset(0, 0),
                  curve: Spring.defaultIOS.toCurve,
                )
                .blur(
                  duration: 500.ms,
              begin: const Offset(50, 50),
                  end: const Offset(0, 0),
                )
                .moveY(
                  duration: 1000.ms,
                  curve: Spring.defaultIOS.toCurve,
                  begin: 100,
                  end: 0,
                ),

            const Spacer(),
            AppButton(
                  onPressed: () {
                    context.goNamed(ProfileBasicInfoScreen.id);
                  },
                  label: "Continue",
                )
                .animate(delay: 2500.ms)
                .fadeIn(duration: 300.ms)
                .moveY(
                  duration: 1000.ms,
                  begin: 64,
                  end: 0,
                  curve: Spring.defaultIOS.toCurve,
                ),
            const Gap(64),
          ],
        ),
      ),
    );
  }
}
