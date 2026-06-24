import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/enums.dart';
import '../models/hla_appointment_slot.dart';
import '../models/hla_test_request.dart';
import '../repositories/hla_admin_repository.dart';
import '../services/auth_service.dart';
import '../services/hla_admin_service.dart';

// ── Wiring ────────────────────────────────────────────────────────────────────

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final hlaAdminServiceProvider =
    Provider<HlaAdminService>((ref) => HlaAdminService());

final hlaAdminRepositoryProvider = Provider<HlaAdminRepository>(
  (ref) => HlaAdminRepository(ref.watch(hlaAdminServiceProvider)),
);

// ── Auth + admin gate ─────────────────────────────────────────────────────────

final authStateProvider = StreamProvider<User?>(
  (ref) => ref.watch(authServiceProvider).authStateChanges(),
);

/// Whether the signed-in user is a provisioned admin (`hla_admins/{uid}`).
/// Resolves false when signed out.
final adminStatusProvider = FutureProvider<bool>((ref) async {
  final User? user = ref.watch(authStateProvider).value;
  if (user == null) return false;
  return ref.watch(hlaAdminRepositoryProvider).isAdmin(user.uid);
});

// ── Requests ──────────────────────────────────────────────────────────────────

class StatusFilter extends Notifier<HlaTestStatus?> {
  @override
  HlaTestStatus? build() => null;
  void set(HlaTestStatus? status) => state = status;
}

final statusFilterProvider =
    NotifierProvider<StatusFilter, HlaTestStatus?>(StatusFilter.new);

/// Realtime queue, reactive to the status filter.
final requestsProvider = StreamProvider<List<HlaTestRequest>>((ref) {
  final HlaTestStatus? filter = ref.watch(statusFilterProvider);
  return ref.watch(hlaAdminRepositoryProvider).watchRequests(status: filter);
});

class SelectedRequestId extends Notifier<String?> {
  @override
  String? build() => null;
  void select(String? id) => state = id;
}

final selectedRequestIdProvider =
    NotifierProvider<SelectedRequestId, String?>(SelectedRequestId.new);

// ── Slots ───────────────────────────────────────────────────────────────────

final slotsProvider = StreamProvider<List<HlaAppointmentSlot>>(
  (ref) => ref.watch(hlaAdminRepositoryProvider).watchSlots(),
);

// ── Mutations ─────────────────────────────────────────────────────────────────

/// Drives the loading/error state of admin write actions. Methods return
/// `true` on success so screens can close dialogs / show confirmations.
class AdminActions extends AsyncNotifier<void> {
  @override
  void build() {}

  HlaAdminRepository get _repo => ref.read(hlaAdminRepositoryProvider);

  Future<bool> _run(Future<void> Function() action) async {
    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(action);
    state = result;
    return !result.hasError;
  }

  Future<bool> advanceStatus({
    required HlaTestRequest request,
    required HlaTestStatus status,
    String? note,
  }) =>
      _run(() => _repo.advanceStatus(
            request: request,
            status: status,
            note: note,
          ));

  Future<bool> uploadResult({
    required HlaTestRequest request,
    required Uint8List bytes,
    required String fileName,
    String? contentType,
    String? summary,
  }) =>
      _run(() => _repo.uploadResult(
            request: request,
            bytes: bytes,
            fileName: fileName,
            contentType: contentType,
            summary: summary,
          ));

  Future<bool> putSlot(HlaAppointmentSlot slot) => _run(() => _repo.putSlot(slot));
}

final adminActionsProvider =
    AsyncNotifierProvider<AdminActions, void>(AdminActions.new);
