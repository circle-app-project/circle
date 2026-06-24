import 'package:flutter/material.dart';

import '../core/enums.dart';
import '../core/format.dart';
import '../models/hla_status_event.dart';

/// A compact vertical timeline of the request's journey. Completed stages are
/// filled and show their timestamp + staff note; upcoming stages are dimmed.
class StatusTimeline extends StatelessWidget {
  const StatusTimeline({
    super.key,
    required this.currentStatus,
    required this.history,
  });

  final HlaTestStatus currentStatus;
  final List<HlaStatusEvent> history;

  static final List<HlaTestStatus> _stages = HlaTestStatus.values
      .where((s) => s != HlaTestStatus.cancelled)
      .toList();

  HlaStatusEvent? _eventFor(HlaTestStatus status) {
    for (final e in history) {
      if (e.status == status) return e;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final bool cancelled = currentStatus.isCancelledState;
    final List<HlaTestStatus> stages =
        cancelled ? history.map((e) => e.status).toList() : _stages;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < stages.length; i++)
          _Row(
            status: stages[i],
            event: _eventFor(stages[i]),
            completed: cancelled || stages[i].order <= currentStatus.order,
            current: stages[i] == currentStatus,
            isLast: i == stages.length - 1,
          ),
      ],
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.status,
    required this.event,
    required this.completed,
    required this.current,
    required this.isLast,
  });

  final HlaTestStatus status;
  final HlaStatusEvent? event;
  final bool completed;
  final bool current;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final Color active = status.isCancelledState ? scheme.error : scheme.primary;
    final Color line = completed ? active : scheme.outlineVariant;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: completed ? active : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(color: line, width: 2),
                ),
                child: Icon(
                  status.icon,
                  size: 14,
                  color: completed ? scheme.onPrimary : scheme.outline,
                ),
              ),
              if (!isLast) Expanded(child: Container(width: 2, color: line)),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    status.label,
                    style: TextStyle(
                      fontWeight: current ? FontWeight.w700 : FontWeight.w500,
                      color: completed ? scheme.onSurface : scheme.outline,
                    ),
                  ),
                  if (event != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      formatDateTime(event!.timestamp),
                      style: TextStyle(fontSize: 12, color: scheme.outline),
                    ),
                    if (event!.note != null && event!.note!.isNotEmpty)
                      Text(
                        event!.note!,
                        style: TextStyle(fontSize: 12, color: scheme.onSurface),
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
