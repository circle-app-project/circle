import 'dart:developer';

import 'package:circle/features/auth/auth.dart';
import 'package:circle/features/meds/repositories/med_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/error/failure.dart';
import '../models/activity_record.dart';
import '../models/med_schedule.dart';
import 'med_notifier.dart';
part 'med_schedule_notifier.g.dart';

final MedScheduleNotifierProvider medScheduleNotifierProviderImpl =
    MedScheduleNotifierProvider(medRepository: medRepository);

@Riverpod(keepAlive: true)
class MedScheduleNotifier extends _$MedScheduleNotifier {
  late final MedRepository _medRepository;
  late final AppUser? selfUser;

  List<MedSchedule> _allDoses = [];
  List<MedSchedule> _upcomingDosesForToday = [];
  List<MedSchedule> _allDosesForToday = [];
  List<MedSchedule> _pastDosesForToday = [];

  List<MedSchedule> get upcomingDosesForToday => _upcomingDosesForToday;

  List<MedSchedule> get allDosesForToday => _allDosesForToday;

  List<MedSchedule> get pastDosesForToday => _pastDosesForToday;
  List<MedSchedule> get allDoses => _allDoses;

  @override
  FutureOr<List<MedSchedule>> build({
    required MedRepository medRepository,
  }) async {
    _medRepository = medRepository;
    selfUser = ref.watch(userNotifierProviderImpl).value;

    return [];
  }

  // /////// C R U D  O P E R A T I O N S ///////
  Future<List<MedSchedule>> getMedicationsSchedules({
    bool forceRefresh = false,
    DateTime? from,
    DateTime? until,
  }) async {
    log("Getting All Medication Schedules", name: "Med Schedule Notifier");
    state = const AsyncValue.loading();
    final Either<Failure, List<MedSchedule>> response = await _medRepository
        .getMedicationSchedules(from: from, until: until);
    response.fold(
      (failure) {
        state = AsyncValue.error(failure, failure.stackTrace!);
        log(
          "Failed: $failure, Message:${failure.message}, Code: ${failure.code}",
          name: "Med Schedule Notifier",
          stackTrace: failure.stackTrace,
        );
      },
      (schedules) {
        state = AsyncValue.data(schedules);
        _allDoses = schedules;
        log("Success ${state.value}", name: "Med Schedule Notifier");
        return schedules;
      },
    );
    return [];
  }



  Future<void> putMedicationSchedules({
    bool forceRefresh = false,
    required List<MedSchedule> schedules,
  }) async {
    log("Putting or Updating Medication", name: "Med Schedule Notifier");
    state = const AsyncValue.loading();
    final Either<Failure, List<MedSchedule>> response = await _medRepository
        .putAndGetMedicationSchedules(schedules: schedules);
    response.fold(
      (failure) {
        state = AsyncValue.error(failure, failure.stackTrace!);
        log(
          "Failed: $failure, Message:${failure.message}, Code: ${failure.code}",
          name: "Med Schedule Notifier",
          stackTrace: failure.stackTrace,
        );
      },
      (medication) async {
        log("Success ${state.value}", name: "Med Schedule Notifier");
        await getMedicationsSchedules();
      },
    );
  }

  Future<void> deleteMedicationSchedules({
    bool forceRefresh = false,
    required List<MedSchedule> schedules,
  }) async {
    log("Putting or Updating Medication", name: "Med Schedule Notifier");
    state = const AsyncValue.loading();
    final Either<Failure, void> response = await _medRepository
        .deleteMedicationSchedules(schedules: schedules);
    response.fold(
      (failure) {
        state = AsyncValue.error(failure, failure.stackTrace!);
        log(
          "Failed: $failure, Message:${failure.message}, Code: ${failure.code}",
          name: "Med Schedule Notifier",
          stackTrace: failure.stackTrace,
        );
      },
      (medication) async {
        log("Success ${state.value}", name: "Med Schedule Notifier");
        await getMedicationsSchedules();
      },
    );
  }

  Future<MedSchedule?> markDoseAsSkipped({
    bool forceRefresh = false,
    required MedSchedule medSchedule,
    String? note,
    String? skipReason,
  }) async {
    medSchedule = medSchedule.copyWith(
      status: CompletionsStatus.skipped,
      note: note,
      skipReason: skipReason,
      updatedAt: DateTime.now(),
    );

    log("Marking dose as Skipped", name: "Med Schedule Notifier");
    state = const AsyncValue.loading();
    final Either<Failure, MedSchedule> response = await _medRepository
        .putAndGetMedicationSchedule(schedule: medSchedule);
    response.fold(
      (failure) {
        state = AsyncValue.error(failure, failure.stackTrace!);
        log(
          "Failed: $failure, Message:${failure.message}, Code: ${failure.code}",
          name: "Med Schedule Notifier",
          stackTrace: failure.stackTrace,
        );
      },
      (schedule) async {
        log("Success ${state.value}", name: "Med Schedule Notifier");
        await getMedicationsSchedules();
        return schedule;
      },
    );
    return null;
  }

