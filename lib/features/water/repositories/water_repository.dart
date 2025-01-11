import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:circle/core/core.dart';

import '../../auth/auth.dart';
import '../water.dart';

abstract class WaterRepository {

  /// Todo: Refactor add and update into put method
  FutureEither<List<WaterLog>> getWaterLogs({
    AppUser? user,
    bool? getFromRemote,
    DateTime? start,
    DateTime? end,
  });

  FutureEither<void> addWaterLog({
    required WaterLog log,
    required AppUser user,
    bool updateRemote = false,
  });

  FutureEither<void> updateWaterLog({
    required WaterLog log,
    required AppUser user,
    bool updateRemote = false,
  });

  FutureEither<void> deleteLog({
    required WaterLog log,
    required AppUser user,
    bool updateRemote = false,
  });

  FutureEither<void> clear({required AppUser user, bool updateRemote = false});

  FutureEither<int> count({required AppUser user});

  ///------Water Preferences Section----///

  FutureEither<WaterPreferences> getWaterPreferences({
    AppUser? user,
    bool? getFromRemote,
    DateTime? start,
    DateTime? end,
  });

  FutureEither<void> addPreferences({
    required WaterPreferences preferences,
    required AppUser? user,
    bool? updateRemote = false,
  });

  FutureEither<void> updatePreferences({
    required WaterPreferences preferences,
    required AppUser user,
    bool updateRemote = false,
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
          log("No Logs found from Remote");
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
      log("Log data doesn't exist from Remote", name: "WATER REPOSITORY");
      return [];
      // throw Exception("Log data doesn't exist");
    }
  }

  @override
  FutureEither<void> addWaterLog({
    required WaterLog log,
    required AppUser user,
    bool updateRemote = false,
  }) async {
    return futureHandler(() async {
      _waterLocalService.addWaterLog(log);
      if (updateRemote) {
        await _waterService.addLog(waterLog: log, uid: user.uid);
      }
    });
  }

  @override
  FutureEither<void> updateWaterLog({
    required WaterLog log,
    required AppUser user,
    bool updateRemote = false,
  }) async {
    return futureHandler(() async {
      _waterLocalService.update(log);
      if (updateRemote) {
        await _waterService.updateLog(waterLog: log, uid: user.uid);
      }
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
  FutureEither<void> clear({
    required AppUser user,
    bool updateRemote = false,
  }) async {
    return futureHandler(() async {
      _waterLocalService.clear();
      if (updateRemote) {
        await _waterService.clear(uid: user.uid);
      }
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

      ///Get from Remote when instructed
      if (user != null && getFromRemote != null && getFromRemote) {
        preferences = await _getRemotePreferences(user.uid);
        if (preferences.isNotEmpty) {
          //If Not empty, return, else get from local
          return preferences;
        } else {
          throw Exception("No Preferences found");
        }
      }

      preferences = _waterLocalService.getPreferences();

      if (preferences.isEmpty) {
        throw Exception("No Preferences found found");
      }
      return preferences;
    });
  }

  Future<WaterPreferences> _getRemotePreferences(String uid) async {
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await _waterService.getPreferences(uid);

    if (documentSnapshot.exists &&
        documentSnapshot.data() != null &&
        documentSnapshot.data()!.isNotEmpty) {
      Map<String, dynamic>? data = documentSnapshot.data();
      WaterPreferences preferences = WaterPreferences.fromMap(data!);

      return preferences;
    } else {
      throw Exception("Preferences doesn't exist");
    }
  }

  @override
  FutureEither<void> addPreferences({
    required WaterPreferences preferences,
    required AppUser? user,
    bool? updateRemote = false,
  }) async {
    return futureHandler(() async {
      _waterLocalService.addPreferences(preferences);
      if (updateRemote! && user != null) {
        await _waterService.addPreferences(
          preferences: preferences,
          uid: user.uid,
        );
      }
    });
  }

  @override
  FutureEither<void> updatePreferences({
    required WaterPreferences preferences,
    required AppUser user,
    bool updateRemote = false,
  }) async {
    return futureHandler(() async {
      _waterLocalService.updatePreferences(preferences);
      if (updateRemote) {
        await _waterService.updatePreferences(
          preferences: preferences,
          uid: user.uid,
        );
      }
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
