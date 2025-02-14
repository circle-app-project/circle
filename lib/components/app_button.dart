import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

import '../../core/core.dart';

class AppButton extends StatelessWidget {
  const AppButton(
      {super.key,
      required this.onPressed,
      required this.label,
      this.color,
      this.backgroundColor,
      this.iconPath,
      this.icon,
      this.overrideIconColor = true,
      this.buttonType = ButtonType.primary,
      this.isChipButton = false,
      this.isLoading = false});
  final VoidCallback onPressed;
  final String label;
  final ButtonType buttonType;
  final IconData? icon;
  final String? iconPath;
  final Color? color;
  final Color? backgroundColor;
  final bool? overrideIconColor;
  final bool? isChipButton;
  final bool? isLoading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (icon != null && iconPath != null) {
      throw ErrorHint(
          "Cannot set both an icon and an iconPath property simultaneously, consider removing one");
    }
    // if (overrideIconColor == true && color == null) {
    //   throw ErrorHint(
    //       "Must provide a color property if overrideIconColor is set to true");
    // }

    ButtonStyle style = ElevatedButton.styleFrom(
      backgroundColor: backgroundColor ?? theme.colorScheme.primary,
      foregroundColor: color ?? Colors.white,
    );
    Color labelColor = theme.colorScheme.primary;
    switch (buttonType) {
      case ButtonType.primary:
        labelColor = color ?? theme.colorScheme.onPrimary;

        style = ElevatedButton.styleFrom(
          fixedSize: isChipButton! ? const Size.fromHeight(36) : null,
          alignment: Alignment.center,
          backgroundColor: backgroundColor ?? theme.colorScheme.primary,
          foregroundColor: color ?? Colors.white,
        );
        break;

      case ButtonType.secondary:
        labelColor = color ?? theme.colorScheme.onPrimaryContainer;

        style = ElevatedButton.styleFrom(
          fixedSize: isChipButton! ? const Size.fromHeight(36) : null,
          backgroundColor:
              backgroundColor ?? theme.colorScheme.primaryContainer,
          foregroundColor: labelColor,
        );
        break;

      case ButtonType.outline:
        labelColor = color ?? theme.colorScheme.primary;

        style = ElevatedButton.styleFrom(
          fixedSize: isChipButton! ? const Size.fromHeight(36) : null,
          backgroundColor: Colors.transparent,
          foregroundColor: color ?? theme.colorScheme.primary,
          side: BorderSide(
            width: 1,
            color: labelColor,
          ),
        );

        break;
      case ButtonType.text:
        style = ElevatedButton.styleFrom(
          fixedSize: isChipButton! ? const Size.fromHeight(36) : null,
          backgroundColor: Colors.transparent,
          foregroundColor: color ?? theme.colorScheme.primary,
        );
        labelColor = color ?? theme.colorScheme.primary;
        break;

    }

    return ElevatedButton(
      onPressed: isLoading! ? (){} : onPressed,
      style: style,
      child: Center(
        child: isLoading!
            ? SpinKitThreeBounce(
                size: kPadding24,
                color: theme.scaffoldBackgroundColor,
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Visibility(
                    visible: icon != null || iconPath != null,
                    child: Row(
                      children: [
                        icon != null
                            ? Icon(icon)
                            : SvgPicture.asset(iconPath ?? "",
                                colorFilter: overrideIconColor!
                                    ? ColorFilter.mode(
                                        labelColor, BlendMode.srcIn)
                                    : null),
                        const Gap(8)
                      ],
                    ),
                  ),
                  Text(label,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: labelColor)),
                ],
              ),
      ),
    );
  }
}
