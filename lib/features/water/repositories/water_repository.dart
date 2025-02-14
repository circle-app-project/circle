import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:circle/core/core.dart';
import '../../auth/auth.dart';
import '../water.dart';

abstract class WaterRepository {
  FutureEither<List<WaterLog>> getWaterLogs({
    AppUser? user,
    bool? getFromRemote,
    DateTime? start,
    DateTime? end,
  });

  FutureEither<WaterLog> putWaterLog({
    required WaterLog log,
    required AppUser user,
    bool updateRemote = false,
  });

  FutureEither<void> deleteLog({
    required WaterLog log,
    required AppUser user,
    bool updateRemote = false,
  });

  FutureEither<void> clearLogs({
    required AppUser user,
    bool updateRemote = false,
  });

  FutureEither<int> count({required AppUser user});

  ///------Water Preferences Section----///

  FutureEither<WaterPreferences> getWaterPreferences({
    AppUser? user,
    bool? getFromRemote,
    DateTime? start,
    DateTime? end,
  });

  FutureEither<WaterPreferences> putPreferences({
    required WaterPreferences preferences,
    required AppUser? user,
    bool? updateRemote = false,
  });

  FutureEither<void> deletePreferences({
    required AppUser user,
    bool updateRemote = false,
  });

  ///Todo: Add Operations for manipulating data, eg querying with filters, calculating stats, etc
}

class WaterRepositoryImpl implements WaterRepository {
  final WaterService _waterService;
  final WaterLocalService _waterLocalService;

  WaterRepositoryImpl({
    required WaterService waterService,
    required WaterLocalService waterLocalService,
  }) : _waterLocalService = waterLocalService,
       _waterService = waterService;

  ///------Water Log Section----///
  @override
  FutureEither<List<WaterLog>> getWaterLogs({
    AppUser? user,
    bool? getFromRemote,
    DateTime? start,
    DateTime? end,
  }) async {
    return futureHandler(() async {
      List<WaterLog> logs = [];

      ///Get from Remote when instructed
      if (user != null && getFromRemote != null && getFromRemote) {
        logs = await _getRemoteLogs(user.uid);
        if (logs.isNotEmpty) {
          //If Not empty, return, else get from local
          return logs;
        } else {
          log("No Logs found from Remote", name: "Water Repository");
          return [];
        }
      }

      logs = await _waterLocalService.getWaterLogs(start: start, end: end);

      return logs;
    });
  }

  Future<List<WaterLog>> _getRemoteLogs(String uid) async {
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await _waterService.getLogs(uid);

    if (documentSnapshot.exists &&
        documentSnapshot.data() != null &&
        documentSnapshot.data()!.isNotEmpty) {
      List<WaterLog> otherLogs =
          documentSnapshot.data()!["entries"].map((e) {
            return WaterLog.fromMap(e);
          }).toList();

      // List<WaterLog> logs =
      //     List<WaterLog>.from(documentSnapshot.data()!["entries"]);

      return otherLogs;
    } else {
      log("Log data doesn't exist from Remote", name: "Water Repository");
      return [];
      // throw Exception("Log data doesn't exist");
    }
  }

  @override
  FutureEither<WaterLog> putWaterLog({
    required WaterLog log,
    required AppUser user,
    bool updateRemote = false,
  }) async {
    return futureHandler(() async {
      if (updateRemote) {
        if (log.id == 0) {
          await _waterService.addLog(waterLog: log, uid: user.uid);
        } else {
          await _waterService.updateLog(waterLog: log, uid: user.uid);
        }
      }
      return _waterLocalService.putAndGetWaterLog(log);
    });
  }

  @override
  FutureEither<void> deleteLog({
    required WaterLog log,
    required AppUser user,
    bool updateRemote = false,
  }) async {
    return futureHandler(() async {
      _waterLocalService.deleteWaterLog(log);
      if (updateRemote) {
        await _waterService.deleteLog(waterLog: log, uid: user.uid);
      }
    });
  }

  @override
  FutureEither<void> clearLogs({
    required AppUser user,
    bool updateRemote = false,
  }) async {
    return futureHandler(() async {
      if (updateRemote) {
        await _waterService.clear(uid: user.uid);
      }
      _waterLocalService.clearLogs();
    });
  }

  @override
  FutureEither<int> count({required AppUser user}) async {
    return futureHandler(() async {
      return _waterLocalService.count();
    });
  }

  ///------Water Preferences Section----///

  @override
  FutureEither<WaterPreferences> getWaterPreferences({
    AppUser? user,
    bool? getFromRemote,
    DateTime? start,
    DateTime? end,
  }) async {
    return futureHandler(() async {
      WaterPreferences? preferences;
      preferences = _waterLocalService.getPreferences();
      ///Get from Remote when instructed
      if (user != null && getFromRemote != null && getFromRemote) {
        preferences = await _waterService.getPreferences(user.uid);
        return preferences;
      }

      return preferences;
    });
  }

  @override
  FutureEither<WaterPreferences> putPreferences({
    required WaterPreferences preferences,
    required AppUser? user,
    bool? updateRemote = false,
  }) async {
    return futureHandler(() async {
      if (updateRemote! && user != null) {
        if (preferences.id == 0) {
          /// Uses object box `id`a to determine if this is an old object or not
          /// An `id` of z indicates is a new object and means it should be added to the db
          /// A non `0` `id` means its an old object and should be updated
          await _waterService.addPreferences(
            preferences: preferences,
            uid: user.uid,
          );
        } else {
          await _waterService.updatePreferences(
            preferences: preferences,
            uid: user.uid,
          );
        }
      }
      return _waterLocalService.putAndGetPreferences(preferences);
    });
  }

  @override
  FutureEither<void> deletePreferences({
    required AppUser user,
    bool updateRemote = false,
  }) async {
    return futureHandler(() async {
      _waterLocalService.deletePreferences();
      if (updateRemote) {
        await _waterService.deletePreferences(user.uid);
      }
    });
  }

  ///Todo: Add Operations for manipulating data, eg querying with filters, calculating stats, etc
}
