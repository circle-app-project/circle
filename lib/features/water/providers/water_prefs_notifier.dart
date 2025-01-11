import 'dart:developer';

import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/core.dart';
import '../../auth/auth.dart';
import '../water.dart';

part 'water_prefs_notifier.g.dart';



final WaterPrefsNotifierProvider waterPrefsNotifierProviderImpl = waterPrefsNotifierProvider(
  waterRepository:waterRepository
);


@Riverpod(keepAlive: true)
class WaterPrefsNotifier extends _$WaterPrefsNotifier{
  late final WaterRepository _waterRepository;


  WaterPreferences _preferences = WaterPreferences.initial();
  WaterPreferences get preferences => _preferences;

  @override
  FutureOr<WaterPreferences> build({required WaterRepository waterRepository}) async {
    _waterRepository = waterRepository;
    return WaterPreferences.empty;
  }

  /// Water Preferences
  Future<void> getWaterPreferences(
      {AppUser? user, bool? getFromRemote}) async {
    state = const AsyncValue.loading();
    final Either<Failure, WaterPreferences> response = await _waterRepository
        .getWaterPreferences(user: user, getFromRemote: getFromRemote);
    response.fold((failure) {
      log("RETURNED FAILURE");
      state = AsyncValue.error(failure, failure.stackTrace ?? StackTrace.current);
    }, (prefs) {
      log("RETURNED SUCCESS");
      _preferences = prefs;
      //Just add the old state of water logs to trigger an update
      state = AsyncValue.data(state.value!);
    });
  }

  Future<void> addWaterPreferences(
      {required WaterPreferences preferences,
      AppUser? user,
      bool updateRemote = false}) async {
    state = const AsyncValue.loading();
    final Either<Failure, void> response =
        await _waterRepository.addPreferences(
            preferences: preferences, user: user, updateRemote: updateRemote);
    response.fold((failure) {
      log("RETURNED FAILURE");
      state = AsyncValue.error(failure, failure.stackTrace ?? StackTrace.current);
    }, (empty) async {
      log("RETURNED SUCCESS");
      await getWaterPreferences();
    });
  }

  Future<void> updateWaterPreferences({
    required WaterPreferences preferences,
    required AppUser user,
    bool updateRemote = false,
  }) async {
    state = const AsyncValue.loading();
    final Either<Failure, void> response =
        await _waterRepository.updatePreferences(
            preferences: preferences, user: user, updateRemote: updateRemote);
    response.fold((failure) {
      log("RETURNED FAILURE");
      state = AsyncValue.error(failure, failure.stackTrace ?? StackTrace.current);
    }, (empty) async {
      log("RETURNED SUCCESS");
      await getWaterPreferences();
    });
  }

  Future<void> deleteWaterPreferences({
    required WaterPreferences preferences,
    required AppUser user,
    bool updateRemote = false,
  }) async {
    state = const AsyncValue.loading();
    final Either<Failure, void> response = await _waterRepository
        .deletePreferences(user: user, updateRemote: updateRemote);
    response.fold((failure) {
      log("RETURNED FAILURE");
      state = AsyncValue.error(failure, failure.stackTrace ?? StackTrace.current);
    }, (empty) async {
      log("RETURNED SUCCESS");
      await getWaterPreferences();
    });
  }
}
