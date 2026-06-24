import 'dart:developer';

import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/core.dart';
import '../../auth/auth.dart';
import '../hla.dart';

part 'hla_request_form_notifier.g.dart';

final HlaRequestFormNotifierProvider hlaRequestFormNotifierProviderImpl =
    hlaRequestFormNotifierProvider(hlaRepository: hlaRepository);

/// Holds the in-progress new request the patient is building (subjects + slot
/// + consent) and submits it. The self subject is always present and cannot be
/// removed (AC US-2.1, US-2.4).
@Riverpod(keepAlive: true)
class HlaRequestFormNotifier extends _$HlaRequestFormNotifier {
  late final HlaRepository _hlaRepository;

  @override
  FutureOr<HlaRequestFormState> build({
    required HlaRepository hlaRepository,
  }) async {
    _hlaRepository = hlaRepository;
    return const HlaRequestFormState();
  }

  /// Resets the form, seeding the self subject with the patient's name.
  void reset({required String selfName}) {
    state = AsyncValue.data(HlaRequestFormState.initial(selfName: selfName));
  }

  HlaRequestFormState get _current =>
      state.value ?? const HlaRequestFormState();

  void addSubject(HlaSampleSubject subject) {
    final current = _current;
    state = AsyncValue.data(
      current.copyWith(subjects: [...current.subjects, subject]),
    );
  }

  /// Removes a non-self subject at [index]. Self is protected (AC US-2.4).
  void removeSubject(int index) {
    final current = _current;
    if (index < 0 || index >= current.subjects.length) return;
    if (current.subjects[index].isSelf) return;
    final updated = [...current.subjects]..removeAt(index);
    state = AsyncValue.data(current.copyWith(subjects: updated));
  }

  void selectSlot(HlaAppointmentSlot slot) {
    state = AsyncValue.data(_current.copyWith(selectedSlot: slot));
  }

  void setConsent(bool accepted) {
    state = AsyncValue.data(_current.copyWith(consentAccepted: accepted));
  }

  /// Creates the request (status `requested`). On success the created request
  /// is placed on the state so the screen can navigate to its status.
  Future<void> submit({required AppUser user}) async {
    final current = _current;
    log("Submitting HLA request", name: "HLA Request Form Notifier");
    state = const AsyncValue.loading();
    final Either<Failure, HlaTestRequest> response =
        await _hlaRepository.createRequest(
      user: user,
      subjects: current.subjects,
      consentAccepted: current.consentAccepted,
    );
    response.fold(
      (failure) {
        log(
          "Failed to submit: ${failure.message}, code: ${failure.code}",
          name: "HLA Request Form Notifier",
          stackTrace: failure.stackTrace,
        );
        state = AsyncValue.error(
          failure,
          failure.stackTrace ?? StackTrace.current,
        );
      },
      (request) {
        log("Created request ${request.uid}",
            name: "HLA Request Form Notifier");
        state = AsyncValue.data(current.copyWith(submittedRequest: request));
      },
    );
  }
}
