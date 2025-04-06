import 'package:circle/core/core.dart';
import 'package:circle/features/meds/models/med_schedule.dart';
import 'package:circle/features/meds/models/medication.dart';
import 'package:circle/features/meds/services/local/med_local_service.dart';
import 'package:circle/features/meds/services/remote/med_service.dart';

import '../../auth/auth.dart';

abstract class MedRepository {
  FutureEither<Medication> getMedication({required int id});
  FutureEither<List<Medication>> getAllMedications({
    required AppUser user,
    bool getFromRemote = false,
  });

  FutureEither<Medication> putMedication({
    required AppUser user,
    required Medication med,
    bool updateRemote = false,
  });

  FutureEither<void> deleteMedication({
    required AppUser user,
    required Medication med,
    bool updateRemote = false,
  });

  FutureEither<void> clearMedications({
    required AppUser user,
    bool updateRemote = false,
  });

  /// Medication schedules part
  FutureEither<List<MedSchedule>> getMedicationSchedules({
    DateTime? from,
    DateTime? until,
  });

  FutureEither<List<MedSchedule>> putAndGetMedicationSchedules({
    required List<MedSchedule> schedules,
  });
  FutureEither<MedSchedule> putAndGetMedicationSchedule({
  required  MedSchedule schedule,
  });
  FutureEither<void> deleteMedicationSchedules({
   required List<MedSchedule> schedules,
  });
}

class MedRepositoryImpl implements MedRepository {
  final MedService _medService;
  final MedLocalService _medLocalService;

  MedRepositoryImpl({
    required MedService medService,
    required MedLocalService medLocalService,
  }) : _medService = medService,
       _medLocalService = medLocalService;

  @override
  FutureEither<Medication> getMedication({required int id}) async {
    return futureHandler(() async {
      return _medLocalService.getMedication(id: id);
    });
  }

  @override
  FutureEither<List<Medication>> getAllMedications({
    required AppUser user,
    bool getFromRemote = false,
  }) async {
    return futureHandler(() async {
      List<Medication> medications = [];

      if (getFromRemote) {
        medications = await _medService.getMedications(user.uid);
      } else {
        medications = _medLocalService.getAllMedications();
      }
      return medications;
    });
  }

  @override
  FutureEither<Medication> putMedication({
    required AppUser user,
    required Medication med,
    bool updateRemote = false,
  }) async {
    return futureHandler(() async {
      if (updateRemote) {
        /// Uses Objectbox ids to determine whether to update
        /// or add medication to the remote database
        if (med.id == 0) {
          await _medService.addMedication(user: user, med: med);
        } else {
          await _medService.updateMedication(user: user, med: med);
        }
      }
      return await _medLocalService.putAndGetMedication(med);
    });
  }

  FutureEither<Medication> updateMedication({
    required AppUser user,
    required Medication med,
    bool updateRemote = false,
  }) async {
    return futureHandler(() async {
      if (updateRemote) {
        await _medService.updateMedication(user: user, med: med);
      }
      return await _medLocalService.putAndGetMedication(med);
    });
  }

  @override
  FutureEither<void> deleteMedication({
    required AppUser user,
    required Medication med,
    bool updateRemote = false,
  }) async {
    return futureHandler(() async {
      if (updateRemote) {
        await _medService.deleteMedication(user: user, med: med);
      }
      _medLocalService.deleteMedication(med);
    });
  }

  @override
  FutureEither<void> clearMedications({
    required AppUser user,
    bool updateRemote = false,
  }) async {
    return futureHandler(() async {
      if (updateRemote) {
        await _medService.clearMedication(user: user);
      }
      _medLocalService.clearMedications();
    });
  }

  // MED SCHEDULES
  // TODO: Add remote service to this
  @override
  FutureEither<void> deleteMedicationSchedules({required List<MedSchedule> schedules}) {
    return futureHandler(() async {
      return _medLocalService.deleteMedicationSchedules(
    schedules: schedules
      );
    });
  }


  @override
  FutureEither<List<MedSchedule>> getMedicationSchedules({DateTime? from, DateTime? until}) {
    return futureHandler(() async {
      return _medLocalService.getMedicationSchedules(
        from: from,
        until: until,
      );
    });
  }

  @override
  FutureEither<MedSchedule> putAndGetMedicationSchedule({required MedSchedule schedule}) {
    return futureHandler(() async {
      return _medLocalService.putAndGetMedicationSchedule(
        schedule: schedule,
      );
    });
  }

  @override
  FutureEither<List<MedSchedule>> putAndGetMedicationSchedules({required List<MedSchedule> schedules}) {
    return futureHandler(() async {
      return _medLocalService.putAndGetMedicationSchedules(
        schedules: schedules,
      );
    });
  }
}
