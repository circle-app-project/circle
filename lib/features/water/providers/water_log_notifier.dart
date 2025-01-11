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
final WaterLocalService waterLocalService = WaterLocalService(store: database.store);

final WaterRepository waterRepository = WaterRepositoryImpl(
  waterLocalService: waterLocalService,
  waterService: waterService,

);

final WaterLogNotifierProvider waterLogNotifierProviderIml = waterLogNotifierProvider(
  waterRepository: waterRepository,
);


@Riverpod(keepAlive: true)
class WaterLogNotifier extends _$WaterLogNotifier {
late final WaterRepository _waterRepository;


  @override
  FutureOr<List<WaterLog>> build({required WaterRepository waterRepository}) async {
  _waterRepository = waterRepository;
    return [];
  }

  /// --- Logs ----///
  Future<void> getWaterLogs(
      {AppUser? user,
      bool? getFromRemote,
      DateTime? start,
      DateTime? end}) async {
    state = const AsyncValue.loading();
    final Either<Failure, List<WaterLog>> response =
        await _waterRepository.getWaterLogs(
            user: user,
            getFromRemote: getFromRemote,
            start:
                start ?? DateTime.now().copyWith(hour: 0, minute: 0, second: 0),
            end: end ??
                DateTime.now().copyWith(hour: 23, minute: 59, second: 59));
    response.fold((failure) {
  log("RETURNED FAILURE", name: "WATER LOG NOTIFIER");
      state = AsyncValue.error(failure, failure.stackTrace ?? StackTrace.current);
    }, (waterLogs) {
           log("RETURNED SUCCESS", name: "WATER LOG NOTIFIER");
      state = AsyncValue.data(waterLogs);
    });
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
  //
  // Future<List<WaterLog>> _getLogsWithinTimeFrame(
  //     {required DateTime start, required DateTime end}) async {
  //   List<WaterLog> logs = state.value!;
  //
  //   //Filter for just logs within timeframe
  //   logs = logs.filter((log) {
  //     return log.timestamp.isAfter(start) && log.timestamp.isBefore(end);
  //   }).toList();
  //
  //   _logsWithinTimeframe = logs;
  //
  //   if (logs.isEmpty) {
  //     _totalWithinTimeframe = 0;
  //   }
  //   //Calculate total
  //   _totalWithinTimeframe = 0;
  //   for (WaterLog log in logs) {
  //     _totalWithinTimeframe += log.amount;
  //   }
  //
  //   return logs;
  // }

  Future<void> addWaterLog(
      {required WaterLog entry,
      required AppUser user,
      bool updateRemote = false}) async {
    log("ADDING WATER LOG", name: "Water Log Notifier");
    //print("Adding log");
    Stopwatch stopwatch = Stopwatch()..start();
    state = const AsyncValue.loading();
    final Either<Failure, void> response = await _waterRepository.addWaterLog(
        log: entry, user: user, updateRemote: updateRemote);
    response.fold((failure) {
      log("RETURNED FAILURE", name: "Water Log Notifier");
      state = AsyncValue.error(failure, failure.stackTrace ?? StackTrace.current);
    }, (empty) async {
           log("RETURNED FAILURE", name: "Water Log Notifier");
      await getWaterLogs();
      //  print("Added stopwatch and got updated logs");
      stopwatch.stop();
      log("Add water log took ${stopwatch.elapsedMilliseconds} ms");
    });
  }

  Future<void> updateWaterLog({
    required WaterLog entry,
    required AppUser user,
    bool updateRemote = false,
  }) async {
    log("UPDATING WATER LOG", name: "Water Log Notifier");
    state = const AsyncValue.loading();
    final Either<Failure, void> response = await _waterRepository.addWaterLog(
        log: entry, user: user, updateRemote: updateRemote);
    response.fold((failure) {
           log("RETURNED FAILURE", name: "Water Log Notifier");
      state = AsyncValue.error(failure, failure.stackTrace ?? StackTrace.current);
    }, (empty) async {
           log("RETURNED FAILURE", name: "Water Log Notifier");
      await getWaterLogs();
    });
  }

  Future<void> deleteWaterLog({
    required WaterLog entry,
    required AppUser user,
    bool updateRemote = false,
  }) async {
    log("DELETING WATER LOG", name: "Water Log Notifier");
    state = const AsyncValue.loading();
    final Either<Failure, void> response = await _waterRepository.deleteLog(
        log: entry, user: user, updateRemote: updateRemote);
    response.fold((failure) {
           log("RETURNED FAILURE", name: "Water Log Notifier");
      state = AsyncValue.error(failure, failure.stackTrace ?? StackTrace.current);
    }, (empty) async {
           log("RETURNED FAILURE", name: "Water Log Notifier");
      await getWaterLogs();
    });
  }

  Future<void> clear({
    required AppUser user,
    bool updateRemote = false,
  }) async {
    log("CLEARING WATER LOG", name: "Water Log Notifier");
    state = const AsyncValue.loading();
    final Either<Failure, void> response =
        await _waterRepository.clear(user: user, updateRemote: updateRemote);
    response.fold((failure) {
           log("RETURNED FAILURE", name: "Water Log Notifier");
      state = AsyncValue.error(failure, failure.stackTrace ?? StackTrace.current);
    }, (empty) async {
           log("RETURNED FAILURE", name: "Water Log Notifier");
      await getWaterLogs();
    });
  }
}
