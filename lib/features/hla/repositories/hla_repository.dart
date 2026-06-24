import 'package:uuid/uuid.dart';

import '../../../core/core.dart';
import '../../../core/error/exceptions.dart';
import '../../auth/auth.dart';
import '../models/hla_appointment_slot.dart';
import '../models/hla_sample_subject.dart';
import '../models/hla_status_event.dart';
import '../models/hla_test_request.dart';
import '../services/local/hla_local_service.dart';
import '../services/remote/hla_service.dart';

/// Bridges the HLA notifiers and the [HlaService] / [HlaLocalService]. Owns the
/// feature's business rules (one active request per patient, valid status
/// transitions, freeing a slot on cancellation) and converts thrown exceptions
/// into [Failure]s via `futureHandler`, returning [FutureEither].
abstract class HlaRepository {
  // Patient
  FutureEither<HlaTestRequest> createRequest({
    required AppUser user,
    required List<HlaSampleSubject> subjects,
    bool consentAccepted,
  });
  FutureEither<List<HlaTestRequest>> getRequestsForUser({
    required String userId,
  });
  FutureEither<HlaTestRequest?> getActiveRequest({required String userId});
  FutureEither<HlaTestRequest> updateSubjects({
    required HlaTestRequest request,
    required List<HlaSampleSubject> subjects,
  });
  FutureEither<HlaTestRequest> bookAppointment({
    required HlaTestRequest request,
    required HlaAppointmentSlot slot,
  });
  FutureEither<void> cancelRequest({required HlaTestRequest request});
  FutureEither<List<HlaAppointmentSlot>> getAvailableSlots();

  /// Realtime stream of a single request (status timeline). Not wrapped in
  /// [FutureEither] — stream errors surface through the notifier's
  /// `AsyncValue.error`.
  Stream<HlaTestRequest?> streamRequest({required String requestId});

  // Admin
  FutureEither<List<HlaTestRequest>> getAllRequests({HlaTestStatus? status});
  FutureEither<HlaTestRequest> advanceStatus({
    required HlaTestRequest request,
    required HlaTestStatus status,
    String? note,
  });
  FutureEither<HlaTestRequest> uploadResult({
    required HlaTestRequest request,
    required String filePath,
    required String fileName,
    String? summary,
  });
  FutureEither<List<HlaAppointmentSlot>> getAllSlots();
  FutureEither<HlaAppointmentSlot> putSlot({required HlaAppointmentSlot slot});
}

class HlaRepositoryImpl implements HlaRepository {
  final HlaService _hlaService;
  final HlaLocalService? _hlaLocalService;
  final Uuid _uuid;

  HlaRepositoryImpl({
    required HlaService hlaService,
    HlaLocalService? hlaLocalService,
    Uuid? uuid,
  })  : _hlaService = hlaService,
        _hlaLocalService = hlaLocalService,
        _uuid = uuid ?? const Uuid();

  // ─── Patient ─────────────────────────────────────────────────────────────────

  @override
  FutureEither<HlaTestRequest> createRequest({
    required AppUser user,
    required List<HlaSampleSubject> subjects,
    bool consentAccepted = false,
  }) {
    return futureHandler(() async {
      // D6: only one open journey at a time.
      final List<HlaTestRequest> existing =
          await _hlaService.getRequestsForUser(user.uid);
      final bool hasActive =
          existing.any((r) => !r.isCancelled && !r.status.isTerminal);
      if (hasActive) {
        throw AppException(
          message: "You already have an active request in progress",
          type: ExceptionType.generic,
          stackTrace: StackTrace.current,
        );
      }

      // The patient is always the primary subject.
      final List<HlaSampleSubject> panel = [
        if (!subjects.any((s) => s.isSelf))
          HlaSampleSubject.self(name: user.getDisplayName()),
        ...subjects,
      ];

      final DateTime now = DateTime.now().toUtc();
      final HlaTestRequest request = HlaTestRequest(
        uid: _uuid.v4(),
        userId: user.uid,
        patientName: user.getDisplayName(),
        status: HlaTestStatus.requested,
        subjects: panel,
        statusHistory: [
          HlaStatusEvent(status: HlaTestStatus.requested, timestamp: now),
        ],
        createdAt: now,
        updatedAt: now,
      );

      final HlaTestRequest created = await _hlaService.createRequest(request);
      _cache([created, ...existing]);
      return created;
    });
  }

  @override
  FutureEither<List<HlaTestRequest>> getRequestsForUser({
    required String userId,
  }) {
    return futureHandler(() async {
      final List<HlaTestRequest> requests =
          await _hlaService.getRequestsForUser(userId);
      _cache(requests);
      return requests;
    });
  }

  @override
  FutureEither<HlaTestRequest?> getActiveRequest({required String userId}) {
    return futureHandler(() async {
      final List<HlaTestRequest> requests =
          await _hlaService.getRequestsForUser(userId);
      try {
        return requests
            .firstWhere((r) => !r.isCancelled && !r.status.isTerminal);
      } catch (_) {
        return null;
      }
    });
  }

