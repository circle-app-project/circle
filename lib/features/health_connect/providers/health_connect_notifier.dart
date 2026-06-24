import 'dart:developer';

import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/core.dart';
import '../health_connect.dart';

part 'health_connect_notifier.g.dart';

// ─── Singleton wiring (same pattern as the water/meds features) ──────────────

final HealthConnectService healthConnectService = HealthConnectService();

final HealthRepository healthRepository = HealthRepositoryImpl(
  service: healthConnectService,
);

final HealthPermissionNotifierProvider healthPermissionNotifierProviderImpl =
    healthPermissionNotifierProvider(healthRepository: healthRepository);

final HealthSummaryNotifierProvider healthSummaryNotifierProviderImpl =
    healthSummaryNotifierProvider(healthRepository: healthRepository);

// ─── Permission notifier ─────────────────────────────────────────────────────

/// Holds the Health Connect permission state, kept separate from the data
/// notifier because permission and data have different lifecycles.
@Riverpod(keepAlive: true)
class HealthPermissionNotifier extends _$HealthPermissionNotifier {
  late final HealthRepository _healthRepository;

  @override
  FutureOr<HealthPermissionStatus> build({
    required HealthRepository healthRepository,
  }) async {
    _healthRepository = healthRepository;
    return HealthPermissionStatus.unknown;
  }

  Future<void> checkPermissions() async {
    log('Checking Health Connect permissions',
        name: 'HealthPermissionNotifier');
    state = const AsyncValue.loading();
    final Either<Failure, HealthPermissionStatus> response =
        await _healthRepository.checkPermissions();
    response.fold(
      (failure) {
        log(
          'Failed: $failure, Message: ${failure.message}, Code: ${failure.code}',
          name: 'HealthPermissionNotifier',
          stackTrace: failure.stackTrace,
        );
        state = AsyncValue.error(
          failure,
          failure.stackTrace ?? StackTrace.current,
        );
      },
      (status) {
        log('Permission status: $status', name: 'HealthPermissionNotifier');
        state = AsyncValue.data(status);
      },
    );
  }

  Future<void> requestPermissions() async {
    log('Requesting Health Connect permissions',
        name: 'HealthPermissionNotifier');
    state = const AsyncValue.loading();
    final Either<Failure, HealthPermissionStatus> response =
        await _healthRepository.requestPermissions();
    response.fold(
      (failure) {
        log(
          'Failed: $failure, Message: ${failure.message}, Code: ${failure.code}',
          name: 'HealthPermissionNotifier',
          stackTrace: failure.stackTrace,
        );
        state = AsyncValue.error(
          failure,
          failure.stackTrace ?? StackTrace.current,
        );
      },
      (status) {
        log('Permission status after request: $status',
            name: 'HealthPermissionNotifier');
        state = AsyncValue.data(status);
      },
    );
  }
}

// ─── Summary data notifier ───────────────────────────────────────────────────

/// Holds the aggregated [HealthSummary] read from Health Connect.
@Riverpod(keepAlive: true)
class HealthSummaryNotifier extends _$HealthSummaryNotifier {
  late final HealthRepository _healthRepository;

  @override
  FutureOr<HealthSummary> build({
    required HealthRepository healthRepository,
  }) async {
    _healthRepository = healthRepository;
    return HealthSummary.empty;
  }

  Future<void> getHealthSummary() async {
    log('Getting health summary', name: 'HealthSummaryNotifier');
    state = const AsyncValue.loading();
    final Either<Failure, HealthSummary> response =
        await _healthRepository.getHealthSummary();
    response.fold(
      (failure) {
        log(
          'Failed: $failure, Message: ${failure.message}, Code: ${failure.code}',
          name: 'HealthSummaryNotifier',
          stackTrace: failure.stackTrace,
        );
        state = AsyncValue.error(
          failure,
          failure.stackTrace ?? StackTrace.current,
        );
      },
      (summary) {
        log('Health summary fetched', name: 'HealthSummaryNotifier');
        state = AsyncValue.data(summary);
      },
    );
  }
}
