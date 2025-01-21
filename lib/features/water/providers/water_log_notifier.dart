import 'dart:developer';

import 'package:circle/features/auth/auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/core.dart';
import '../../../main.dart';
import '../../auth/models/user/app_user.dart';
import '../water.dart';

part 'water_log_notifier.g.dart';

final WaterService waterService = WaterService();
final WaterLocalService waterLocalService = WaterLocalService(
  store: database.store,
);

final WaterRepository waterRepository = WaterRepositoryImpl(
  waterLocalService: waterLocalService,
  waterService: waterService,
);

final WaterLogNotifierProvider waterLogNotifierProviderIml =
    waterLogNotifierProvider(waterRepository: waterRepository);

@Riverpod(keepAlive: true)
class WaterLogNotifier extends _$WaterLogNotifier {
  late final WaterRepository _waterRepository;

  @override
  FutureOr<List<WaterLog>> build({
    required WaterRepository waterRepository,
  }) async {
    _waterRepository = waterRepository;
    return [];
  }

  /// --- Logs ----///
  Future<void> getWaterLogs({
    AppUser? user,
    bool? getFromRemote,
    DateTime? start,
    DateTime? end,
  }) async {
    log("Getting water logs", name: "Water Log Notifier");
    state = const AsyncValue.loading();
    final Either<Failure, List<WaterLog>> response = await _waterRepository
        .getWaterLogs(
          user: user,
          getFromRemote: getFromRemote,
          start:
              start ?? DateTime.now().copyWith(hour: 0, minute: 0, second: 0),
          end: end ?? DateTime.now().copyWith(hour: 23, minute: 59, second: 59),
        );
    response.fold(
      (failure) {
        log(
          "Failed: $failure, Message:${failure.message}, Code: ${failure.code}",
          name: "Water Log Notifier",
          stackTrace: failure.stackTrace,
        );
        state = AsyncValue.error(
          failure,
          failure.stackTrace ?? StackTrace.current,
        );
      },
      (waterLogs) {
        log("Success ${state.value}", name: "Water Log Notifier");
        state = AsyncValue.data(waterLogs);
      },
    );
  }

  double calculateTotalFromLogs({List<WaterLog>? logs}) {
    List<WaterLog> allLogs = logs ?? state.value!;
    double totalToday = 0;
    //Calculate total
    for (WaterLog log in allLogs) {
      totalToday += log.value;
    }
    return totalToday;
  }

  Future<void> putWaterLog({
    required WaterLog entry,
    required AppUser user,
    bool updateRemote = false,
  }) async {
    log("Adding Water Log", name: "Water Log Notifier");
    ///Todo: Eventually remove this timer
    Stopwatch stopwatch = Stopwatch()..start();
    state = const AsyncValue.loading();
    final Either<Failure, WaterLog> response = await _waterRepository.putWaterLog(
      log: entry,
      user: user,
      updateRemote: updateRemote,
    );
    response.fold(
      (failure) {
        log(
          "Failed: $failure, Message:${failure.message}, Code: ${failure.code}",
          name: "Water Log Notifier",
          stackTrace: failure.stackTrace,
        );
        state = AsyncValue.error(
          failure,
          failure.stackTrace ?? StackTrace.current,
        );
      },
      (entry) async {
        log("Success ${state.value}", name: "Water Log Notifier");
        await getWaterLogs();
        stopwatch.stop();
        log("Add water log took ${stopwatch.elapsedMilliseconds} ms");
      },
    );
  }

  Future<void> deleteWaterLog({
    required WaterLog entry,
    required AppUser user,
    bool updateRemote = false,
  }) async {
    log("Deleting water log", name: "Water Log Notifier");
    state = const AsyncValue.loading();
    final Either<Failure, void> response = await _waterRepository.deleteLog(
      log: entry,
      user: user,
      updateRemote: updateRemote,
    );
    response.fold(
      (failure) {
        log(
          "Failed: $failure, Message:${failure.message}, Code: ${failure.code}",
          name: "Water Log Notifier",
          stackTrace: failure.stackTrace,
        );
        state = AsyncValue.error(
          failure,
          failure.stackTrace!,
        );
      },
      (empty) async {
        log("Success ${state.value}", name: "Water Log Notifier");
        await getWaterLogs();

      },
    );
  }

  Future<void> clear({required AppUser user, bool updateRemote = false}) async {
    log("Clearing logs", name: "Water Log Notifier");
    state = const AsyncValue.loading();
    final Either<Failure, void> response = await _waterRepository.clearLogs(
      user: user,
      updateRemote: updateRemote,
    );
    response.fold(
      (failure) {
        log(
          "Failed: $failure, Message:${failure.message}, Code: ${failure.code}",
          name: "Water Log Notifier",
          stackTrace: failure.stackTrace,
        );
        state = AsyncValue.error(
          failure,
          failure.stackTrace!
        );
      },
      (empty) async {
        log("Success ${state.value}", name: "Water Log Notifier");
        await getWaterLogs();
      },
    );
  }
}
