import 'package:equatable/equatable.dart';

import '../core/enums.dart';

/// One entry in a request's status history. Mirrors the mobile
/// `HlaStatusEvent` serialization.
class HlaStatusEvent extends Equatable {
  const HlaStatusEvent({
    required this.status,
    required this.timestamp,
    this.note,
  });

  final HlaTestStatus status;
  final DateTime timestamp;
  final String? note;

  factory HlaStatusEvent.now({required HlaTestStatus status, String? note}) {
    return HlaStatusEvent(
      status: status,
      timestamp: DateTime.now().toUtc(),
      note: note,
    );
  }

  Map<String, dynamic> toMap() => {
        'status': status.name,
        'timestamp': timestamp.toUtc().toIso8601String(),
        'note': note,
      };

  factory HlaStatusEvent.fromMap(Map<String, dynamic> map) {
    return HlaStatusEvent(
      status: HlaTestStatus.values.firstWhere(
        (s) => s.name == map['status'],
        orElse: () => HlaTestStatus.requested,
      ),
      timestamp:
          DateTime.tryParse(map['timestamp'] as String? ?? '') ??
              DateTime.now().toUtc(),
      note: map['note'] as String?,
    );
  }

  @override
  List<Object?> get props => [status, timestamp, note];
}
