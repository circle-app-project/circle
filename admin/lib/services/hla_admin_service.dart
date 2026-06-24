import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../core/enums.dart';
import '../core/exceptions.dart';
import '../models/hla_appointment_slot.dart';
import '../models/hla_test_request.dart';

/// Firestore + Storage I/O for the admin dashboard. Talks to the same
/// collections the mobile app uses (`hla_test_requests`, `hla_appointment_slots`,
/// `hla_admins`). No business logic — that lives in the repository.
class HlaAdminService {
  HlaAdminService({FirebaseFirestore? firestore, FirebaseStorage? storage})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = storage ?? FirebaseStorage.instance;

  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  CollectionReference<Map<String, dynamic>> get _requests =>
      _firestore.collection('hla_test_requests');
  CollectionReference<Map<String, dynamic>> get _slots =>
      _firestore.collection('hla_appointment_slots');

  /// True when the signed-in user has an `hla_admins/{uid}` document — the
  /// authoritative admin gate enforced by the security rules.
  Future<bool> isAdmin(String uid) async {
    final doc = await _firestore.collection('hla_admins').doc(uid).get();
    return doc.exists;
  }

  // ── Requests ──────────────────────────────────────────────────────────────

  Stream<List<HlaTestRequest>> streamRequests({HlaTestStatus? status}) {
    Query<Map<String, dynamic>> query =
        _requests.orderBy('createdAt', descending: true);
    if (status != null) {
      query = _requests
          .where('status', isEqualTo: status.name)
          .orderBy('createdAt', descending: true);
    }
    return query.snapshots().map(
          (snap) =>
              snap.docs.map((d) => HlaTestRequest.fromMap(d.data())).toList(),
        );
  }

  Future<void> updateRequest(HlaTestRequest request) async {
    try {
      await _requests
          .doc(request.uid)
          .set(request.toMap(), SetOptions(merge: true));
    } on FirebaseException catch (e) {
      throw AdminException(e.message ?? 'Failed to update request', cause: e);
    }
  }

  Future<String> uploadResult({
    required String requestId,
    required Uint8List bytes,
    required String fileName,
    String? contentType,
  }) async {
    try {
      final Reference ref =
          _storage.ref().child('hla_results/$requestId/$fileName');
      await ref.putData(bytes, SettableMetadata(contentType: contentType));
      return await ref.getDownloadURL();
    } on FirebaseException catch (e) {
      throw AdminException(e.message ?? 'Failed to upload result', cause: e);
    }
  }

  // ── Slots ───────────────────────────────────────────────────────────────────

  Stream<List<HlaAppointmentSlot>> streamSlots() {
    return _slots.orderBy('dateTime').snapshots().map(
          (snap) => snap.docs
              .map((d) => HlaAppointmentSlot.fromMap(d.data()))
              .toList(),
        );
  }

  /// Creates (auto-id) or updates a slot.
  Future<void> putSlot(HlaAppointmentSlot slot) async {
    try {
      final DocumentReference<Map<String, dynamic>> ref =
          slot.id.isEmpty ? _slots.doc() : _slots.doc(slot.id);
      final HlaAppointmentSlot toSave =
          slot.id.isEmpty ? slot.copyWith(id: ref.id) : slot;
      await ref.set(toSave.toMap(), SetOptions(merge: true));
    } on FirebaseException catch (e) {
      throw AdminException(e.message ?? 'Failed to save slot', cause: e);
    }
  }

  /// Frees a booked seat (e.g. when an admin cancels a booked request).
  Future<void> releaseSlot(String slotId) async {
    try {
      final ref = _slots.doc(slotId);
      await _firestore.runTransaction((txn) async {
        final snap = await txn.get(ref);
        final data = snap.data();
        if (!snap.exists || data == null) return;
        final int current = (data['bookedCount'] as num?)?.toInt() ?? 0;
        txn.update(ref, {'bookedCount': current > 0 ? current - 1 : 0});
      });
    } on FirebaseException catch (e) {
      throw AdminException(e.message ?? 'Failed to free the slot', cause: e);
    }
  }
}
