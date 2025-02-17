import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gap/gap.dart';

import '../../../core/core.dart';
import 'app_icon.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.color,
    this.backgroundColor,
    this.iconPath,
    this.icon,
    this.trailingIcon,
    this.trailingIconPath,
    this.overrideIconColor = false,
    this.buttonType = ButtonType.primary,
    this.isChipButton = false,
    this.isLoading = false,
  });

  final VoidCallback onPressed;
  final String label;
  final ButtonType buttonType;
  final IconData? icon;
  final IconData? trailingIcon;
  final String? iconPath;
  final String? trailingIconPath;
  final Color? color;
  final Color? backgroundColor;
  final bool? overrideIconColor;
  final bool? isChipButton;
  final bool? isLoading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDarkMode = theme.brightness == Brightness.dark;
    if (icon != null && iconPath != null) {
      throw ErrorHint(
        "Cannot set both an icon and an iconPath property simultaneously, consider removing one",
      );
    }
    if (trailingIcon != null && trailingIconPath != null) {
      throw ErrorHint(
        "Cannot set both a trailingIcon and a trailingIconPath property simultaneously, consider removing one",
      );
    }
    if (overrideIconColor == true && color == null) {
      throw ErrorHint(
        "Must provide a color property if overrideIconColor is set to true",
      );
    }

    ButtonStyle style = ElevatedButton.styleFrom(
      backgroundColor: backgroundColor ?? theme.colorScheme.primary,
      foregroundColor: color ?? Colors.white,
    );
    Color labelColor = theme.colorScheme.primary;
    switch (buttonType) {
      case ButtonType.primary:
        labelColor = color ?? theme.colorScheme.onPrimary;

        style = ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(
            horizontal: isChipButton! ? kPadding16 : kPadding24,
          ),
          fixedSize: isChipButton! ? const Size.fromHeight(42) : null,
          alignment: Alignment.center,
          //backgroundColor: backgroundColor ?? theme.colorScheme.primary,
          backgroundColor: backgroundColor ??  theme.iconTheme.color,
          foregroundColor: color ??  theme.colorScheme.onPrimary,
        );
        break;

      case ButtonType.secondary:
        labelColor = color ?? theme.colorScheme.onPrimaryContainer;

        style = ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(
            horizontal: isChipButton! ? kPadding16 : kPadding24,
          ),
          fixedSize: isChipButton! ? const Size.fromHeight(42) : null,
          backgroundColor:
          backgroundColor ?? (isDarkMode? theme.colorScheme.surfaceContainerLow : theme.colorScheme.primaryContainer),
          foregroundColor: labelColor,
        );
        break;

      case ButtonType.outline:
        labelColor = color ?? theme.colorScheme.primary;

        style = ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(
            horizontal: isChipButton! ? kPadding16 : kPadding24,
          ),
          fixedSize: isChipButton! ? const Size.fromHeight(42) : null,
          backgroundColor: Colors.transparent,
         // foregroundColor: color ?? theme.colorScheme.primary,
          foregroundColor: color ?? theme.iconTheme.color,
          side: BorderSide(width: 1, color: labelColor),
        );

        break;
      case ButtonType.text:
        style = ElevatedButton.styleFrom(
          fixedSize: isChipButton! ? const Size.fromHeight(42) : null,
          backgroundColor: Colors.transparent,
          foregroundColor: color ?? theme.colorScheme.primary,
        );
        labelColor = color ?? theme.colorScheme.primary;
        break;
    }

    return ElevatedButton(
      onPressed: isLoading! ? (){
        log("Button is loading", name: "AppButton");
      } : onPressed, // Disabling the button when loading
      style: style,
      child: Center(
        child:
        isLoading!
            ? SpinKitThreeBounce(
          size: kPadding24,
          color:  labelColor,
        )
            : Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (iconPath != null || icon != null)
              ...[
              AppIcon(
                size: 24,
                icon: icon,
                iconPath: iconPath,
                color: labelColor,
              ),
              const Gap(kPadding8),
            ]
,

            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: labelColor,
                fontWeight: FontWeight.w500,
              ),
            ),

            // Gap for the trailing icon if visible
            if (trailingIconPath != null || trailingIcon != null)
              ...[
              const Gap(kPadding8),
              AppIcon(
                icon: trailingIcon,
                iconPath: trailingIconPath,
                color: labelColor,
              ),
            ]


          ],
        ),
      ),
    );
  }
}
