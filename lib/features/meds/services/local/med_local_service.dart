import 'dart:developer';

import 'package:circle/features/meds/models/medication.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../objectbox.g.dart';
import '../../models/med_activity_record.dart';
import '../../models/scheduled_doses.dart';

class MedLocalService {
  late final Box<Medication> _medBox;
  late final Box<MedActivityRecord> _medActivityBox;
  late final Box<ScheduledDose> _scheduledDosesBox;
  MedLocalService({required Store store})
    : _medBox = store.box<Medication>(),
      _medActivityBox = store.box<MedActivityRecord>(),
      _scheduledDosesBox = store.box<ScheduledDose>();

  Stream<List<Medication>> listenMedication() async* {
    yield* _medBox
        .query()
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }

  List<Medication> getAllMedications() {
    try {
      List<Medication> medications = _medBox.getAll();
      return medications.isNotEmpty ? medications : [];
    } catch (e, stack) {
      // Throws app exception
      log(
        "Failed to get all medications",
        error: e,
        stackTrace: stack,
        name: "Medication Local Service",
      );
      throw AppException(
        message: "Failed to get all medications",
        debugMessage: e.toString(),
        stackTrace: stack,
        type: ExceptionType.localStorage,
      );
    }
  }

  Medication getMedication({required int id}) {
    try {
      Medication? medication = _medBox.get(id);
      return medication ?? Medication.empty;
    } catch (e, stack) {
      // Throws app exception
      log(
        "Failed to get medication",
        error: e,
        stackTrace: stack,
        name: "Medication Local Service",
      );
      throw AppException(
        message: "Failed to get medication",
        debugMessage: e.toString(),
        stackTrace: stack,
        type: ExceptionType.localStorage,
      );
    }
  }

  List<Medication> getMedicationByName({required String name}) {
    late final Query query;
    try {
      query = _medBox.query(Medication_.name.contains(name)).build();
      List<Medication> medications = query.find() as List<Medication>;
      return medications;
    } catch (e, stack) {
      log(
        "Failed to get medication by name",
        error: e,
        stackTrace: stack,
        name: "Medication Local Service",
      );
      throw AppException(
        message: "Failed to get medication by name",
        debugMessage: e.toString(),
        stackTrace: stack,
        type: ExceptionType.localStorage,
      );
    } finally {
      query.close();
    }
  }

  Future<Medication> putAndGetMedication(Medication medication) async {
    try {
      /// Save Relations
      if (medication.activityRecord.isNotEmpty) {
        _medActivityBox.putMany(medication.activityRecord);
      }
      return await _medBox.putAndGetAsync(
        medication,
        mode: medication.id == 0 ? PutMode.put : PutMode.update,
      );
    } catch (e, stackTrace) {
      // Throws app exception
      log(
        "Failed to put and get medication",
        error: e,
        stackTrace: stackTrace,
        name: "Medication Local Service",
      );
      throw AppException(
        message: "Failed to put and get medication",
        debugMessage: e.toString(),
        stackTrace: stackTrace,
        type: ExceptionType.localStorage,
      );
    }
  }

  void deleteMedication(Medication medication) {
    try {
      _medActivityBox.removeMany(
        medication.activityRecord.map((e) => e.id).toList(),
      );
      _medBox.remove(medication.id);
    } catch (e, stackTrace) {
      /// Log and throw app exception
      log(
        "Failed to delete medication",
        error: e,
        stackTrace: stackTrace,
        name: "Medication Local Service",
      );
      throw AppException(
        message: "Failed to delete medication",
        debugMessage: e.toString(),
        stackTrace: stackTrace,
        type: ExceptionType.localStorage,
      );
    }
  }

  void clearMedications() {
    try {
      /// Case where we are clearing all medications
      /// Get all streaks for medication
      // final Query query =
      //     _medActivityRecordBox.
      //         .query(Medication_.dbType.equals(ActivityType.medication.name))
      //         .build();
      //
      // final List<MedActivityRecord> activityRecords = query.find() as List<MedActivityRecord>;
      // _medActivityRecordBox.removeMany(activityRecords.map((e) => e.id).toList());

      _medActivityBox.removeAll();
      _medBox.removeAll();
    } catch (e, stackTrace) {
      /// Log and throw app exception

      log(
        "Failed to clear medications",
        error: e,
        stackTrace: stackTrace,
        name: "Medication Local Service",
      );
      throw AppException(
        message: "Failed to clear medications",
        debugMessage: e.toString(),
        stackTrace: stackTrace,
        type: ExceptionType.localStorage,
      );
    }
  }

