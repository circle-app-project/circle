import 'dart:developer';

import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/core.dart';
import '../../auth/auth.dart';
import '../water.dart';

part 'water_prefs_notifier.g.dart';

final WaterPrefsNotifierProvider waterPrefsNotifierProviderImpl =
    waterPrefsNotifierProvider(waterRepository: waterRepository);

@Riverpod(keepAlive: true)
class WaterPrefsNotifier extends _$WaterPrefsNotifier {
  late final WaterRepository _waterRepository;

  @override
  FutureOr<WaterPreferences> build({
    required WaterRepository waterRepository,
  }) async {
    _waterRepository = waterRepository;
    return WaterPreferences.empty;
  }

  /// Water Preferences
  Future<void> getWaterPreferences({AppUser? user, bool? getFromRemote}) async {
    log("Getting water preferences", name: "Water Preferences Notifier");

    state = const AsyncValue.loading();
    final Either<Failure, WaterPreferences> response = await _waterRepository
        .getWaterPreferences(user: user, getFromRemote: getFromRemote);
    response.fold(
      (failure) {
        log(
          "Failed: $failure, Message:${failure.message}, Code: ${failure.code}",
          name: "Water Preferences Notifier",
          stackTrace: failure.stackTrace,
        );
        state = AsyncValue.error(failure, failure.stackTrace!);
      },
      (prefs) {
        log("Success ${state.value}", name: "Water Preferences Notifier");
        state = AsyncValue.data(prefs);
      },
    );
  }

  Future<void> putWaterPreferences({
    required WaterPreferences preferences,
    AppUser? user,
    bool updateRemote = false,
  }) async {
    log("Putting water preferences", name: "Water Preferences Notifier");

    state = const AsyncValue.loading();
    final Either<Failure, WaterPreferences> response = await _waterRepository
        .putPreferences(
          preferences: preferences,
          user: user,
          updateRemote: updateRemote,
        );
    response.fold(
      (failure) {
        log(
          "Failed: $failure, Message:${failure.message}, Code: ${failure.code}",
          name: "Water Preferences Notifier",
          stackTrace: failure.stackTrace,
        );
        state = AsyncValue.error(failure, failure.stackTrace!);
      },
      (prefs) async {
        log("Success ${state.value}", name: "Water Preferences Notifier");
        state = AsyncValue.data(prefs);
      },
    );
  }

  Future<void> deleteWaterPreferences({
    required WaterPreferences preferences,
    required AppUser user,
    bool updateRemote = false,
  }) async {
    log("Deleting water preferences", name: "Water Preferences Notifier");

    state = const AsyncValue.loading();
    final Either<Failure, void> response = await _waterRepository
        .deletePreferences(user: user, updateRemote: updateRemote);
    response.fold(
      (failure) {
        log(
          "Failed: $failure, Message:${failure.message}, Code: ${failure.code}",
          name: "Water Preferences Notifier",
          stackTrace: failure.stackTrace,
        );
        state = AsyncValue.error(failure, failure.stackTrace!);
      },
      (empty) async {
        log("Success ${state.value}", name: "Water Preferences Notifier");
        state = AsyncValue.data(WaterPreferences.empty);
      },
    );
  }
}
