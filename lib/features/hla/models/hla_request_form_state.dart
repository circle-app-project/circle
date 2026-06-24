import 'package:equatable/equatable.dart';

import 'hla_appointment_slot.dart';
import 'hla_sample_subject.dart';
import 'hla_test_request.dart';

/// In-progress state for building a new HLA request: the panel of subjects,
/// the chosen appointment slot, the consent flag, and (once submitted) the
/// created request. Held by `HlaRequestFormNotifier`.
class HlaRequestFormState extends Equatable {
  final List<HlaSampleSubject> subjects;
  final HlaAppointmentSlot? selectedSlot;
  final bool consentAccepted;

  /// Set once the request has been successfully created, so the screen can
  /// react and navigate.
  final HlaTestRequest? submittedRequest;

  const HlaRequestFormState({
    this.subjects = const [],
    this.selectedSlot,
    this.consentAccepted = false,
    this.submittedRequest,
  });

  /// Fresh form seeded with the patient as the primary subject.
  factory HlaRequestFormState.initial({required String selfName}) {
    return HlaRequestFormState(
      subjects: [HlaSampleSubject.self(name: selfName)],
    );
  }

  HlaRequestFormState copyWith({
    List<HlaSampleSubject>? subjects,
    HlaAppointmentSlot? selectedSlot,
    bool? consentAccepted,
    HlaTestRequest? submittedRequest,
  }) {
    return HlaRequestFormState(
      subjects: subjects ?? this.subjects,
      selectedSlot: selectedSlot ?? this.selectedSlot,
      consentAccepted: consentAccepted ?? this.consentAccepted,
      submittedRequest: submittedRequest ?? this.submittedRequest,
    );
  }

  bool get isSubmitted => submittedRequest != null;

  @override
  List<Object?> get props =>
      [subjects, selectedSlot, consentAccepted, submittedRequest];
}
