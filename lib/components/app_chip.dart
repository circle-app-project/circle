import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../core/core.dart';

class AppChip extends StatefulWidget {
  const AppChip({
    super.key,
    this.onSelected,
    this.onDeleted,
    required this.label,
    this.color,
    this.backgroundColor,
    this.icon,
    this.iconPath,
  });

  final Function(bool)? onSelected;
  final VoidCallback? onDeleted;
  final String label;
  final Color? color;
  final Color? backgroundColor;
  final IconData? icon;
  final String? iconPath;


  @override
  State<AppChip> createState() => _AppChipState();
}

class _AppChipState extends State<AppChip> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

      return Chip(
        onDeleted: widget.onDeleted,
        deleteIcon: const Icon(HugeIcons.strokeRoundedCancel01),
        visualDensity: VisualDensity.comfortable,
        padding: EdgeInsets.only(
          top: kPadding12,
          bottom: kPadding12,
          left: (widget.icon != null || widget.iconPath != null)
              ? kPadding8
              : kPadding12,
          right: kPadding12,
        ),
        backgroundColor: widget.backgroundColor ?? theme.colorScheme.surfaceContainerLow,

        label: Text(
          widget.label,
          style: theme.textTheme.bodyMedium!.copyWith(
              color: isSelected
                  ? (widget.color ?? theme.colorScheme.primary)
                  : null),
        ),
      );
    }

}
