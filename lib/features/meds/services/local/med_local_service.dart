import 'dart:developer';

import 'package:circle/features/meds/models/medication.dart';
import 'package:circle/objectbox.g.dart';
import '../../../../core/error/exceptions.dart';
import '../../models/streak.dart';

class MedLocalService {
  late final Box<Medication> _medBox;
  late final Box<Streak> _streakBox;
  MedLocalService({required Store store})
    : _medBox = store.box<Medication>(),
      _streakBox = store.box<Streak>();

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
      if (medication.streaks.isNotEmpty) {
        _streakBox.putMany(medication.streaks);
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

  void deleteMedication({Medication? medication}) {
    try {
      if (medication == null) {
        /// Case where we are clearing all medications
        /// Get all streaks for medication
        final Query query =
            _streakBox
                .query(Streak_.dbType.equals(medication!.type!.name))
                .build();
        final List<Streak> streaks = query.find() as List<Streak>;
        _streakBox.removeMany(streaks.map((e) => e.id).toList());
        _medBox.removeAll();
      } else {
        /// Case where we are deleting only a single medication and it streaks
        _streakBox.removeMany(medication.streaks.map((e) => e.id).toList());
        _medBox.remove(medication.id);
      }
    } catch (e, stackTrace) {
      /// Log and throw app exception
      if (medication == null) {
        log(
          "Failed to clear medication",
          error: e,
          stackTrace: stackTrace,
          name: "Medication Local Service",
        );
        throw AppException(
          message: "Failed to clear medication",
          debugMessage: e.toString(),
          stackTrace: stackTrace,
          type: ExceptionType.localStorage,
        );
      } else {
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
  }
}