  /// Medication Schedule
  /// R E A D
  List<ScheduledDose> getMedicationScheduledDoses({DateTime? from, DateTime? until}) {
    late Query query;
    try {
      query = _scheduledDosesBox.query().build();
      if (from != null && until != null) {
        query =
            _scheduledDosesBox
                .query(ScheduledDose_.date.betweenDate(from, until))
                .build();
        List<ScheduledDose> scheduledDoses = query.find() as List<ScheduledDose>;
        return scheduledDoses;
      }

      if (from != null && until == null) {
        query =
            _scheduledDosesBox
                .query(ScheduledDose_.date.betweenDate(from, DateTime.now().copyWith(hour: 23, minute: 59)))
                .build();
        List<ScheduledDose> scheduledDoses = query.find() as List<ScheduledDose>;
        return scheduledDoses;
      }

      if (from == null && until != null) {
        List<ScheduledDose> scheduleDosesList = _scheduledDosesBox.getAll();
        query =
            _scheduledDosesBox
                .query(
              ScheduledDose_.date.betweenDate(scheduleDosesList.first.date, until),
                )
                .build();
        List<ScheduledDose> scheduledDose = query.find() as List<ScheduledDose>;
        return scheduledDose;
      }

      List<ScheduledDose> doses = _scheduledDosesBox.getAll();
      return doses;
    } catch (e, stack) {
      // Throws app exception
      log(
        "Failed to get scheduled doses",
        error: e,
        stackTrace: stack,
        name: "Medication Local Service",
      );
      throw AppException(
        message: "Failed to get all scheduled doses",
        debugMessage: e.toString(),
        stackTrace: stack,
        type: ExceptionType.localStorage,
      );
    } finally {
      query.close();
    }
  }

  /// C R E A T E  &  R E A D
  Future<List<ScheduledDose>> putAndGetMedicationScheduledDoses({
    required List<ScheduledDose> doses,
  }) async {
    try {
      List<ScheduledDose> gottenSchedules = await _scheduledDosesBox
          .putAndGetManyAsync(doses);
      return gottenSchedules;
    } catch (e, stack) {
      // Throws app exception
      log(
        "Failed to put and get scheduled doses",
        error: e,
        stackTrace: stack,
        name: "Medication Local Service",
      );
      throw AppException(
        message: "Failed to put and get scheduled doses",
        debugMessage: e.toString(),
        stackTrace: stack,
        type: ExceptionType.localStorage,
      );
    }
  }

  Future<ScheduledDose> putAndGetMedicationScheduledDose({
    required ScheduledDose schedule,
  }) async {
    try {
      ScheduledDose gottenSchedule = await _scheduledDosesBox.putAndGetAsync(
        schedule,
        mode: schedule.id == 0 ? PutMode.put : PutMode.update,
      );
      return gottenSchedule;
    } catch (e, stack) {
      // Throws app exception
      log(
        "Failed to put and get scheduled dose",
        error: e,
        stackTrace: stack,
        name: "Medication Local Service",
      );
      throw AppException(
        message: "Failed to put and get scheduled dose",
        debugMessage: e.toString(),
        stackTrace: stack,
        type: ExceptionType.localStorage,
      );
    }
  }

  /// D E L E T E
  void deleteMedicationScheduledDoses({required List<ScheduledDose> doses}) {
    try {
      _scheduledDosesBox.removeMany(doses.map((e) => e.id).toList());
    } catch (e, stack) {
      // Throws app exception
      log(
        "Failed to delete scheduled doses",
        error: e,
        stackTrace: stack,
        name: "Medication Local Service",
      );
      throw AppException(
        message: "Failed to delete scheduled doses",
        debugMessage: e.toString(),
        stackTrace: stack,
        type: ExceptionType.localStorage,
      );
    }
  }
}
