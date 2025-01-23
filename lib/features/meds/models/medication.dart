import 'dart:convert';

import 'package:circle/core/extensions/date_time_formatter.dart';
import 'package:circle/core/utils/enums.dart';
import 'package:circle/features/meds/models/frequency.dart';
import 'package:circle/features/meds/models/med_activity_record.dart';
import 'package:circle/features/meds/models/streak.dart';
import 'package:equatable/equatable.dart';
import 'package:objectbox/objectbox.dart';

import 'dose.dart';

/// Represents a medication that a user is taking.
///
/// The `Medication` class is used to encapsulate all details related to a specific medication.
/// It includes fields such as the medication name, description, dosage, frequency, duration,
/// start and end dates, and related information like reminders and warnings. Additionally,
/// the class tracks the user's streak of medication adherence through an ObjectBox `ToMany`
/// relationship with the `Streak` entity.
///
/// This class supports persistence using ObjectBox and provides custom type converters
/// for complex fields like `Dose`, `Frequency`, and `MedicationType`. It also includes utility
/// methods for serialization and deserialization.
///
/// Example usage:
/// ```dart
/// final medication = Medication(
///   name: "Vitamin C",
///   type: MedicationType.tablet,
///   dose: Dose(amount: 1, unit: Units.tablet),
///   frequency: Frequency(timesPerDay: 2),
///   durationDays: 30,
///   isPermanent: false,
///   startDate: DateTime.now(),
/// );
/// ```
@Entity()
// ignore: must_be_immutable
class Medication extends Equatable {
  /// The unique identifier for the medication (auto-generated by ObjectBox).
  @Id()
  int id;

  /// The name of the medication (e.g., "Paracetamol").
  final String name;

  /// An optional description of the medication (e.g., "Capsules" or "Tablets").
  final String? description;

  /// The number of days the medication should be taken. Used to calculate the end date.
  final int? durationDays;

  /// Indicates if the medication is ongoing (permanent).
  final bool isPermanent;

  /// Whether or not to send a notification reminder for this medication.
  final bool? shouldRemind;

  /// The message to display in the reminder notification.
  final String? reminderMessage;

  /// A warning message related to the medication (e.g., "Take with food").
  final String? warningMessage;


  /// The start date for taking the medication.
  @Property(type: PropertyType.date)
  final DateTime? startDate;

  /// The end date for taking the medication.
  @Property(type: PropertyType.date)
  final DateTime? endDate;

  /// The dosage details of the medication (e.g., amount and unit).
  @Transient()
  Dose? dose;

  /// The frequency at which the medication should be taken (e.g., 2 times per day).
  @Transient()
  Frequency? frequency;

  /// The type of medication (e.g., tablet, syrup).
  @Transient()
  MedicationType? type;

  @Transient()
  Streak? streak;

  /// A to-many relationship to store streaks of medication adherence.
  final ToMany<MedActivityRecord> activityRecord = ToMany<MedActivityRecord>();

  /// ----- OBJECTBOX TYPE CONVERTERS ----- ///
  ///
  /// Converts `MedicationType` to a database-friendly string.
  String? get dbType => type?.name;

  /// Converts `Dose` to a JSON string for database storage.
  String? get dbDose => jsonEncode(dose?.toMap());

  /// Converts `Frequency` to a JSON string for database storage.
  String? get dbFrequency => jsonEncode(frequency?.toMap());

  /// Converts `Streak` to a JSON string for database storage.
  String? get dbStreak => jsonEncode(streak?.toMap());

  /// Sets the `MedicationType` from a database-friendly string.
  set dbType(String? value) {
    type =
        value != null
            ? MedicationType.values.byName(value)
            : MedicationType.unknown;
  }

  /// Sets the `Dose` from a JSON string.
  set dbDose(String? value) {
    dose = value != null ? Dose.fromMap(jsonDecode(value)) : Dose.empty;
  }

  /// Sets the `Frequency` from a JSON string.
  set dbFrequency(String? value) {
    frequency =
        value != null ? Frequency.fromMap(jsonDecode(value)) : Frequency.empty;
  }

  /// Sets the `Frequency` from a JSON string.
  set dbStreak(String? value) {
    streak =
    value != null ? Streak.fromMap(jsonDecode(value)) : Streak.empty;
  }


