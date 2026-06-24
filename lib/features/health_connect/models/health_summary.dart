import 'package:equatable/equatable.dart';

import 'health_record.dart';

/// The state of the user's Health Connect permission grant.
///
/// Lives here because it is a domain concept shared by both the repository
/// (which maps raw platform booleans onto it) and the providers/UI (which
/// branch on it).
enum HealthPermissionStatus {
  /// Permission has not been checked yet.
  unknown,

  /// Health Connect is not available on this device (e.g. not installed,
  /// or the platform is unsupported).
  notAvailable,

  /// Health Connect is available but the user has not granted access.
  denied,

  /// The user has granted read access to the requested data types.
  granted,
}

/// An aggregated, read-only snapshot of the user's health metrics.
///
/// Constructed by the repository from the raw service results and held in the
/// summary notifier's state.
class HealthSummary extends Equatable {
  /// Total steps recorded for today (null if unavailable).
  final int? stepsToday;

  /// The most recent heart rate reading (null if unavailable).
  final HeartRateRecord? latestHeartRate;

  /// The most recent blood oxygen reading (null if unavailable).
  final BloodOxygenRecord? latestBloodOxygen;

  /// Recent heart rate readings, newest first, for the detail screen.
  final List<HeartRateRecord> recentHeartRates;

  /// Recent blood oxygen readings, newest first, for the detail screen.
  final List<BloodOxygenRecord> recentBloodOxygenReadings;

  const HealthSummary({
    this.stepsToday,
    this.latestHeartRate,
    this.latestBloodOxygen,
    this.recentHeartRates = const [],
    this.recentBloodOxygenReadings = const [],
  });

  /// An empty summary, used as the initial notifier state.
  static const HealthSummary empty = HealthSummary();

  @override
  List<Object?> get props => [
        stepsToday,
        latestHeartRate,
        latestBloodOxygen,
        recentHeartRates,
        recentBloodOxygenReadings,
      ];
}
