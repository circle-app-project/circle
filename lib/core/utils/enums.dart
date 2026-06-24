import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:hugeicons/hugeicons.dart';

enum AppState { initial, submitting, success, error }

enum AuthState { authenticated, unauthenticated }

enum ButtonType { primary, secondary, outline, text }

enum ChipType { filter, info }

///Todo: might deprecate selected colors
@Deprecated("Might replace the Selector Colors enum type")
enum SelectorColors { purple, blue, green, red, orange }

enum Gender { male, female }

enum Genotype { as, ss, aa, unknown }

/// Distinguishes patients from Circle staff. Drives the admin UI gate and is
/// enforced server-side by Firestore rules. Defaults to [patient]; admin
/// accounts are provisioned manually for the MVP (see HLA feature plan §7).
enum UserRole { patient, admin }

/// The relationship of a sample subject to the requesting patient, used when
/// building the cross-match panel for an HLA typing request.
enum HlaSubjectRelation {
  self(label: "Self"),
  sibling(label: "Sibling"),
  parent(label: "Parent"),
  child(label: "Child"),
  relative(label: "Relative"),
  potentialDonor(label: "Potential donor"),
  other(label: "Other");

  final String label;
  const HlaSubjectRelation({required this.label});
}

/// The stages of an HLA typing request's journey, from the initial request
/// through to results being delivered. Each value carries a patient-facing
/// [label], a short [description] for the timeline, and an [icon] so chips and
/// the status timeline render consistently (mirrors [MedicationType]).
///
/// The declaration order is the canonical forward order used to compute
/// "completed vs upcoming" stages and to validate admin transitions.
/// [cancelled] is terminal and sits outside the forward sequence.
enum HlaTestStatus {
  requested(
    label: "Sample requested",
    description: "Your test request has been created.",
    icon: FluentIcons.document_add_24_regular,
  ),
  bookingConfirmed(
    label: "Appointment booked",
    description: "Your collection appointment is confirmed.",
    icon: FluentIcons.calendar_checkmark_24_regular,
  ),
  collected(
    label: "Sample collected",
    description: "Your sample has been collected.",
    icon: FluentIcons.beaker_24_regular,
  ),
  sentForTesting(
    label: "Sample sent for testing",
    description: "Your sample is being prepared for the lab.",
    icon: FluentIcons.box_24_regular,
  ),
  inTransit(
    label: "Sample in transit",
    description: "Your sample is on its way to the testing lab.",
    icon: FluentIcons.vehicle_truck_24_regular,
  ),
  tested(
    label: "Sample tested",
    description: "The lab has completed analysis of your sample.",
    icon: FluentIcons.flash_24_regular,
  ),
  resultsProcessing(
    label: "Results processing",
    description: "Your results are being prepared.",
    icon: FluentIcons.hourglass_24_regular,
  ),
  resultsAvailable(
    label: "Results available",
    description: "Your results have been uploaded.",
    icon: FluentIcons.document_checkmark_24_regular,
  ),
  resultsSent(
    label: "Results sent",
    description: "Your results have been delivered to you.",
    icon: FluentIcons.checkmark_circle_24_regular,
  ),
  cancelled(
    label: "Cancelled",
    description: "This request was cancelled.",
    icon: FluentIcons.dismiss_circle_24_regular,
  );

  final String label;
  final String description;
  final IconData icon;
  const HlaTestStatus({
    required this.label,
    required this.description,
    required this.icon,
  });
}

/// Helpers for reasoning about the HLA status journey. Kept as an extension so
/// the enum declaration stays declarative.
extension HlaTestStatusX on HlaTestStatus {
  /// Position in the canonical forward sequence. [HlaTestStatus.cancelled] is
  /// terminal and reported as -1 (it is not part of the forward order).
  int get order =>
      this == HlaTestStatus.cancelled ? -1 : HlaTestStatus.values.indexOf(this);

  /// Terminal states cannot transition further.
  bool get isTerminal =>
      this == HlaTestStatus.cancelled || this == HlaTestStatus.resultsSent;

  /// The next status in the forward sequence, or null at the end / for
  /// terminal states.
  HlaTestStatus? get next {
    if (isTerminal || this == HlaTestStatus.cancelled) return null;
    final int nextIndex = order + 1;
    // The last forward value is resultsSent; cancelled is excluded.
    if (nextIndex >= HlaTestStatus.values.length - 1) {
      return HlaTestStatus.resultsSent;
    }
    return HlaTestStatus.values[nextIndex];
  }

  /// Whether results are ready to view (results uploaded or delivered).
  bool get isResultsReady =>
      !isCancelledState && order >= HlaTestStatus.resultsAvailable.order;

