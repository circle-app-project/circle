import 'package:flutter/material.dart';

import '../../../../core/core.dart';

/// A small colored chip representing an [HlaTestStatus]. Cancelled is red,
/// results stages are green, everything else uses the brand purple.
class HlaStatusChip extends StatelessWidget {
  const HlaStatusChip({super.key, required this.status});

  final HlaTestStatus status;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final (Color bg, Color fg) = _colors(isDark);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: kPadding12,
        vertical: kPadding4,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(kPadding24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(status.icon, size: 14, color: fg),
          const SizedBox(width: kPadding4),
          Text(
            status.label,
            style: AppTextStyles.bodySmall.copyWith(
              color: fg,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  (Color, Color) _colors(bool isDark) {
    if (status.isCancelledState) {
      return isDark
          ? (AppColours.red20, AppColours.red90)
          : (AppColours.red95, AppColours.red40);
    }
    if (status.isResultsReady) {
      return isDark
          ? (AppColours.green20, AppColours.green90)
          : (AppColours.green95, AppColours.green40);
    }
    return isDark
        ? (AppColours.purple20, AppColours.purple90)
        : (AppColours.purple95, AppColours.purple40);
  }
}
