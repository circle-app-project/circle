import 'package:flutter/material.dart';

import '../../../../core/theme/constants.dart';

class EmphasizedContainer extends StatelessWidget {
  const EmphasizedContainer({
    super.key,
    required this.label,
    required this.value,
    this.timescale,
  });
  final String label;
  final String value;
  final String? timescale;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDarkMode = theme.brightness == Brightness.dark;
    return Container(
      height: 76,
      padding: const EdgeInsets.symmetric(horizontal: kPadding24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kPadding16),
        color:
            isDarkMode
                ? theme.colorScheme.surfaceContainerHigh
                : theme.colorScheme.primaryContainer,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyLarge!.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: theme.textTheme.titleSmall!.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
              if (timescale != null && timescale!.isNotEmpty)
                Text(
                  timescale!,
                  style: theme.textTheme.bodySmall!.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
