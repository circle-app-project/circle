import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../core/core.dart';


class OnboardingButton extends StatelessWidget {
  const OnboardingButton(
      {super.key, required this.onPressed, this.backgroundColour, this.colour});
  final VoidCallback onPressed;
  final Color? backgroundColour;
  final Color? colour;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColour ?? theme.colorScheme.primary,
          fixedSize: const Size(84, 84),
          shape: const CircleBorder()),
      child: Center(
        child: Icon(HugeIcons.strokeRoundedArrowRight02, color: colour ?? AppColours.white, size: 32,),
      ),
    );
  }
}
