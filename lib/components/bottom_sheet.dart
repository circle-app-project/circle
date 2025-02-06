import 'package:circle/core/core.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'components.dart';

class AppBottomSheet extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final Widget child;
  final String buttonLabel;
  final bool showLip;
  const AppBottomSheet({
    super.key,
    required this.title,
    required this.onPressed,
    this.buttonLabel = "Continue",
    this.showLip = false,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDarkMode = theme.brightness == Brightness.dark;
    return Padding(

      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          color:
              isDarkMode
                  ? theme.colorScheme.surfaceContainerLowest
                  : theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(48)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showLip) ...[
                const Gap(12),
                Container(
                  height: 6,
                  width: 42,
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],

              const Gap(kPadding24),
              Row(
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium!.copyWith(
                     // fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  Spacer(),
                  IconButton(onPressed: (){}, icon: Icon(FluentIcons.dismiss_20_regular))
                ],
              ),

              const SizedBox(height: 16),
              child,
              const Gap(32),
              AppButton(onPressed: onPressed, label: buttonLabel),
              const SizedBox(height: 64),
            ],
          ),
        ),
      ),
    );
  }
}
