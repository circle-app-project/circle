import 'dart:developer';

import 'package:health/health.dart';

import '../../../core/error/exceptions.dart';
import '../models/health_record.dart';

/// The data types this feature reads. Central list — add or remove a type
/// here and the request/check/fetch logic follows automatically.
const List<HealthDataType> _kHealthTypes = [
  HealthDataType.STEPS,
  HealthDataType.HEART_RATE,
  HealthDataType.BLOOD_OXYGEN,
];

/// Low-level I/O with the `health` package (Health Connect on Android,
/// HealthKit on iOS). Contains no business logic — it only talks to the
/// platform and maps raw data points onto the feature's models.
class HealthConnectService {
  final Health _health = Health();

  /// `configure()` must run once before any other call. Tracked so repeated
  /// service calls don't reconfigure unnecessarily.
  bool _isConfigured = false;

  Future<void> _ensureConfigured() async {
    if (_isConfigured) return;
    await _health.configure();
    _isConfigured = true;
  }

  /// Whether Health Connect (Android) / HealthKit (iOS) is available on this
  /// device. Returns false rather than throwing so the caller can branch to a
  /// "not available" state.
  Future<bool> isAvailable() async {
    try {
      await _ensureConfigured();
      return await _health.isHealthConnectAvailable();
    } catch (e, stack) {
      log('isAvailable failed', error: e, stackTrace: stack,
          name: 'HealthConnectService');
      return false;
    }
  }

  /// Checks whether read permissions are already granted, without prompting.
  Future<bool> hasPermissions() async {
    try {
      await _ensureConfigured();
      final result = await _health.hasPermissions(_kHealthTypes);
      return result ?? false;
    } catch (e, stack) {
      log('hasPermissions failed', error: e, stackTrace: stack,
          name: 'HealthConnectService');
      return false;
    }
  }

  /// Prompts the user to grant read access to [_kHealthTypes].
  /// Returns true when access is granted.
  Future<bool> requestPermissions() async {
    try {
      await _ensureConfigured();
      return await _health.requestAuthorization(_kHealthTypes);
    } catch (e, stack) {
      log('requestPermissions failed', error: e, stackTrace: stack,
          name: 'HealthConnectService');
      throw AppException(
        message: 'Could not request Health Connect permissions',
        debugMessage: e.toString(),
        stackTrace: stack,
      );
    }
  }

  /// Returns today's total step count, or null when no data is available.
  Future<int?> getTodaySteps() async {
    try {
      await _ensureConfigured();
      final DateTime now = DateTime.now();
      final DateTime startOfDay = DateTime(now.year, now.month, now.day);
      return await _health.getTotalStepsInInterval(startOfDay, now);
    } catch (e, stack) {
      log('getTodaySteps failed', error: e, stackTrace: stack,
          name: 'HealthConnectService');
      throw AppException(
        message: 'Failed to fetch step count',
        debugMessage: e.toString(),
        stackTrace: stack,
      );
    }
  }

  /// Returns heart rate readings from the last [hours] hours, newest first.
  Future<List<HeartRateRecord>> getHeartRates({int hours = 24}) async {
    try {
      await _ensureConfigured();
      final DateTime end = DateTime.now();
      final DateTime start = end.subtract(Duration(hours: hours));
      final List<HealthDataPoint> points = await _health.getHealthDataFromTypes(
        types: const [HealthDataType.HEART_RATE],
        startTime: start,
        endTime: end,
      );
      final records = points
          .map(
            (point) => HeartRateRecord(
              timestamp: point.dateFrom,
              bpm: (point.value as NumericHealthValue).numericValue.round(),
            ),
          )
          .toList()
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
      return records;
    } catch (e, stack) {
      log('getHeartRates failed', error: e, stackTrace: stack,
          name: 'HealthConnectService');
      throw AppException(
        message: 'Failed to fetch heart rate data',
        debugMessage: e.toString(),
        stackTrace: stack,
      );
    }
  }

  /// Returns blood oxygen (SpO2) readings from the last [hours] hours,
  /// newest first.
  Future<List<BloodOxygenRecord>> getBloodOxygenReadings({
    int hours = 24,
  }) async {
    try {
      await _ensureConfigured();
      final DateTime end = DateTime.now();
      final DateTime start = end.subtract(Duration(hours: hours));
      final List<HealthDataPoint> points = await _health.getHealthDataFromTypes(
        types: const [HealthDataType.BLOOD_OXYGEN],
        startTime: start,
        endTime: end,
      );
      final records = points
          .map(
            (point) => BloodOxygenRecord(
              timestamp: point.dateFrom,
              percentage: _normalizeOxygen(
                (point.value as NumericHealthValue).numericValue.toDouble(),
              ),
            ),
          )
          .toList()
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
      return records;
    } catch (e, stack) {
      log('getBloodOxygenReadings failed', error: e, stackTrace: stack,
          name: 'HealthConnectService');
      throw AppException(
        message: 'Failed to fetch SpO2 data',
        debugMessage: e.toString(),
        stackTrace: stack,
      );
    }
  }

  /// Health Connect reports SpO2 as a percentage (e.g. 98.0) while HealthKit
  /// reports a fraction (e.g. 0.98). Normalize both to a 0–100 percentage.
  double _normalizeOxygen(double raw) => raw <= 1 ? raw * 100 : raw;
}
