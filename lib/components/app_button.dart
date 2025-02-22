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
    this.buttonType = ButtonType.primary,
    this.isChipButton = false,
    this.isLoading = false,
    this.iconIgnoresLabelColor = false,
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
  final bool? isChipButton;
  final bool? isLoading;
  final bool iconIgnoresLabelColor;

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
          backgroundColor: backgroundColor ??  theme.colorScheme.onSurface,
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
        labelColor = color ?? theme.colorScheme.onSurface;

        style = ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(
            horizontal: isChipButton! ? kPadding16 : kPadding24,
          ),
          fixedSize: isChipButton! ? const Size.fromHeight(42) : null,
          backgroundColor: Colors.transparent,
         // foregroundColor: color ?? theme.colorScheme.primary,
          foregroundColor: color ?? theme.colorScheme.onSurface,
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
        /// Todo: Evaluate design choices.
        /// Should we animate button when on loading state?
        /// See `Save Toggle` interaction at https://khagwal.com/interactions/
        ///
        /// Also, we might consider changing this loading animation from `SpinKitThreeBounce`
        /// to the new M3 spec`CircularProgressIndicator`, that one looks real nice.
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
                iconIgnoresColor: iconIgnoresLabelColor,
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
                size: 24,
                iconIgnoresColor: iconIgnoresLabelColor,
                color:  labelColor,
              ),
            ]


          ],
        ),
      ),
    );
  }
}
