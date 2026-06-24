import 'package:flutter/material.dart';

/// The stages of an HLA typing request's journey. Mirrors the mobile app's
/// `HlaTestStatus` exactly — the enum **names** are the values persisted in
/// Firestore, so they must stay in sync across both apps.
///
/// Declaration order is the canonical forward order; [cancelled] sits outside
/// the sequence.
enum HlaTestStatus {
  requested('Sample requested', Icons.note_add_outlined),
  bookingConfirmed('Appointment booked', Icons.event_available_outlined),
  collected('Sample collected', Icons.science_outlined),
  sentForTesting('Sample sent for testing', Icons.inventory_2_outlined),
  inTransit('Sample in transit', Icons.local_shipping_outlined),
  tested('Sample tested', Icons.bolt_outlined),
  resultsProcessing('Results processing', Icons.hourglass_top_outlined),
  resultsAvailable('Results available', Icons.task_outlined),
  resultsSent('Results sent', Icons.check_circle_outline),
  cancelled('Cancelled', Icons.cancel_outlined);

  const HlaTestStatus(this.label, this.icon);

  final String label;
  final IconData icon;
}

extension HlaTestStatusX on HlaTestStatus {
  /// Position in the forward sequence; -1 for [cancelled].
  int get order =>
      this == HlaTestStatus.cancelled ? -1 : HlaTestStatus.values.indexOf(this);

  bool get isCancelledState => this == HlaTestStatus.cancelled;

  bool get isTerminal =>
      this == HlaTestStatus.cancelled || this == HlaTestStatus.resultsSent;

  /// Next status in the forward sequence, or null at/after the end.
  HlaTestStatus? get next {
    if (isTerminal) return null;
    final int nextIndex = order + 1;
    // resultsSent is the last forward value; cancelled is excluded.
    if (nextIndex >= HlaTestStatus.values.length - 1) {
      return HlaTestStatus.resultsSent;
    }
    return HlaTestStatus.values[nextIndex];
  }

  bool get isResultsReady =>
      !isCancelledState && order >= HlaTestStatus.resultsAvailable.order;
}

/// Relationship of a sample subject to the requesting patient. Names match the
/// mobile app's `HlaSubjectRelation`.
enum HlaSubjectRelation {
  self('Self'),
  sibling('Sibling'),
  parent('Parent'),
  child('Child'),
  relative('Relative'),
  potentialDonor('Potential donor'),
  other('Other');

  const HlaSubjectRelation(this.label);
  final String label;

  static HlaSubjectRelation fromName(String? name) {
    return HlaSubjectRelation.values.firstWhere(
      (r) => r.name == name,
      orElse: () => HlaSubjectRelation.other,
    );
  }
}
