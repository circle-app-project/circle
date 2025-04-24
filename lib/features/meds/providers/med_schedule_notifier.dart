import 'dart:developer';

import 'package:circle/features/auth/auth.dart';
import 'package:circle/features/meds/repositories/med_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/error/failure.dart';
import '../models/activity_record.dart';
import '../models/scheduled_doses.dart';
import 'med_notifier.dart';
part 'med_schedule_notifier.g.dart';

final MedScheduledDosesNotifierProvider medScheduleNotifierProviderImpl =
    MedScheduledDosesNotifierProvider(medRepository: medRepository);

@Riverpod(keepAlive: true)
class MedScheduledDosesNotifier extends _$MedScheduleNotifier {
  late final MedRepository _medRepository;
  late final AppUser? selfUser;

  List<ScheduledDose> _allDoses = [];
  List<ScheduledDose> _upcomingDosesForToday = [];
  List<ScheduledDose> _allDosesForToday = [];
  List<ScheduledDose> _pastDosesForToday = [];

  List<ScheduledDose> get upcomingDosesForToday => _upcomingDosesForToday;
  List<ScheduledDose> get allDosesForToday => _allDosesForToday;
  List<ScheduledDose> get pastDosesForToday => _pastDosesForToday;
  List<ScheduledDose> get allDoses => _allDoses;

  @override
  FutureOr<List<ScheduledDose>> build({
    required MedRepository medRepository,
  }) async {
    _medRepository = medRepository;
    selfUser = ref.watch(userNotifierProviderImpl).value;

    return [];
  }

  // /////// C R U D  O P E R A T I O N S ///////
  Future<List<ScheduledDose>> getMedScheduledDoses({
    bool forceRefresh = false,
    DateTime? from,
    DateTime? until,
  }) async {
    log("Getting All Medication Schedules", name: "Med Schedule Notifier");
    state = const AsyncValue.loading();
    final Either<Failure, List<ScheduledDose>> response = await _medRepository
        .getMedScheduledDoses(from: from, until: until);

    List<ScheduledDose> gottenDoses = [];
    response.fold(
      (failure) {
        state = AsyncValue.error(failure, failure.stackTrace!);
        log(
          "Failed: $failure, Message:${failure.message}, Code: ${failure.code}",
          name: "Med Schedule Notifier",
          stackTrace: failure.stackTrace,
        );
      },
      (doses) {
        state = AsyncValue.data(doses);
        _allDoses = doses;
        gottenDoses = doses;
        log("Success ${state.value}", name: "Med Schedule Notifier");
      },
    );
    return gottenDoses;
  }

  Future<void> putMedScheduledDoses({
    bool forceRefresh = false,
    required List<ScheduledDose> schedules,
  }) async {
    log("Putting or Updating Medication", name: "Med Schedule Notifier");
    state = const AsyncValue.loading();
    final Either<Failure, List<ScheduledDose>> response = await _medRepository
        .putAndGetMedScheduledDoses(schedules: schedules);
    response.fold(
      (failure) {
        state = AsyncValue.error(failure, failure.stackTrace!);
        log(
          "Failed: $failure, Message:${failure.message}, Code: ${failure.code}",
          name: "Med Schedule Notifier",
          stackTrace: failure.stackTrace,
        );
      },
      (doses) async {
        log("Success", name: "Med Schedule Notifier");
        await getMedScheduledDoses();
      },
    );
  }

  Future<void> deleteMedScheduledDoses({
    bool forceRefresh = false,
    required List<ScheduledDose> schedules,
  }) async {
    log("Putting or Updating Medication", name: "Med Schedule Notifier");
    state = const AsyncValue.loading();
    final Either<Failure, void> response = await _medRepository
        .deleteMedScheduledDoses(schedules: schedules);
    response.fold(
      (failure) {
        state = AsyncValue.error(failure, failure.stackTrace!);
        log(
          "Failed: $failure, Message:${failure.message}, Code: ${failure.code}",
          name: "Med Schedule Notifier",
          stackTrace: failure.stackTrace,
        );
      },
      (empty) async {
        log("Success ${state.value}", name: "Med Schedule Notifier");
        await getMedScheduledDoses();
      },
    );
  }

  Future<ScheduledDose?> markDoseAsSkipped({
    bool forceRefresh = false,
    required ScheduledDose dose,
    String? note,
    String? skipReason,
  }) async {
    dose = dose.copyWith(
      status: CompletionsStatus.skipped,
      note: note,
      skipReason: skipReason,
      updatedAt: DateTime.now(),
    );

    ScheduledDose? scheduleDose;

    log("Marking dose as Skipped", name: "Med Schedule Notifier");
    state = const AsyncValue.loading();
    final Either<Failure, ScheduledDose> response = await _medRepository
        .putAndGetMedScheduledDose(schedule: dose);
    response.fold(
      (failure) {
        state = AsyncValue.error(failure, failure.stackTrace!);
        log(
          "Failed: $failure, Message:${failure.message}, Code: ${failure.code}",
          name: "Med Schedule Notifier",
          stackTrace: failure.stackTrace,
        );
      },
      (dose) async {
        log("Success ${state.value}", name: "Med Schedule Notifier");
        await getMedScheduledDoses();
        scheduleDose = dose;
      },
    );
    return scheduleDose;
  }

