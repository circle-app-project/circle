import '../../../../databse_service.dart';
import '../../water.dart';

class WaterLocalService extends LocalDbService {
  WaterLocalService();

  ///----Water Logs ----///
  Future<List<WaterLog>> getWaterLogs({DateTime? start, DateTime? end}) async {
    ///Todo: Implement
    throw UnimplementedError();
  }

  Future<void> addWaterLog(WaterLog log) async {
    ///Todo: Implement
    throw UnimplementedError();
  }

  Future<void> update(WaterLog log) async {
    ///Todo: Implement
    throw UnimplementedError();
  }

  Future<void> deleteWaterLog(WaterLog log) async {
    ///Todo: Implement
    throw UnimplementedError();
  }

  Future<void> clear() async {
    ///Todo: Implement
    throw UnimplementedError();
  }

  Future<int> count() async {
    ///Todo: Implement
    throw UnimplementedError();
  }

  /// ----- Water Preferences Section ----- ///

  Future<WaterPreferences> getPreferences() async {
    ///Todo: Implement
    throw UnimplementedError();
  }

  Future<void> addPreferences(WaterPreferences preferences) async {
    ///Todo: Implement
    throw UnimplementedError();
  }

  Future<void> updatePreferences(WaterPreferences preferences) async {
    ///Todo: Implement
    throw UnimplementedError();
  }

  Future<void> deletePreferences() async {
    ///Todo: Implement
    throw UnimplementedError();
  }
}