  @override
  FutureEither<HlaTestRequest> updateSubjects({
    required HlaTestRequest request,
    required List<HlaSampleSubject> subjects,
  }) {
    return futureHandler(() async {
      if (request.status != HlaTestStatus.requested) {
        throw AppException(
          message: "Subjects can only be changed before the sample is collected",
          type: ExceptionType.generic,
          stackTrace: StackTrace.current,
        );
      }
      // AC US-2.4: self can never be removed.
      final List<HlaSampleSubject> panel = [
        if (!subjects.any((s) => s.isSelf))
          HlaSampleSubject.self(name: request.patientName),
        ...subjects,
      ];
      final HlaTestRequest updated = request.copyWith(subjects: panel);
      await _hlaService.updateRequest(updated);
      return updated;
    });
  }

  @override
  FutureEither<HlaTestRequest> bookAppointment({
    required HlaTestRequest request,
    required HlaAppointmentSlot slot,
  }) {
    return futureHandler(() async {
      if (!slot.isAvailable) {
        throw AppException(
          message: "This slot is no longer available, please pick another",
          type: ExceptionType.generic,
          stackTrace: StackTrace.current,
        );
      }
      final HlaTestRequest updated = request.copyWith(
        status: HlaTestStatus.bookingConfirmed,
        appointmentSlotId: slot.id,
        appointmentDate: slot.dateTime,
        collectionLocation: slot.location,
        statusHistory: [
          ...request.statusHistory,
          HlaStatusEvent.now(status: HlaTestStatus.bookingConfirmed),
        ],
      );
      // Atomic: increments the slot's bookedCount and writes the request.
      await _hlaService.bookSlot(slotId: slot.id, request: updated);
      return updated;
    });
  }

  @override
  FutureEither<void> cancelRequest({required HlaTestRequest request}) {
    return futureHandler(() async {
      if (!request.status.isPatientCancellable) {
        throw AppException(
          message: "This request can no longer be cancelled",
          type: ExceptionType.generic,
          stackTrace: StackTrace.current,
        );
      }
      final HlaTestRequest cancelled = request.copyWith(
        status: HlaTestStatus.cancelled,
        isCancelled: true,
        statusHistory: [
          ...request.statusHistory,
          HlaStatusEvent.now(status: HlaTestStatus.cancelled),
        ],
      );
      await _hlaService.updateRequest(cancelled);
      if (request.appointmentSlotId != null) {
        await _hlaService.releaseSlot(request.appointmentSlotId!);
      }
    });
  }

  @override
  FutureEither<List<HlaAppointmentSlot>> getAvailableSlots() {
    return futureHandler(() => _hlaService.getAvailableSlots());
  }

  @override
  Stream<HlaTestRequest?> streamRequest({required String requestId}) {
    return _hlaService.streamRequest(requestId);
  }

  // ─── Admin ───────────────────────────────────────────────────────────────────

  @override
  FutureEither<List<HlaTestRequest>> getAllRequests({HlaTestStatus? status}) {
    return futureHandler(() => _hlaService.getAllRequests(status: status));
  }

  @override
  FutureEither<HlaTestRequest> advanceStatus({
    required HlaTestRequest request,
    required HlaTestStatus status,
    String? note,
  }) {
    return futureHandler(() async {
      final HlaTestRequest updated = request.copyWith(
        status: status,
        isCancelled: status == HlaTestStatus.cancelled ? true : null,
        statusHistory: [
          ...request.statusHistory,
          HlaStatusEvent.now(status: status, note: note),
        ],
      );
      await _hlaService.updateRequest(updated);
      // Free the seat if an admin cancels a booked request.
      if (status == HlaTestStatus.cancelled &&
          request.appointmentSlotId != null) {
        await _hlaService.releaseSlot(request.appointmentSlotId!);
      }
      return updated;
    });
  }

  @override
  FutureEither<HlaTestRequest> uploadResult({
    required HlaTestRequest request,
    required String filePath,
    required String fileName,
    String? summary,
  }) {
    return futureHandler(() async {
      final String url = await _hlaService.uploadResultFile(
        requestId: request.uid,
        filePath: filePath,
        fileName: fileName,
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
      await _hlaService.updateRequest(updated);
      return updated;
    });
  }

  @override
  FutureEither<List<HlaAppointmentSlot>> getAllSlots() {
    return futureHandler(() => _hlaService.getAllSlots());
  }

  @override
  FutureEither<HlaAppointmentSlot> putSlot({required HlaAppointmentSlot slot}) {
    return futureHandler(() async {
      final HlaAppointmentSlot toSave =
          slot.id.isEmpty ? slot.copyWith(id: _uuid.v4()) : slot;
      await _hlaService.putSlot(toSave);
      return toSave;
    });
  }

  /// Best-effort local cache write — never fails a remote read.
  void _cache(List<HlaTestRequest> requests) {
    try {
      _hlaLocalService?.cacheRequests(requests);
    } catch (_) {
      // Caching is opportunistic; ignore failures.
    }
  }
}
