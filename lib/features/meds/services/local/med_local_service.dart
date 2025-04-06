import 'dart:developer';

import 'package:circle/features/meds/models/medication.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../objectbox.g.dart';
import '../../models/med_activity_record.dart';
import '../../models/med_schedule.dart';

class MedLocalService {
  late final Box<Medication> _medBox;
  late final Box<MedActivityRecord> _medActivityBox;
  late final Box<MedSchedule> _medScheduleBox;
  MedLocalService({required Store store})
    : _medBox = store.box<Medication>(),
      _medActivityBox = store.box<MedActivityRecord>(),
      _medScheduleBox = store.box<MedSchedule>();

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
  List<MedSchedule> getMedicationSchedules({
    DateTime? from,
    DateTime? until,
  }) {
    late final Query query;
    try {

      if (from != null && until != null) {
        query =
            _medScheduleBox
                .query(MedSchedule_.date.betweenDate(from, until))
                .build();
        List<MedSchedule> schedules = query.find() as List<MedSchedule>;
        return schedules;
      }

      if (from != null && until == null) {
        query =
            _medScheduleBox
                .query(MedSchedule_.date.betweenDate(from, DateTime.now()))
                .build();
        List<MedSchedule> schedules = query.find() as List<MedSchedule>;
        return schedules;
      }

      if (from == null && until != null) {
        List<MedSchedule> scheduleList = _medScheduleBox.getAll();
        query =
            _medScheduleBox
                .query(
                  MedSchedule_.date.betweenDate(scheduleList.first.date, until),
                )
                .build();
        List<MedSchedule> schedules = query.find() as List<MedSchedule>;
        return schedules;
      }

      List<MedSchedule> schedules = _medScheduleBox.getAll();
      return schedules;
    } catch (e, stack) {
      // Throws app exception
      log(
        "Failed to get medication schedule",
        error: e,
        stackTrace: stack,
        name: "Medication Local Service",
      );
      throw AppException(
        message: "Failed to get all medication schedule",
        debugMessage: e.toString(),
        stackTrace: stack,
        type: ExceptionType.localStorage,
      );
    } finally {
      query.close();
    }
  }
 /// C R E A T E  &  R E A D
  Future<List<MedSchedule>> putAndGetMedicationSchedules({
    required List<MedSchedule> schedules,
  }) async {
    try {
      List<MedSchedule> gottenSchedules = await _medScheduleBox
          .putAndGetManyAsync(schedules);
      return gottenSchedules;
    } catch (e, stack) {
      // Throws app exception
      log(
        "Failed to put and get medication schedules",
        error: e,
        stackTrace: stack,
        name: "Medication Local Service",
      );
      throw AppException(
        message: "Failed to put and get medication schedules",
        debugMessage: e.toString(),
        stackTrace: stack,
        type: ExceptionType.localStorage,
      );
    }
  }

  Future<MedSchedule> putAndGetMedicationSchedule({
    required MedSchedule schedule,
  }) async {
    try {
      MedSchedule gottenSchedule = await _medScheduleBox.putAndGetAsync(
        schedule,
        mode: schedule.id == 0 ? PutMode.put : PutMode.update,
      );
      return gottenSchedule;
    } catch (e, stack) {
      // Throws app exception
      log(
        "Failed to put and get medication schedule",
        error: e,
        stackTrace: stack,
        name: "Medication Local Service",
      );
      throw AppException(
        message: "Failed to put and get medication schedules",
        debugMessage: e.toString(),
        stackTrace: stack,
        type: ExceptionType.localStorage,
      );
    }
  }

  /// D E L E T E
  void deleteMedicationSchedules({
    required List<MedSchedule> schedules,
  })  {
    try {
     _medScheduleBox.removeMany( schedules.map((e)=> e.id).toList());
    } catch (e, stack) {
      // Throws app exception
      log(
        "Failed to delete medication schedules",
        error: e,
        stackTrace: stack,
        name: "Medication Local Service",
      );
      throw AppException(
        message: "Failed to delete medication schedules",
        debugMessage: e.toString(),
        stackTrace: stack,
        type: ExceptionType.localStorage,
      );
    }
  }

}
