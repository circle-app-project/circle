import '../../../../objectbox.g.dart';
import '../../water.dart';

class WaterLocalService {
  late final Box<WaterLog> waterLogBox;
  late final Box<WaterPreferences> waterPreferencesBox;

  WaterLocalService({required Store store})
      : waterLogBox = store.box<WaterLog>(),
        waterPreferencesBox = store.box<WaterPreferences>();

  ///----Water Logs ----///
  Future<List<WaterLog>> getWaterLogs({DateTime? start, DateTime? end}) async {
    List<WaterLog> logs = [];
    Query query;
    if (start != null && end != null) {
      query = waterLogBox
          .query(WaterLog_.timestamp.betweenDate(start, end))
          .build();
      logs = query.find() as List<WaterLog>;
      query.close();
    }

    if (start != null && end == null) {
      query = waterLogBox
          .query(WaterLog_.timestamp.greaterOrEqualDate(start))
          .build();
      logs = query.find() as List<WaterLog>;
      query.close();
    }

    if (end != null && start == null) {
      query =
          waterLogBox.query(WaterLog_.timestamp.lessOrEqualDate(end)).build();
      logs = query.find() as List<WaterLog>;
      query.close();
    }

    if (start == null && end == null) {
      logs = waterLogBox.getAll();
    }

    logs.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return logs;
  }

  void addWaterLog(WaterLog log) {
    waterLogBox.put(log);
  }

  void update(WaterLog log) {
    waterLogBox.put(log, mode: PutMode.update);
  }

  void deleteWaterLog(WaterLog log) {
    bool isDeleted = waterLogBox.remove(log.id);

    if (!isDeleted) {
      throw Exception("Failed to delete log");
    }
  }

  void clear() {
    waterLogBox.removeAll();
  }

  int count() {
    return waterLogBox.count();
  }

  /// ----- Water Preferences Section ----- ///

  WaterPreferences getPreferences() {
    return waterPreferencesBox.getAll().first;
  }

  void addPreferences(WaterPreferences preferences) {
    waterPreferencesBox.put(preferences);
  }

  void updatePreferences(WaterPreferences preferences) {
    waterPreferencesBox.put(preferences, mode: PutMode.update);
  }

  void deletePreferences() {
    waterPreferencesBox.removeAll();
  }
}
