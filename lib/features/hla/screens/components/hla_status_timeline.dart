import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../../../../core/extensions/date_time_formatter.dart';
import '../../models/hla_status_event.dart';

/// A vertical timeline of the HLA journey. Completed stages are filled and
/// show the timestamp + any staff note; the current stage is highlighted;
/// upcoming stages are dimmed (AC US-4.1, US-4.2).
class HlaStatusTimeline extends StatelessWidget {
  const HlaStatusTimeline({
    super.key,
    required this.currentStatus,
    required this.history,
  });

  final HlaTestStatus currentStatus;
  final List<HlaStatusEvent> history;

  /// The forward sequence, excluding [HlaTestStatus.cancelled].
  static final List<HlaTestStatus> _stages = HlaTestStatus.values
      .where((s) => s != HlaTestStatus.cancelled)
      .toList();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    // A cancelled request shows its history as-is rather than the full ladder.
    if (currentStatus.isCancelledState) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0; i < history.length; i++)
            _TimelineRow(
              event: history[i],
              label: history[i].status.label,
              icon: history[i].status.icon,
              isCompleted: true,
              isCurrent: i == history.length - 1,
              isLast: i == history.length - 1,
              isCancelled: history[i].status.isCancelledState,
            ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < _stages.length; i++)
          _TimelineRow(
            event: _eventFor(_stages[i]),
            label: _stages[i].label,
            icon: _stages[i].icon,
            isCompleted: _stages[i].order <= currentStatus.order,
            isCurrent: _stages[i] == currentStatus,
            isLast: i == _stages.length - 1,
            isCancelled: false,
            theme: theme,
          ),
      ],
    );
  }

  HlaStatusEvent? _eventFor(HlaTestStatus status) {
    for (final event in history) {
      if (event.status == status) return event;
    }
    return null;
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({
    required this.label,
    required this.icon,
    required this.isCompleted,
    required this.isCurrent,
    required this.isLast,
    required this.isCancelled,
    this.event,
    this.theme,
  });

  final String label;
  final IconData icon;
  final bool isCompleted;
  final bool isCurrent;
  final bool isLast;
  final bool isCancelled;
  final HlaStatusEvent? event;
  final ThemeData? theme;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = this.theme ?? Theme.of(context);
    final Color activeColor =
        isCancelled ? theme.colorScheme.error : theme.colorScheme.primary;
    const Color dimColor = AppColours.neutral60;
    final Color nodeColor = isCompleted ? activeColor : Colors.transparent;
    final Color lineColor = isCompleted ? activeColor : AppColours.neutral80;
    final Color labelColor =
        isCompleted ? theme.colorScheme.onSurface : dimColor;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: nodeColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: lineColor, width: 2),
                ),
                child: Icon(
                  icon,
                  size: 16,
                  color: isCompleted ? theme.colorScheme.onPrimary : dimColor,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(width: 2, color: lineColor),
                ),
            ],
          ),
          const SizedBox(width: kPadding12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: kPadding24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: labelColor,
                      fontWeight:
                          isCurrent ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                  if (event != null) ...[
                    const SizedBox(height: kPadding4),
                    Text(
                      event!.timestamp.toLocal().formatDateWithTime(context),
                      style: AppTextStyles.bodySmall
                          .copyWith(color: AppColours.neutral50),
                    ),
                    if (event!.note != null && event!.note!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: kPadding4),
                        child: Text(
                          event!.note!,
                          style: AppTextStyles.bodySmall
                              .copyWith(color: labelColor),
                        ),
                      ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
