import 'package:circle/features/meds/models/medication.dart';
import 'package:circle/objectbox.g.dart';

class MedLocalService {
  late final Box<Medication> _medBox;
  late final Box<MedicationStreak> _medStreakBox;
  MedLocalService({required Store store}) : _medBox = store.box<Medication>(), _medStreakBox = store.box<MedicationStreak>();

  List<Medication> getAllMedications() {
    List<Medication> medications = _medBox.getAll();
    return medications.isNotEmpty ? medications : [];
  }

  Medication getMedication({required int id}) {
    Medication? medication = _medBox.get(id);
    return medication ?? Medication.empty;
  }

  //Todo: implement a searching functionality for medication
  Stream<List<Medication>> listenMedication() {
    return _medBox
        .query()
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }

  Future<Medication> putAndGetMedication(Medication medication) async {
    //TODO: Save relations first
    return await _medBox.putAndGetAsync(
      medication,
      mode: medication.id == 0 ? PutMode.put : PutMode.update,
    );
  }

  void deleteMedication({Medication? medication}) {
    if (medication == null) {
      //Todo: remove relations
      _medBox.removeAll();
    } else {
      //Todo: remove relations
      _medBox.remove(medication.id);
    }
  }
}
