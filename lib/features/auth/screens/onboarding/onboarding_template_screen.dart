import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:springster/springster.dart';

class OnboardingTemplateScreen extends StatelessWidget {
  final String text;
  final String illustration;

  const OnboardingTemplateScreen({
    super.key,
    required this.text,
    required this.illustration,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
                text,
                style: theme.textTheme.displaySmall!.copyWith(
                  fontWeight: FontWeight.w300,
                  height: 1.5,
                ),
              )
              .animate()
              .fadeIn(delay: 300.ms, duration: 500.ms)
              .moveY(
                duration: 1000.ms,
                begin: 120,
                end: 0,
                curve: Spring.defaultIOS.toCurve,
              ),

          const Gap(96 + 64),
        ],
      ),
    );
  }
}
