import 'dart:typed_data';

import '../core/enums.dart';
import '../models/hla_appointment_slot.dart';
import '../models/hla_status_event.dart';
import '../models/hla_test_request.dart';
import '../services/hla_admin_service.dart';

/// Admin business logic: appends status-history events, sets result fields,
/// and frees a slot when a booked request is cancelled. Delegates I/O to
/// [HlaAdminService] (which throws [AdminException] on failure).
class HlaAdminRepository {
  HlaAdminRepository(this._service);

  final HlaAdminService _service;

  Stream<List<HlaTestRequest>> watchRequests({HlaTestStatus? status}) =>
      _service.streamRequests(status: status);

  Stream<List<HlaAppointmentSlot>> watchSlots() => _service.streamSlots();

  Future<bool> isAdmin(String uid) => _service.isAdmin(uid);

  Future<void> advanceStatus({
    required HlaTestRequest request,
    required HlaTestStatus status,
    String? note,
  }) async {
    final HlaTestRequest updated = request.copyWith(
      status: status,
      isCancelled: status == HlaTestStatus.cancelled ? true : null,
      statusHistory: [
        ...request.statusHistory,
        HlaStatusEvent.now(status: status, note: note),
      ],
    );
    await _service.updateRequest(updated);
    if (status == HlaTestStatus.cancelled && request.appointmentSlotId != null) {
      await _service.releaseSlot(request.appointmentSlotId!);
    }
  }

  Future<void> uploadResult({
    required HlaTestRequest request,
    required Uint8List bytes,
    required String fileName,
    String? contentType,
    String? summary,
  }) async {
    final String url = await _service.uploadResult(
      requestId: request.uid,
      bytes: bytes,
      fileName: fileName,
      contentType: contentType,
    );
    final HlaTestRequest updated = request.copyWith(
      status: HlaTestStatus.resultsAvailable,
      resultFileUrl: url,
      resultFileName: fileName,
      resultSummary: summary,
      statusHistory: [
        ...request.statusHistory,
        HlaStatusEvent.now(status: HlaTestStatus.resultsAvailable),
      ],
    );
    await _service.updateRequest(updated);
  }

  Future<void> putSlot(HlaAppointmentSlot slot) => _service.putSlot(slot);
}