  Medication({
    this.id = 0,
    required this.name,
    this.description,
    this.type,
    this.dose,
    this.frequency,
    required this.durationDays,
    required this.isPermanent,
    this.startDate,
    this.endDate,
    this.shouldRemind,
    this.reminderMessage,
    this.warningMessage,
    this.streak,
  });

  /// Returns a copy of the current `Medication` object with updated fields.
  Medication copyWith({
    String? name,
    String? description,
    MedicationType? type,
    Dose? dose,
    Frequency? frequency,
    int? durationDays,
    bool? isPermanent,
    DateTime? startDate,
    DateTime? endDate,
    List<MedActivityRecord>? activityRecord,

    bool? shouldRemind,
    String? reminderMessage,
    String? warningMessage,
  }) {
    final medication = Medication(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      dose: dose ?? this.dose,
      frequency: frequency ?? this.frequency,
      durationDays: durationDays ?? this.durationDays,
      isPermanent: isPermanent ?? this.isPermanent,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      shouldRemind: shouldRemind ?? this.shouldRemind,
      reminderMessage: reminderMessage ?? this.reminderMessage,
      warningMessage: warningMessage ?? this.warningMessage,
    );
    medication.activityRecord.addAll(activityRecord ?? this.activityRecord);
    return medication;
  }

  void putActivityRecord(MedActivityRecord newActivity) {
    /// Check if the streak already exists

    bool activityExists =
        activityRecord.where((s) => s.date.isSameDate(newActivity.date)).isNotEmpty;
    /// If it does, update the existing streak

    /// If it doesn't, add the new streak

    if (activityExists) {
      int index = activityRecord.indexWhere((s) => s.date.isSameDate(newActivity.date));

      /// Get the index of the existing streak
      /// Remove the existing streak
      /// Insert a new streak at that index
      activityRecord.removeAt(index);
      activityRecord.insert(index, newActivity);
    } else {
      activityRecord.add(newActivity);
    }
    activityRecord.add(newActivity);
  }

  /// Serializes the `Medication` object to a `Map`.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': type?.name,
      'dose': dose?.toMap(),
      'frequency': frequency?.toMap(),
      'durationDays': durationDays,
      'isPermanent': isPermanent,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'shouldRemind': shouldRemind,
      'reminderMessage': reminderMessage,
      'warningMessage': warningMessage,
      'streak': streak?.toMap(),
    };
  }

  /// Deserializes a `Medication` object from a `Map`.
  factory Medication.fromMap(Map<String, dynamic> map) {
    return Medication(
      id: map['id'] ?? 0,
      name: map['name'],
      description: map['description'],
      type: MedicationType.values.byName(map['type']),
      dose: Dose.fromMap(map['dose']),
      frequency: Frequency.fromMap(map['frequency']),
      durationDays: map['durationDays'],
      isPermanent: map['isPermanent'],
      startDate:
          map['startDate'] != null ? DateTime.parse(map['startDate']) : null,
      endDate: map['endDate'] != null ? DateTime.parse(map['endDate']) : null,
      shouldRemind: map['shouldRemind'],
      reminderMessage: map['reminderMessage'],
      warningMessage: map['warningMessage'],
      streak: Streak.fromMap(map['streak']),
    );
  }

  /// An empty `Medication` object.
  @Transient()
  static Medication empty = Medication(
    name: "",
    type: MedicationType.unknown,
    dose: Dose.empty,
    frequency: Frequency.empty,
    durationDays: 0,
    isPermanent: false,
  );

  @Transient()
  bool get isEmpty => this == Medication.empty;

  @Transient()
  bool get isNotEmpty => this != Medication.empty;

  @override
  @Transient()
  bool? get stringify => true;

  @override
  String toString() {
    if (this == Medication.empty) {
      return "Medication.empty";
    }
    return super.toString();
  }

  @override
  @Transient()
  List<Object?> get props => [
    id,
    name,
    description,
    type,
    dose,
    frequency,
    durationDays,
    isPermanent,
    startDate,
    endDate,
    activityRecord,
    streak,
    warningMessage,
    shouldRemind,
  ];
}
