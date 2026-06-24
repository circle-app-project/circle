import 'dart:developer';

import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/core.dart';
import '../../../main.dart';
import '../../auth/auth.dart';
import '../models/hla_appointment_slot.dart';
import '../models/hla_test_request.dart';
import '../repositories/hla_repository.dart';
import '../services/local/hla_local_service.dart';
import '../services/remote/hla_service.dart';

part 'hla_requests_notifier.g.dart';

// ─── Shared singleton wiring (same pattern as the meds/water/health features) ─
//
// NOTE: this mirrors the existing global-singleton DI used across the app so
// the feature stays consistent. The audit flags this pattern app-wide; it is
// intentionally left for the broader DI refactor rather than diverging here.

final HlaService hlaService = HlaService();
final HlaLocalService hlaLocalService = HlaLocalService(store: database.store);
final HlaRepository hlaRepository = HlaRepositoryImpl(
  hlaService: hlaService,
  hlaLocalService: hlaLocalService,
);

final HlaRequestsNotifierProvider hlaRequestsNotifierProviderImpl =
    hlaRequestsNotifierProvider(hlaRepository: hlaRepository);

/// Realtime stream of a single request, keyed by request id — drives the
/// patient status timeline (AC US-4.3). Errors surface as `AsyncError`.
final hlaRequestStreamProvider =
    StreamProvider.family<HlaTestRequest?, String>((ref, requestId) {
  return hlaRepository.streamRequest(requestId: requestId);
});

/// Patient-facing list of the signed-in user's HLA requests.
@Riverpod(keepAlive: true)
class HlaRequestsNotifier extends _$HlaRequestsNotifier {
  late final HlaRepository _hlaRepository;

  @override
  FutureOr<List<HlaTestRequest>> build({
    required HlaRepository hlaRepository,
  }) async {
    _hlaRepository = hlaRepository;
    return [];
  }

  Future<void> getRequests({required AppUser user}) async {
    log("Getting HLA requests", name: "HLA Requests Notifier");
    state = const AsyncValue.loading();
    final Either<Failure, List<HlaTestRequest>> response =
        await _hlaRepository.getRequestsForUser(userId: user.uid);
    response.fold(
      (failure) {
        log(
          "Failed to get requests: ${failure.message}, code: ${failure.code}",
          name: "HLA Requests Notifier",
          stackTrace: failure.stackTrace,
        );
        state = AsyncValue.error(
          failure,
          failure.stackTrace ?? StackTrace.current,
        );
      },
      (requests) {
        log(
          "Loaded ${requests.length} request(s)",
          name: "HLA Requests Notifier",
        );
        state = AsyncValue.data(requests);
      },
    );
  }

  /// Books [slot] for [request], confirming the appointment (status
  /// `bookingConfirmed`). Surfaces "slot no longer available" if it filled
  /// (AC US-3.3).
  Future<void> bookAppointment({
    required HlaTestRequest request,
    required HlaAppointmentSlot slot,
    required AppUser user,
  }) async {
    log("Booking slot for ${request.uid}", name: "HLA Requests Notifier");
    state = const AsyncValue.loading();
    final Either<Failure, HlaTestRequest> response =
        await _hlaRepository.bookAppointment(request: request, slot: slot);
    await response.fold(
      (failure) async {
        log(
          "Failed to book: ${failure.message}, code: ${failure.code}",
          name: "HLA Requests Notifier",
          stackTrace: failure.stackTrace,
        );
        state = AsyncValue.error(
          failure,
          failure.stackTrace ?? StackTrace.current,
        );
      },
      (_) async {
        log("Booked slot for ${request.uid}", name: "HLA Requests Notifier");
        await getRequests(user: user);
      },
    );
  }

  Future<void> cancelRequest({
    required HlaTestRequest request,
    required AppUser user,
  }) async {
    log("Cancelling request ${request.uid}", name: "HLA Requests Notifier");
    state = const AsyncValue.loading();
    final Either<Failure, void> response =
        await _hlaRepository.cancelRequest(request: request);
    await response.fold(
      (failure) async {
        log(
          "Failed to cancel: ${failure.message}, code: ${failure.code}",
          name: "HLA Requests Notifier",
          stackTrace: failure.stackTrace,
        );
        state = AsyncValue.error(
          failure,
          failure.stackTrace ?? StackTrace.current,
        );
      },
      (_) async {
        log("Cancelled ${request.uid}", name: "HLA Requests Notifier");
        await getRequests(user: user);
      },
    );
  }
}
