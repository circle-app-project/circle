import 'package:circle/core/error/exceptions.dart';
import 'package:flutter/material.dart';
import 'package:springster/springster.dart';

import '../../../core/core.dart';

enum SnackBarMode { notification, error, success }

void showCustomSnackBar({
  required BuildContext context,
  String? message,
  SnackBarMode? mode,
  Object? error,
}) {
  Color backgroundColor = Theme.of(context).colorScheme.primary;
  Color labelColor = Colors.white;

  if (error != null) {
    mode = SnackBarMode.error;
  }
  if (error is Failure) {
    if (error.message.isEmpty && message == null) {
      message = "An error occurred";
    } else {
      message = error.message;
    }
  } else if (error is AppException) {
    if (error.message.isEmpty && message == null) {
      message = "An error occurred";
    } else {
      message = error.message;
    }
  } else if (error is Exception) {
    message = error.toString();
  }

  switch (mode) {
    case SnackBarMode.notification:
      backgroundColor = Theme.of(context).colorScheme.surfaceContainerHighest;
      labelColor =
          Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : AppColours.black;
    case SnackBarMode.success:
      backgroundColor =
          Theme.of(context).brightness == Brightness.dark
              ? AppColours.green20
              : AppColours.green95;
      labelColor =
          Theme.of(context).brightness == Brightness.dark
              ? AppColours.green90
              : AppColours.green30;
    case SnackBarMode.error:
      backgroundColor = Theme.of(context).colorScheme.errorContainer;
      labelColor = Theme.of(context).colorScheme.onErrorContainer;
    default:
      backgroundColor = Theme.of(context).colorScheme.surfaceContainerHighest;
      labelColor = Theme.of(context).colorScheme.onSurface;
  }

  if (message == null && error == null) {
    throw ErrorHint("Message cannot be null if Error is null");
  }

  ScaffoldMessenger.of(context).showSnackBar(
    snackBarAnimationStyle: AnimationStyle(
      curve: Spring.bouncy.toCurve,
      duration: const Duration(milliseconds: 500),
      reverseCurve: Spring.defaultIOS.toCurve,
    ),
    SnackBar(
      elevation: 10,
      //  dismissDirection: DismissDirection.up,
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(48)),
      padding: const EdgeInsets.symmetric(horizontal: kPadding12, vertical: 6),
      margin: const EdgeInsets.only(bottom: 32, left: 16, right: 16),
      showCloseIcon: true,
      closeIconColor: labelColor.withValues(alpha: .5),
      behavior: SnackBarBehavior.floating,
      content: Text(
        message ?? "An error occurred",
        style: Theme.of(
          context,
        ).textTheme.bodyMedium!.copyWith(color: labelColor),
      ),
    ),
  );
}
