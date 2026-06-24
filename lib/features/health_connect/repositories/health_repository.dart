import '../../../core/core.dart';
import '../models/health_summary.dart';
import '../services/health_connect_service.dart';

/// Contract for reading health data and managing Health Connect permissions.
///
/// All methods return [FutureEither] — failures are surfaced as [Failure]
/// rather than thrown, consistent with the rest of the app.
abstract class HealthRepository {
  /// Checks the current permission grant without prompting the user.
  FutureEither<HealthPermissionStatus> checkPermissions();

  /// Prompts the user to grant read access.
  FutureEither<HealthPermissionStatus> requestPermissions();

  /// Reads steps, heart rate, and blood oxygen into a single [HealthSummary].
  FutureEither<HealthSummary> getHealthSummary();
}

class HealthRepositoryImpl implements HealthRepository {
  final HealthConnectService _service;

  HealthRepositoryImpl({required HealthConnectService service})
      : _service = service;

  @override
  FutureEither<HealthPermissionStatus> checkPermissions() {
    return futureHandler(() async {
      final bool available = await _service.isAvailable();
      if (!available) return HealthPermissionStatus.notAvailable;
      final bool granted = await _service.hasPermissions();
      return granted
          ? HealthPermissionStatus.granted
          : HealthPermissionStatus.denied;
    });
  }

  @override
  FutureEither<HealthPermissionStatus> requestPermissions() {
    return futureHandler(() async {
      final bool available = await _service.isAvailable();
      if (!available) return HealthPermissionStatus.notAvailable;
      final bool granted = await _service.requestPermissions();
      return granted
          ? HealthPermissionStatus.granted
          : HealthPermissionStatus.denied;
    });
  }

  @override
  FutureEither<HealthSummary> getHealthSummary() {
    return futureHandler(() async {
      // Each metric is independent — a null/empty result for one simply
      // propagates to the model rather than failing the whole summary.
      final int? steps = await _service.getTodaySteps();
      final heartRates = await _service.getHeartRates();
      final bloodOxygen = await _service.getBloodOxygenReadings();

      return HealthSummary(
        stepsToday: steps,
        latestHeartRate: heartRates.isNotEmpty ? heartRates.first : null,
        latestBloodOxygen: bloodOxygen.isNotEmpty ? bloodOxygen.first : null,
        recentHeartRates: heartRates,
        recentBloodOxygenReadings: bloodOxygen,
      );
    });
  }
}