  Future<MedSchedule?> markDoseAsCompleted({
    bool forceRefresh = false,
    required MedSchedule medSchedule,
    String? note,
  }) async {
    medSchedule = medSchedule.copyWith(
      status: CompletionsStatus.completed,
      note: note,
      updatedAt: DateTime.now(),
    );

    log("Marking dose as completed", name: "Med Schedule Notifier");
    state = const AsyncValue.loading();
    final Either<Failure, MedSchedule> response = await _medRepository
        .putAndGetMedicationSchedule(schedule: medSchedule);
    response.fold(
      (failure) {
        state = AsyncValue.error(failure, failure.stackTrace!);
        log(
          "Failed: $failure, Message:${failure.message}, Code: ${failure.code}",
          name: "Med Schedule Notifier",
          stackTrace: failure.stackTrace,
        );
      },
      (schedule) async {
        log("Success ${state.value}", name: "Med Schedule Notifier");
        await getMedicationsSchedules();
        return schedule;
      },
    );
    return null;
  }

  Future<MedSchedule?> markDoseAsMissed({
    bool forceRefresh = false,
    required MedSchedule medSchedule,
    String? note,
  }) async {
    medSchedule = medSchedule.copyWith(
      status: CompletionsStatus.missed,
      note: note,
      updatedAt: DateTime.now(),
    );

    log("Marking dose as missed", name: "Med Schedule Notifier");
    state = const AsyncValue.loading();
    final Either<Failure, MedSchedule> response = await _medRepository
        .putAndGetMedicationSchedule(schedule: medSchedule);
    response.fold(
      (failure) {
        state = AsyncValue.error(failure, failure.stackTrace!);
        log(
          "Failed: $failure, Message:${failure.message}, Code: ${failure.code}",
          name: "Med Schedule Notifier",
          stackTrace: failure.stackTrace,
        );
      },
      (schedule) async {
        log("Success ${state.value}", name: "Med Schedule Notifier");
        await getMedicationsSchedules();
        return schedule;
      },
    );
    return null;
  }

  Future<List<MedSchedule>> calculateDosesForToday() async {
    log(
      "Getting all medication doses for the day",
      name: "Med Schedule Notifier",
    );

    final DateTime now = DateTime.now();
    final DateTime today = now.copyWith(hour: 0, minute: 0);
    final DateTime tomorrow = today.add(const Duration(days: 1));

    _allDosesForToday = await getMedicationsSchedulesForTimePeriod(
      from: today,
      until: tomorrow,
    );

    /// Get the medications that should be taken today
    if (_allDosesForToday.isNotEmpty) {
      _upcomingDosesForToday =
          _allDosesForToday.filter((dose) => dose.date.isAfter(now)).toList();
      _pastDosesForToday =
          _allDosesForToday.filter((dose) => dose.date.isBefore(now)).toList();
      _allDosesForToday = allDoses;
    }

    /// Sorts the doses by schedule time
    _upcomingDosesForToday.sort((a, b) => a.date.compareTo(b.date));
    _allDosesForToday.sort((a, b) => a.date.compareTo(b.date));
    _pastDosesForToday.sort((a, b) => a.date.compareTo(b.date));
    return _allDosesForToday;
  }

  Future<List<MedSchedule>> getMedicationsSchedulesForTimePeriod({
    required DateTime from,
    required DateTime until,
  }) async {
    log("Getting Medication Schedules for time period", name: "Med Schedule Notifier");
    state = const AsyncValue.loading();
    final Either<Failure, List<MedSchedule>> response = await _medRepository
        .getMedicationSchedules(from: from, until: until);
    response.fold(
          (failure) {
        state = AsyncValue.error(failure, failure.stackTrace!);
        log(
          "Failed: $failure, Message:${failure.message}, Code: ${failure.code}",
          name: "Med Schedule Notifier",
          stackTrace: failure.stackTrace,
        );
        return [];
      },
          (schedules) {
        state = AsyncValue.data(state.value ?? []);
        log("Success ${state.value}", name: "Med Schedule Notifier");
        return schedules;
      },
    );
    return [];
  }

}
