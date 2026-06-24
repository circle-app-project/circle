import 'package:equatable/equatable.dart';

import '../../../core/utils/enums.dart';

/// One entry in an HLA request's status history: the [status] reached, the
/// [timestamp] it was reached, and an optional staff [note] explaining the
/// change. The patient's status timeline is built from a list of these.
///
/// Plain Dart model — stored as a JSON-encoded list inside [HlaTestRequest].
class HlaStatusEvent extends Equatable {
  final HlaTestStatus status;
  final DateTime timestamp;
  final String? note;

  const HlaStatusEvent({
    required this.status,
    required this.timestamp,
    this.note,
  });

  /// Convenience constructor stamping the current time.
  factory HlaStatusEvent.now({required HlaTestStatus status, String? note}) {
    return HlaStatusEvent(
      status: status,
      timestamp: DateTime.now().toUtc(),
      note: note,
    );
  }

  HlaStatusEvent copyWith({
    HlaTestStatus? status,
    DateTime? timestamp,
    String? note,
  }) {
    return HlaStatusEvent(
      status: status ?? this.status,
      timestamp: timestamp ?? this.timestamp,
      note: note ?? this.note,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "status": status.name,
      "timestamp": timestamp.toUtc().toIso8601String(),
      "note": note,
    };
  }

  factory HlaStatusEvent.fromMap(Map<String, dynamic> map) {
    return HlaStatusEvent(
      status: HlaTestStatus.values.byName(map["status"] as String),
      timestamp: DateTime.parse(map["timestamp"] as String),
      note: map["note"] as String?,
    );
  }

  @override
  List<Object?> get props => [status, timestamp, note];
}
