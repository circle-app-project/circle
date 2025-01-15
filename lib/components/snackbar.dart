import 'package:circle/core/error/exceptions.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

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
      backgroundColor = AppColours.green60;
    case SnackBarMode.error:
      backgroundColor = Theme.of(context).colorScheme.error;
    default:
      backgroundColor = Theme.of(context).colorScheme.surfaceContainerHighest;
      labelColor =
          Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : AppColours.black;
  }

  if (message == null && error == null) {
    throw ErrorHint(
      "Message cannot be null if Error is null",
    );
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      elevation: 10,
      //  dismissDirection: DismissDirection.up,
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      padding: const EdgeInsets.symmetric(
        horizontal: kPadding16,
        vertical: kPadding8,
      ),
      margin: const EdgeInsets.only(bottom: 32, left: 16, right: 16),
      closeIconColor: labelColor,
      showCloseIcon: true,
      behavior: SnackBarBehavior.floating,
      content: Row(
        children: [
          Visibility(
            visible: mode == SnackBarMode.notification,
            child: const CircularProgressIndicator(
              // foregroundColor: Colors.white,
            ),
          ),
          const Gap(kPadding16),
          Expanded(
            child: Text(
              message ?? "An error occurred",
              style: Theme.of(
                context,
              ).textTheme.bodyMedium!.copyWith(color: labelColor),
            ),
          ),
        ],
      ),
    ),
  );
}
