import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:gap/gap.dart';

import '../../../../core/core.dart';
import '../../../../core/extensions/date_time_formatter.dart';
import '../../models/hla_appointment_slot.dart';

/// A selectable appointment slot row showing date/time, location, and
/// remaining seats.
class HlaSlotTile extends StatelessWidget {
  const HlaSlotTile({
    super.key,
    required this.slot,
    this.isSelected = false,
    this.onTap,
  });

  final HlaAppointmentSlot slot;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(kPadding16),
      child: Container(
        padding: const EdgeInsets.all(kPadding16),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primaryContainer
              : theme.colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(kPadding16),
          border: isSelected
              ? Border.all(color: theme.colorScheme.primary, width: 1.5)
              : null,
        ),
        child: Row(
          children: [
            Icon(
              FluentIcons.calendar_clock_24_regular,
              color: theme.colorScheme.primary,
            ),
            const Gap(kPadding12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    slot.dateTime.toLocal().formatDateWithTime(context),
                    style: theme.textTheme.bodyLarge
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const Gap(kPadding4),
                  Text(
                    slot.location,
                    style: AppTextStyles.bodySmall
                        .copyWith(color: AppColours.neutral50),
                  ),
                ],
              ),
            ),
            Text(
              "${slot.remainingSeats} left",
              style: AppTextStyles.bodySmall.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
