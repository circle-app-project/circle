import 'package:flutter/material.dart';

import '../../core/core.dart';

class AppChip extends StatefulWidget {
  const AppChip({
    super.key,
    this.onSelected,
    this.onDeleted,
    required this.label,
    this.chipType = ChipType.filter,
    this.selectedColor,
    this.selectedBackgroundColor,
  });

  final Function(bool)? onSelected;
  final VoidCallback? onDeleted;
  final ChipType chipType;
  final String label;
  final Color? selectedColor;
  final Color? selectedBackgroundColor;

  @override
  State<AppChip> createState() => _AppChipState();
}

class _AppChipState extends State<AppChip> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    if (widget.chipType == ChipType.filter &&
        widget.onSelected == null) {
      throw ErrorHint(
          "onSelected must not be null on a Filter Chip type, please consider adding the onSelected parameter");
    }

    final ThemeData theme = Theme.of(context);
    final bool isDarkMode = theme.brightness == Brightness.dark;

    if (widget.chipType == ChipType.filter) {
      return FilterChip(
          padding: const EdgeInsets.symmetric(
              horizontal: kPadding12, vertical: kPadding8),
          side: isSelected
              ? null
              : BorderSide(
                  width: 1,
                  color: isDarkMode
                      ? AppColours.neutral20
                      : AppColours.neutral90),
          backgroundColor: theme.scaffoldBackgroundColor,
          selectedColor:
              widget.selectedBackgroundColor ?? theme.colorScheme.primary,
          showCheckmark: true,
          checkmarkColor: widget.selectedColor ?? Colors.white,
          selected: isSelected,
          label: Text(
            widget.label,
            style: theme.textTheme.bodyMedium!.copyWith(
                color:
                    isSelected ? (widget.selectedColor ?? Colors.white) : null),
          ),
          onDeleted: widget.onDeleted,
          onSelected: (value) {
            setState(() {
              isSelected = value;
            });

            widget.onSelected!.call(value);
          });
    } else {
      return Chip(
        onDeleted: widget.onDeleted,
        visualDensity: VisualDensity.comfortable,
        padding: const EdgeInsets.symmetric(
            horizontal: kPadding12, vertical: kPadding8),
        backgroundColor: theme.scaffoldBackgroundColor,
        side: BorderSide(
            width: 1,
            color: isDarkMode
                ? AppColours.neutral20
                : AppColours.neutral90),
        label: Text(
          widget.label,
          style: theme.textTheme.bodyMedium!.copyWith(
              color: isSelected
                  ? (widget.selectedColor ?? theme.colorScheme.primary)
                  : null),
        ),
      );
    }
  }
}