  bool get isCancelledState => this == HlaTestStatus.cancelled;

  /// Whether a patient is still allowed to cancel at this stage (before the
  /// sample has been collected).
  bool get isPatientCancellable =>
      this == HlaTestStatus.requested ||
      this == HlaTestStatus.bookingConfirmed;
}

enum AppListWheelScrollViewPickerMode { integer, duration, time, decimal, text }

enum MedicationType {
  tablet(
    icon: FluentIcons.pill_24_regular,
    iconFilled: FluentIcons.pill_24_filled,
    iconPath: "assets/svg/tablet.svg",
    label: 'Tablet',
  ),
  capsule(
    icon: FluentIcons.pill_24_regular,
    iconFilled: FluentIcons.pill_24_filled,
    label: "Capsules",
  ),
  chewable(
    icon: FluentIcons.pill_24_regular,
    iconFilled: FluentIcons.pill_24_filled,
    iconPath: "assets/svg/tablet.svg",
    label: 'Chewable',
  ),
  droplet(
    icon: HugeIcons.strokeRoundedDroplet,
    iconFilled: FluentIcons.drop_16_filled,
    iconPath: "assets/svg/droplet-alt.svg",
    iconPathFilled: "assets/svg/droplet-alt-filled.svg",
    label: "Droplets",
  ),

  injection(
    icon: FluentIcons.syringe_24_regular,
    iconFilled: FluentIcons.syringe_24_filled,
    label: "Injection",
  ),
  liquid(
    icon: HugeIcons.strokeRoundedDroplet,
    iconFilled: HugeIcons.strokeRoundedDroplet,
    iconPath: "assets/svg/droplet-alt.svg",
    iconPathFilled: "assets/svg/droplet-alt-filled.svg",
    label: "Liquid",
  ),
  inhaler(
    icon: FluentIcons.drink_bottle_20_regular,
    iconFilled: FluentIcons.drink_bottle_20_filled,
    label: "Inhaler",
  ),
 creamsAndOintment(
    icon: FluentIcons.stream_24_regular,
    iconFilled: FluentIcons.stream_24_filled,
    label: "Creams & Ointments",
  ),
  unknown(
    icon: FluentIcons.pill_24_regular,
    iconFilled: FluentIcons.pill_24_filled,
    label: 'Unknown',
  );
  // custom(
  //   icon: FluentIcons.add_24_regular,
  //   iconFilled: FluentIcons.add_24_filled,
  //   label: "Custom",
  // );


  final String label;
  final IconData? icon;
  final IconData? iconFilled;
  final String? iconPath;
  final String? iconPathFilled;
  const MedicationType({
    required this.label,
    this.icon,
    this.iconPath,
    this.iconFilled,
    this.iconPathFilled,
  });
}

enum Units {
  ///Mass Measurement Units
  pound(symbol: 'lb'),
  ounce(symbol: 'oz'),
  kilogram(symbol: 'kg'),
  gram(symbol: 'g'),
  milligram(symbol: 'mg'),

  /// Length measurement units
  kilometres(symbol: 'km'),
  metres(symbol: 'm'),
  centimetres(symbol: 'cm'),
  millimetres(symbol: 'mm'),
  miles(symbol: 'mi'),
  inches(symbol: 'in'),
  feet(symbol: 'ft'),

  ///Volume measurement units
  litres(symbol: 'L'),
  millilitres(symbol: 'ml'),
  centilitres(symbol: 'cl'),
  gallons(symbol: 'gal'),
  droplet(symbol: 'droplet'),

  ///Energy measurement units
  kilocalories(symbol: 'kcal'),
  calories(symbol: 'cal'),
  joules(symbol: 'J'),

  ///Temperature measurement units
  celsius(symbol: 'C'),
  fahrenheit(symbol: 'F'),
  kelvin(symbol: 'K');

  final String symbol;
  const Units({required this.symbol});
}

enum MedsScheduleEndingState {
  ///An Enum to define the states of the Medication repeat ending format.
  never,
  onDate,
  afterNumberOfOccurrences,
}

enum MedsHistoryMode {
  ///An Enum to define the medication history modes
  ///can be used on the [MedsHistoryItem] widget
  ///Can be used for the Meds history mode dropdown
  ///Can be used for switching medication history mode
  daily,
  weekly,
  monthly,
  yearly,
}

enum RelationType {
  ///An Enum to define the Relation Types
  ///Can be used for selecting Emergency Contact Relations
  brother,
  sister,
  mother,
  father,
  doctor,
  nurse,
  friend,
}
