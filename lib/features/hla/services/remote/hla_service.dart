import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/enums.dart';
import '../../models/hla_appointment_slot.dart';
import '../../models/hla_test_request.dart';

/// Raw Firestore + Firebase Storage I/O for the HLA feature. No business logic
/// lives here (per the architecture doc) — it only reads and writes documents
/// and uploads files, throwing [AppException] for domain conditions and
/// letting [FirebaseException]s propagate to the repository's `futureHandler`.
class HlaService {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  HlaService({FirebaseFirestore? firestore, FirebaseStorage? storage})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = storage ?? FirebaseStorage.instance;

  static const String _requestsCollection = "hla_test_requests";
  static const String _slotsCollection = "hla_appointment_slots";

  CollectionReference<Map<String, dynamic>> get _requests =>
      _firestore.collection(_requestsCollection);

  CollectionReference<Map<String, dynamic>> get _slots =>
      _firestore.collection(_slotsCollection);

  // ─── Requests ──────────────────────────────────────────────────────────────

  /// Creates the request document under its uid.
  Future<HlaTestRequest> createRequest(HlaTestRequest request) async {
    await _requests.doc(request.uid).set(request.toMap());
    return request;
  }

  /// All requests owned by [userId], newest first.
  Future<List<HlaTestRequest>> getRequestsForUser(String userId) async {
    final QuerySnapshot<Map<String, dynamic>> snapshot = await _requests
        .where("userId", isEqualTo: userId)
        .orderBy("createdAt", descending: true)
        .get();
    return snapshot.docs.map((doc) => HlaTestRequest.fromMap(doc.data())).toList();
  }

  /// A single request by id, or throws if it does not exist.
  Future<HlaTestRequest> getRequest(String requestId) async {
    final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _requests.doc(requestId).get();
    final data = snapshot.data();
    if (!snapshot.exists || data == null) {
      throw AppException(
        message: "This request could not be found",
        type: ExceptionType.firebase,
        stackTrace: StackTrace.current,
      );
    }
    return HlaTestRequest.fromMap(data);
  }

  /// Realtime stream of a single request — drives the patient status timeline.
  /// Emits null while the document does not (yet) exist.
  Stream<HlaTestRequest?> streamRequest(String requestId) {
    return _requests.doc(requestId).snapshots().map((snapshot) {
      final data = snapshot.data();
      if (!snapshot.exists || data == null) return null;
      return HlaTestRequest.fromMap(data);
    });
  }

  /// Persists an existing request (full overwrite via merge).
  Future<void> updateRequest(HlaTestRequest request) async {
    await _requests.doc(request.uid).set(request.toMap(), SetOptions(merge: true));
  }

  /// Admin: all requests, optionally filtered by [status], newest first.
  Future<List<HlaTestRequest>> getAllRequests({HlaTestStatus? status}) async {
    Query<Map<String, dynamic>> query =
        _requests.orderBy("createdAt", descending: true);
    if (status != null) {
      query = _requests
          .where("status", isEqualTo: status.name)
          .orderBy("createdAt", descending: true);
    }
    final QuerySnapshot<Map<String, dynamic>> snapshot = await query.get();
    return snapshot.docs.map((doc) => HlaTestRequest.fromMap(doc.data())).toList();
  }

  // ─── Appointment slots ───────────────────────────────────────────────────────

  /// Future, active slots with remaining capacity, soonest first.
  Future<List<HlaAppointmentSlot>> getAvailableSlots() async {
    final QuerySnapshot<Map<String, dynamic>> snapshot = await _slots
        .where("isActive", isEqualTo: true)
        .orderBy("dateTime")
        .get();
    return snapshot.docs
        .map((doc) => HlaAppointmentSlot.fromMap(doc.data()))
        .where((slot) => slot.isAvailable)
        .toList();
  }

  /// Admin: every slot regardless of state, soonest first.
  Future<List<HlaAppointmentSlot>> getAllSlots() async {
    final QuerySnapshot<Map<String, dynamic>> snapshot =
        await _slots.orderBy("dateTime").get();
    return snapshot.docs
        .map((doc) => HlaAppointmentSlot.fromMap(doc.data()))
        .toList();
  }

  /// Admin: create or update a slot.
  Future<void> putSlot(HlaAppointmentSlot slot) async {
    await _slots.doc(slot.id).set(slot.toMap(), SetOptions(merge: true));
  }

  /// Atomically books [slotId] and persists the already-updated [request]
  /// (status `bookingConfirmed`, appointment fields set) in one transaction so
  /// a slot can never be over-booked. Throws if the slot filled in the
  /// meantime (AC US-3.3).
  Future<void> bookSlot({
    required String slotId,
    required HlaTestRequest request,
  }) async {
    final DocumentReference<Map<String, dynamic>> slotRef = _slots.doc(slotId);
    final DocumentReference<Map<String, dynamic>> requestRef =
        _requests.doc(request.uid);

    await _firestore.runTransaction((txn) async {
      final DocumentSnapshot<Map<String, dynamic>> slotSnap =
          await txn.get(slotRef);
      final data = slotSnap.data();
      if (!slotSnap.exists || data == null) {
        throw AppException(
          message: "This slot is no longer available",
          type: ExceptionType.firebase,
          stackTrace: StackTrace.current,
        );
      }
      final HlaAppointmentSlot slot = HlaAppointmentSlot.fromMap(data);
      if (!slot.isAvailable) {
        throw AppException(
          message: "This slot is no longer available, please pick another",
          type: ExceptionType.firebase,
          stackTrace: StackTrace.current,
        );
      }
      txn.update(slotRef, {"bookedCount": slot.bookedCount + 1});
      txn.set(requestRef, request.toMap(), SetOptions(merge: true));
    });
  }

  /// Frees a previously booked seat (on cancellation). Best-effort: clamps at
  /// zero and ignores a missing slot.
  Future<void> releaseSlot(String slotId) async {
    final DocumentReference<Map<String, dynamic>> slotRef = _slots.doc(slotId);
    await _firestore.runTransaction((txn) async {
      final DocumentSnapshot<Map<String, dynamic>> slotSnap =
          await txn.get(slotRef);
      final data = slotSnap.data();
      if (!slotSnap.exists || data == null) return;
      final int current = (data["bookedCount"] as num?)?.toInt() ?? 0;
      txn.update(slotRef, {"bookedCount": current > 0 ? current - 1 : 0});
    });
  }

  // ─── Results (Firebase Storage) ──────────────────────────────────────────────

  /// Uploads a result document to `hla_results/{requestId}/{fileName}` and
  /// returns the download URL.
  Future<String> uploadResultFile({
    required String requestId,
    required String filePath,
    required String fileName,
  }) async {
    final Reference ref =
        _storage.ref().child("hla_results/$requestId/$fileName");
    await ref.putFile(File(filePath));
    return ref.getDownloadURL();
  }
}
