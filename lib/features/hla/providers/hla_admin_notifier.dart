import 'dart:developer';

import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/core.dart';
import '../hla.dart';

part 'hla_admin_notifier.g.dart';

final HlaAdminNotifierProvider hlaAdminNotifierProviderImpl =
    hlaAdminNotifierProvider(hlaRepository: hlaRepository);

final HlaAdminSlotsNotifierProvider hlaAdminSlotsNotifierProviderImpl =
    hlaAdminSlotsNotifierProvider(hlaRepository: hlaRepository);

/// Admin: the full request queue, with actions to advance status and upload
/// results. Visible only to `role == admin` users (UI gate + Firestore rules).
@Riverpod(keepAlive: true)
class HlaAdminNotifier extends _$HlaAdminNotifier {
  late final HlaRepository _hlaRepository;
  HlaTestStatus? _filter;

  @override
  FutureOr<List<HlaTestRequest>> build({
    required HlaRepository hlaRepository,
  }) async {
    _hlaRepository = hlaRepository;
    return [];
  }

  Future<void> getAllRequests({HlaTestStatus? status}) async {
    _filter = status;
    log("Getting all requests (filter: ${status?.name ?? 'none'})",
        name: "HLA Admin Notifier");
    state = const AsyncValue.loading();
    final Either<Failure, List<HlaTestRequest>> response =
        await _hlaRepository.getAllRequests(status: status);
    response.fold(
      (failure) {
        log(
          "Failed to get requests: ${failure.message}, code: ${failure.code}",
          name: "HLA Admin Notifier",
          stackTrace: failure.stackTrace,
        );
        state = AsyncValue.error(
          failure,
          failure.stackTrace ?? StackTrace.current,
        );
      },
      (requests) {
        log("Loaded ${requests.length} request(s)",
            name: "HLA Admin Notifier");
        state = AsyncValue.data(requests);
      },
    );
  }

  Future<void> advanceStatus({
    required HlaTestRequest request,
    required HlaTestStatus status,
    String? note,
  }) async {
    log("Advancing ${request.uid} -> ${status.name}",
        name: "HLA Admin Notifier");
    state = const AsyncValue.loading();
    final Either<Failure, HlaTestRequest> response = await _hlaRepository
        .advanceStatus(request: request, status: status, note: note);
    await response.fold(
      (failure) async {
        log(
          "Failed to advance: ${failure.message}, code: ${failure.code}",
          name: "HLA Admin Notifier",
          stackTrace: failure.stackTrace,
        );
        state = AsyncValue.error(
          failure,
          failure.stackTrace ?? StackTrace.current,
        );
      },
      (_) async {
        log("Advanced ${request.uid}", name: "HLA Admin Notifier");
        await getAllRequests(status: _filter);
      },
    );
  }

  Future<void> uploadResult({
    required HlaTestRequest request,
    required String filePath,
    required String fileName,
    String? summary,
  }) async {
    log("Uploading result for ${request.uid}", name: "HLA Admin Notifier");
    state = const AsyncValue.loading();
    final Either<Failure, HlaTestRequest> response =
        await _hlaRepository.uploadResult(
      request: request,
      filePath: filePath,
      fileName: fileName,
      summary: summary,
    );
    await response.fold(
      (failure) async {
        log(
          "Failed to upload result: ${failure.message}, code: ${failure.code}",
          name: "HLA Admin Notifier",
          stackTrace: failure.stackTrace,
        );
        state = AsyncValue.error(
          failure,
          failure.stackTrace ?? StackTrace.current,
        );
      },
      (_) async {
        log("Uploaded result for ${request.uid}", name: "HLA Admin Notifier");
        await getAllRequests(status: _filter);
      },
    );
  }
}

/// Admin: appointment slot management (create/update/deactivate).
@Riverpod(keepAlive: true)
class HlaAdminSlotsNotifier extends _$HlaAdminSlotsNotifier {
  late final HlaRepository _hlaRepository;

  @override
  FutureOr<List<HlaAppointmentSlot>> build({
    required HlaRepository hlaRepository,
  }) async {
    _hlaRepository = hlaRepository;
    return [];
  }

  Future<void> getAllSlots() async {
    log("Getting all slots", name: "HLA Admin Slots Notifier");
    state = const AsyncValue.loading();
    final Either<Failure, List<HlaAppointmentSlot>> response =
        await _hlaRepository.getAllSlots();
    response.fold(
      (failure) {
        log(
          "Failed to get slots: ${failure.message}, code: ${failure.code}",
          name: "HLA Admin Slots Notifier",
          stackTrace: failure.stackTrace,
        );
        state = AsyncValue.error(
          failure,
          failure.stackTrace ?? StackTrace.current,
        );
      },
      (slots) {
        log("Loaded ${slots.length} slot(s)",
            name: "HLA Admin Slots Notifier");
        state = AsyncValue.data(slots);
      },
    );
  }

  Future<void> putSlot({required HlaAppointmentSlot slot}) async {
    log("Saving slot", name: "HLA Admin Slots Notifier");
    state = const AsyncValue.loading();
    final Either<Failure, HlaAppointmentSlot> response =
        await _hlaRepository.putSlot(slot: slot);
    await response.fold(
      (failure) async {
        log(
          "Failed to save slot: ${failure.message}, code: ${failure.code}",
          name: "HLA Admin Slots Notifier",
          stackTrace: failure.stackTrace,
        );
        state = AsyncValue.error(
          failure,
          failure.stackTrace ?? StackTrace.current,
        );
      },
      (_) async {
        log("Saved slot", name: "HLA Admin Slots Notifier");
        await getAllSlots();
      },
    );
  }
}
