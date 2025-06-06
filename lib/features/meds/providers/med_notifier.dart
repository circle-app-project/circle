import 'dart:developer';

import 'package:circle/features/auth/auth.dart';
import 'package:circle/features/meds/repositories/med_repository.dart';
import 'package:circle/features/meds/services/local/med_local_service.dart';
import 'package:circle/features/meds/services/remote/med_service.dart';
import 'package:circle/main.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/error/failure.dart';
import '../models/medication.dart';
part 'med_notifier.g.dart';

///Todo: Consider adding a medication tags feature to easily filter
///Tags should be user defined, and customisable, with customisable colors
///Tags can be used as filters eg "with food" should filter only medications that need to tbe taken with food
///Each medication can have multiple tags
///
final MedService medService = MedService();
final MedLocalService medLocalService = MedLocalService(store: database.store);
final MedRepository medRepository = MedRepositoryImpl(
  medService: medService,
  medLocalService: medLocalService,
);

final MedNotifierProvider medNotifierProviderImpl = MedNotifierProvider(
  medRepository: medRepository,
);

@Riverpod(keepAlive: true)
class MedNotifier extends _$MedNotifier {
  late final MedRepository _medRepository;
  late final AppUser? selfUser;

  @override
  FutureOr<List<Medication>> build({
    required MedRepository medRepository,
  }) async {
    _medRepository = medRepository;
    selfUser = ref.watch(userNotifierProviderImpl).value;
    return [];
  }

  // /////// C R U D  O P E R A T I O N S ///////
  Future<void> getMedications({bool forceRefresh = false}) async {
    log("Getting All Medications", name: "Med Notifier");
    state = const AsyncValue.loading();
    final Either<Failure, List<Medication>> response = await _medRepository
        .getAllMedications(user: selfUser!);
    response.fold(
      (failure) {
        state = AsyncValue.error(failure, failure.stackTrace!);
        log(
          "Failed: $failure, Message:${failure.message}, Code: ${failure.code}",
          name: "Med Notifier",
          stackTrace: failure.stackTrace,
        );
      },
      (medications) {
        state = AsyncValue.data(medications);
        log("Success ${state.value}", name: "Med Notifier");
      },
    );
  }

  Future<void> putMedication({
    bool forceRefresh = false,
    required Medication medication,
    AppUser? user,
  }) async {
    log("Putting or Updating Medication", name: "Med Notifier");
    state = const AsyncValue.loading();
    final Either<Failure, Medication> response = await _medRepository
        .putMedication(
          med: medication,
          updateRemote: forceRefresh,
          user: user ?? selfUser!,
        );
    response.fold(
      (failure) {
        state = AsyncValue.error(failure, failure.stackTrace!);
        log(
          "Failed: $failure, Message:${failure.message}, Code: ${failure.code}",
          name: "Med Notifier",
          stackTrace: failure.stackTrace,
        );
      },
      (medication) async {
        log("Success ${state.value}", name: "Med Notifier");
        await getMedications();
      },
    );
  }

  Future<void> deleteMedication({
    bool forceRefresh = false,
    required Medication medication,
    AppUser? user,
  }) async {
    log("Deleting Medication", name: "Med Notifier");
    state = const AsyncValue.loading();
    final Either<Failure, void> response = await _medRepository
        .deleteMedication(
          med: medication,
          updateRemote: forceRefresh,
          user: user ?? selfUser!,
        );
    response.fold(
      (failure) {
        state = AsyncValue.error(failure, failure.stackTrace!);
        log(
          "Failed: $failure, Message:${failure.message}, Code: ${failure.code}",
          name: "Med Notifier",
          stackTrace: failure.stackTrace,
        );
      },
      (empty) async {
        log("Success ${state.value}", name: "Med Notifier");
        await getMedications();
      },
    );
  }

  Future<void> clearMedications({
    bool forceRefresh = false,
    AppUser? user,
  }) async {
    log("Clearing Medications", name: "Med Notifier");
    state = const AsyncValue.loading();
    final Either<Failure, void> response = await _medRepository
        .clearMedications(updateRemote: forceRefresh, user: user ?? selfUser!);
    response.fold(
      (failure) {
        state = AsyncValue.error(failure, failure.stackTrace!);
        log(
          "Failed: $failure, Message:${failure.message}, Code: ${failure.code}",
          name: "Med Notifier",
          stackTrace: failure.stackTrace,
        );
      },
      (empty) async {
        state = const AsyncValue.data([]);
        log("Success ${state.value}", name: "Med Notifier");
      },
    );
  }

  //// Todo: METHODS TO IMPLEMENT

  /// Todo: Marks as Completed ✅
  /// Todo: Marks as Missed ✅
  /// Todo: Mark as skipped ✅
  ///
  /// Todo: Get upcoming doses {
  /// this should create a list of upcoming doses for medications that are due, so it means a medication with 2 doses in a day should appear 2 times
  /// And a notification should be sent for each dose
  /// } ✅
  /// Todo: schedule notifications for each medication at each dose
  /// Todo: get next due medication dose ✅
  /// Todo: schedule medication doses notifications
  /// Todo: get adherenceRate within a start date
  ///
  /// ///I think this should be moved to a streak specific med provider
  /// Which means a streak class that takes an activity record object with some methods
  /// Todo: Get current streak (counts the number of days) ✅
  /// Todo: is taken on Time (compare completion time with scheduled time +- some interval minutes)
  /// Todo: get streak stats ✅
  /// Todo: analyze patterns
  ///
  ///
}
