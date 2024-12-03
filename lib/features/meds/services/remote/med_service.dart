import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/medication.dart';

class MedService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  //Get User Data

  Future<DocumentSnapshot<Map<String, dynamic>>> getMedication(
    String uid,
  ) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await firestore.collection('meds').doc(uid).get();
    return snapshot;
  }

  Future<void> addMedication({required user, required Medication med}) async {
    await firestore.collection('meds').doc(user.uid).set({
      "medication": FieldValue.arrayUnion([med.toMap()]),
    }, SetOptions(merge: true));
  }

  Future<void> addMedications({
    required user,
    required List<Medication> meds,
  }) async {
    await firestore.collection('meds').doc(user.uid).set({
      "medication": FieldValue.arrayUnion(
        meds.map((meds) => meds.toMap()).toList(),
      ),
    }, SetOptions(merge: true));
  }

  Future<void> updateMedication({
    required user,
    required Medication med,
  }) async {
    await firestore.collection('meds').doc(user.uid).update({
      "medication": FieldValue.arrayUnion([med.toMap()]),
    });
  }

  Future<void> updateMedications({
    required user,
    required List<Medication> meds,
  }) async {
    await firestore.collection('meds').doc(user.uid).update({
      "medication": FieldValue.arrayUnion(
        meds.map((meds) => meds.toMap()).toList(),
      ),
    });
  }

  Future<void> deleteMedication({
    required user,
    required Medication med,
  }) async {
    await firestore.collection('meds').doc(user.uid).update({
      "medication": FieldValue.arrayRemove([med.toMap()]),
    });
  }

  Future<void> deleteMedications({
    required user,
    required List<Medication> meds,
  }) async {
    await firestore.collection('meds').doc(user.uid).update({
      "medication": FieldValue.arrayRemove(
        meds.map((meds) => meds.toMap()).toList(),
      ),
    });
  }

  Future<void> clearMedication({required user, required Medication med}) async {
    await firestore.collection('meds').doc(user.uid).update({
      "medication": FieldValue.arrayRemove([med.toMap()]),
    });
  }
}
