import 'dart:developer';

import '../../../../core/error/exceptions.dart';
import '../../../../objectbox.g.dart';
import '../../water.dart';

/// Todo: Add try catches to all blocks and thow App exceptions of type localdbStorage when necessary
/// Todo: Upddate service with Put and Get
class WaterLocalService {
  late final Box<WaterLog> waterLogBox;
  late final Box<WaterPreferences> waterPreferencesBox;

  WaterLocalService({required Store store})
    : waterLogBox = store.box<WaterLog>(),
      waterPreferencesBox = store.box<WaterPreferences>();

  ///----Water Logs ----///
  Future<List<WaterLog>> getWaterLogs({DateTime? start, DateTime? end}) async {
    List<WaterLog> logs = [];
    late final Query query;

    try {
      if (start != null && end != null) {
        query =
            waterLogBox
                .query(WaterLog_.timestamp.betweenDate(start, end))
                .build();
        logs = query.find() as List<WaterLog>;
      }

      if (start != null && end == null) {
        query =
            waterLogBox
                .query(WaterLog_.timestamp.greaterOrEqualDate(start))
                .build();
        logs = query.find() as List<WaterLog>;
      }

      if (end != null && start == null) {
        query =
            waterLogBox.query(WaterLog_.timestamp.lessOrEqualDate(end)).build();
        logs = query.find() as List<WaterLog>;
      }

      if (start == null && end == null) {
        logs = waterLogBox.getAll();
      }

      logs.sort((a, b) => a.timestamp.compareTo(b.timestamp));
      return logs;
    } catch (e, stack) {
      log(
        "Failed to get water logs",
        error: e,
        stackTrace: stack,
        name: "Water Local Service",
      );
      throw AppException(
        message: "Failed to get water logs",
        debugMessage: e.toString(),
        stackTrace: stack,
        type: ExceptionType.localStorage,
      );
    } finally {
      query.close();
    }
  }

  Future<WaterLog> putAndGetWaterLog(WaterLog waterLog) async {
    try {
      return await waterLogBox.putAndGetAsync(
        waterLog,
        mode: waterLog.id == 0 ? PutMode.put : PutMode.update,
      );
    } catch (e, stackTrace) {
      // Throws app exception
      log(
        "Failed to put and get water log",
        error: e,
        stackTrace: stackTrace,
        name: "Medication Local Service",
      );
      throw AppException(
        message: "Failed to put and get water log",
        debugMessage: e.toString(),
        stackTrace: stackTrace,
        type: ExceptionType.localStorage,
      );
    }
  }

  void deleteWaterLog(WaterLog waterLog) {
    try {
      bool isDeleted = waterLogBox.remove(waterLog.id);
      if (isDeleted) {
        log("WaterLog deleted successfully", name: "Water Local Service");
      }
    } catch (e, stackTrace) {
      /// Log and throw app exception
      log(
        "Failed to delete water log",
        error: e,
        stackTrace: stackTrace,
        name: "Water Local Service",
      );
      throw AppException(
        message: "Failed to delete water log",
        debugMessage: e.toString(),
        stackTrace: stackTrace,
        type: ExceptionType.localStorage,
      );
    }
  }

  void clearLogs() {
    try {
      waterLogBox.removeAll();
    } catch (e, stackTrace) {
      /// Log and throw app exception
      log(
        "Failed to clear logs",
        error: e,
        stackTrace: stackTrace,
        name: "Water Local Service",
      );
      throw AppException(
        message: "Failed to clear logs",
        debugMessage: e.toString(),
        stackTrace: stackTrace,
        type: ExceptionType.localStorage,
      );
    }
  }

  int count() {
    return waterLogBox.count();
  }

  /// ----- Water Preferences Section ----- ///

  WaterPreferences getPreferences() {
    try {
      List<WaterPreferences> preferences = waterPreferencesBox.getAll();
      return preferences.isNotEmpty
          ? preferences.first
          : WaterPreferences.empty;
    } catch (e, stackTrace) {
      /// Log and throw app exception
      log(
        "Failed to get water preferences",
        error: e,
        stackTrace: stackTrace,
        name: "Water Local Service",
      );
      throw AppException(
        message: "Failed to get water preferences",
        debugMessage: e.toString(),
        stackTrace: stackTrace,
        type: ExceptionType.localStorage,
      );
    }
  }

  Future<WaterPreferences> putAndGetPreferences(
    WaterPreferences preferences,
  ) async {
    try {
      return await waterPreferencesBox.putAndGetAsync(
        preferences,
        mode: preferences.id == 0 ? PutMode.put : PutMode.update,
      );
    } catch (e, stackTrace) {
      // Throws app exception
      log(
        "Failed to put and get water preferences",
        error: e,
        stackTrace: stackTrace,
        name: "Water Local Service",
      );
      throw AppException(
        message: "Failed to put and get water preferences",
        debugMessage: e.toString(),
        stackTrace: stackTrace,
        type: ExceptionType.localStorage,
      );
    }
  }

  @Deprecated("Prefer putAndGetPreferences Instead")
  void updatePreferences(WaterPreferences preferences) {
    waterPreferencesBox.put(preferences, mode: PutMode.update);
  }

  void deletePreferences() {
    try {
      waterPreferencesBox.removeAll();
    } catch (e, stackTrace) {
      /// Log and throw app exception
      log(
        "Failed to clear water preferences",
        error: e,
        stackTrace: stackTrace,
        name: "Water Local Service",
      );
      throw AppException(
        message: "Failed to clear water preferences",
        debugMessage: e.toString(),
        stackTrace: stackTrace,
        type: ExceptionType.localStorage,
      );
    }
  }
}
