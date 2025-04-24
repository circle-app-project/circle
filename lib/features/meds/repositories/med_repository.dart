import 'package:circle/core/core.dart';
import 'package:circle/features/meds/models/scheduled_doses.dart';
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
  FutureEither<List<ScheduledDose>> getMedScheduledDoses({
    DateTime? from,
    DateTime? until,
  });

  FutureEither<List<ScheduledDose>> putAndGetMedScheduledDoses({
    required List<ScheduledDose> schedules,
  });
  FutureEither<ScheduledDose> putAndGetMedScheduledDose({
    required ScheduledDose schedule,
  });
  FutureEither<void> deleteMedScheduledDoses({
    required List<ScheduledDose> schedules,
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
  FutureEither<void> deleteMedScheduledDoses({
    required List<ScheduledDose> schedules,
  }) {
    return futureHandler(() async {
      return _medLocalService.deleteMedicationScheduledDoses(doses: schedules);
    });
  }

  @override
  FutureEither<List<ScheduledDose>> getMedScheduledDoses({
    DateTime? from,
    DateTime? until,
  }) {
    return futureHandler(() async {
      /// Gets the parent medication for each scheduled dose and include in the
      /// dose object itself.
      List<Medication> medications = _medLocalService.getAllMedications();

      List<ScheduledDose> scheduledDoses = _medLocalService
          .getMedicationScheduledDoses(from: from, until: until);

      scheduledDoses =
          scheduledDoses
              .map(
                (dose) => dose.copyWith(
                  medication: medications.firstWhere(
                    (med) => med.uid == dose.parentId,
                  ),
                ),
              )
              .toList();

      return scheduledDoses;
    });
  }

  @override
  FutureEither<ScheduledDose> putAndGetMedScheduledDose({
    required ScheduledDose schedule,
  }) {
    return futureHandler(() async {
      return _medLocalService.putAndGetMedicationScheduledDose(
        schedule: schedule,
      );
    });
  }

  @override
  FutureEither<List<ScheduledDose>> putAndGetMedScheduledDoses({
    required List<ScheduledDose> schedules,
  }) {
    return futureHandler(() async {
      return _medLocalService.putAndGetMedicationScheduledDoses(
        doses: schedules,
      );
    });
  }
}