  Future<ScheduledDose?> markDoseAsCompleted({
    bool forceRefresh = false,
    required ScheduledDose dose,
    String? note,
  }) async {
    dose = dose.copyWith(
      status: CompletionsStatus.completed,
      note: note,
      updatedAt: DateTime.now(),
    );

    ScheduledDose? scheduleDose;

    log("Marking dose as completed", name: "Med Schedule Notifier");
    state = const AsyncValue.loading();
    final Either<Failure, ScheduledDose> response = await _medRepository
        .putAndGetMedScheduledDose(schedule: dose);
    response.fold(
      (failure) {
        state = AsyncValue.error(failure, failure.stackTrace!);
        log(
          "Failed: $failure, Message:${failure.message}, Code: ${failure.code}",
          name: "Med Schedule Notifier",
          stackTrace: failure.stackTrace,
        );
      },
      (medSchedule) async {
        log("Success ${state.value}", name: "Med Schedule Notifier");
        scheduleDose = medSchedule;
        await getMedScheduledDoses();
      },
    );
    return scheduleDose;
  }

  Future<ScheduledDose?> markDoseAsMissed({
    bool forceRefresh = false,
    required ScheduledDose dose,
    String? note,
  }) async {
    dose = dose.copyWith(
      status: CompletionsStatus.missed,
      note: note,
      updatedAt: DateTime.now(),
    );

    log("Marking dose as missed", name: "Med Schedule Notifier");
    state = const AsyncValue.loading();
    final Either<Failure, ScheduledDose> response = await _medRepository
        .putAndGetMedScheduledDose(schedule: dose);

    ScheduledDose? schedule;


    response.fold(
      (failure) {
        state = AsyncValue.error(failure, failure.stackTrace!);
        log(
          "Failed: $failure, Message:${failure.message}, Code: ${failure.code}",
          name: "Med Schedule Notifier",
          stackTrace: failure.stackTrace,
        );
      },
      (medSched) async {
        log("Success ${state.value}", name: "Med Schedule Notifier");
        schedule = medSched;
        await getMedScheduledDoses();
      },
    );
    return schedule;
  }

  Future<List<ScheduledDose>> calculateDosesForToday() async {
    log(
      "Getting all medication doses for the day",
      name: "Med Schedule Notifier",
    );

    final DateTime now = DateTime.now();
    final DateTime today = now.copyWith(hour: 0, minute: 0);
    final DateTime tomorrow = today.add(const Duration(days: 1));

   // _allDosesForToday.clear();

    _allDosesForToday = await getMedScheduledDosesForTimePeriod(
      from: today,
      until: tomorrow,
    );


    /// Get the medications that should be taken today
    if (_allDosesForToday.isNotEmpty) {
      _upcomingDosesForToday =
          _allDosesForToday.filter((dose) => dose.date.isAfter(now) && dose.status!=CompletionsStatus.completed).toList();
      _pastDosesForToday =
          _allDosesForToday.filter((dose) => dose.date.isBefore(now) || dose.status==CompletionsStatus.completed).toList();
    }

    /// Sorts the doses by schedule time
    _upcomingDosesForToday.sort((a, b) => a.date.compareTo(b.date));
    _allDosesForToday.sort((a, b) => a.date.compareTo(b.date));
    _pastDosesForToday.sort((a, b) => a.date.compareTo(b.date));

    state = AsyncValue.data(state.value ?? []);
    return _allDosesForToday;
  }

  Future<List<ScheduledDose>> getMedScheduledDosesForTimePeriod({
    required DateTime from,
    required DateTime until,
  }) async {
    log(
      "Getting Medication Schedules for time period",
      name: "Med Schedule Notifier",
    );
    state = const AsyncValue.loading();
    final Either<Failure, List<ScheduledDose>> response = await _medRepository
        .getMedScheduledDoses(from: from, until: until);

    List<ScheduledDose> doses = [];
    response.fold(
      (failure) {
        state = AsyncValue.error(failure, failure.stackTrace!);
        log(
          "Failed: $failure, Message:${failure.message}, Code: ${failure.code}",
          name: "Med Schedule Notifier",
          stackTrace: failure.stackTrace,
        );
      },
      (medSchedules) {
        state = AsyncValue.data(state.value ?? []);
        doses = medSchedules;
        log("Success", name: "Med Schedule Notifier");
      },
    );

    return doses;
  }
}
