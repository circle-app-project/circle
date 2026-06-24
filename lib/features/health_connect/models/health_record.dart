import 'package:equatable/equatable.dart';

/// A single heart rate measurement read from Health Connect.
///
/// These are in-memory only — Health Connect is treated as the source of
/// truth, so there is no ObjectBox persistence for health records.
class HeartRateRecord extends Equatable {
  /// The moment the reading was taken.
  final DateTime timestamp;

  /// Beats per minute.
  final int bpm;

  const HeartRateRecord({required this.timestamp, required this.bpm});

  @override
  List<Object?> get props => [timestamp, bpm];
}

/// A single blood oxygen / SpO2 measurement read from Health Connect.
class BloodOxygenRecord extends Equatable {
  /// The moment the reading was taken.
  final DateTime timestamp;

  /// SpO2 saturation as a percentage (0–100).
  final double percentage;

  const BloodOxygenRecord({required this.timestamp, required this.percentage});

  @override
  List<Object?> get props => [timestamp, percentage];
}
