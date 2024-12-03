import 'package:circle/core/core.dart';
import 'package:circle/features/meds/models/medication.dart';
import 'package:circle/features/meds/services/local/med_local_service.dart';
import 'package:circle/features/meds/services/remote/med_service.dart';

import '../../auth/auth.dart';

class MedRepository {
  final MedService _medService;
  final MedLocalService _medLocalService;

  MedRepository({
    required MedService medService,
    required MedLocalService medLocalService,
  }) : _medService = medService,
       _medLocalService = medLocalService;

  FutureEither<Medication> getMedication({required int id}) async {
    return futureHandler(() async {
      return _medLocalService.getMedication(id: id);
    });
  }

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

  FutureEither<Medication> addMedication({
    required AppUser user,
    required Medication med,
    bool updateRemote = false,
  }) async {
    return futureHandler(() async {
      if (updateRemote) {
        await _medService.addMedication(user: user, med: med);
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

  FutureEither<void> deleteMedication({
    required AppUser user,
    required Medication med,
    bool updateRemote = false,
  }) async {
    return futureHandler(() async {
      if (updateRemote) {
        await _medService.deleteMedication(user: user, med: med);
      }
      _medLocalService.deleteMedication(medication: med);
    });
  }

  FutureEither<void> clearMedication({
    required AppUser user,
    bool updateRemote = false,
  }) async {
    return futureHandler(() async {
      if (updateRemote) {
        await _medService.clearMedication(user: user);
      }
      _medLocalService.deleteMedication();
    });
  }
}
