import 'package:circle/core/enums.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';

//@Entity()
// ignore: must_be_immutable
class Medication extends Equatable {
  /// Todo: Properly Evaluate how to do streaks
  @Id()
  int id;
  final String name;
  final String? description;// Example: "Capsules", "Tablets", etc.
  final double dosage; // In mg or ml depending on medication
  final int frequencyPerDay; // Example: 1, 2, 3 times per day
  @Transient() //Todo: remove transient
  final List<TimeOfDay> times; // Times of day to take the medication
  final int durationDays; // Number of days to take medication
  final bool isPermanent; // True if the medication is ongoing
  final bool? reminderEnabled;
  @Transient() //Todo: remove transient
  final TimeOfDay? reminderTime;
  final bool? notificationEnabled;
  final String? notificationMessage;
  final String? warningMessages;
  final int? streakCount;
  @Property(type: PropertyType.date)
  final DateTime? startDate;
  @Property(type: PropertyType.date)
  final DateTime? endDate;
  @Transient()
  Units dosageUnit;
  @Transient()
  MedicationType type;
 // final ToMany<MedicationStreak> streaks = ToMany<MedicationStreak>();
  @Transient()
  final MedicationStreak? streaks;

  //-----Object Box Type Converters-----//
  String? get dbType => type.name;
  String? get dbDosageUnit => dosageUnit.name;

  set dbType(String? value) {
    if (value != null) {
      type = MedicationType.values.byName(value);
    } else {
      type = MedicationType.unknown;
    }
  }

  set dbDosageUnit(String? value) {
    if (value != null) {
      dosageUnit = Units.values.byName(value);
    } else {
      dosageUnit = Units.milligram;
    }
  }

  Medication({
    this.id = 0,
    this.description,
    required this.name,
    required this.type,
    required this.dosage,
    required this.dosageUnit,
    required this.frequencyPerDay,
    required this.times,
    required this.durationDays,
    required this.isPermanent,
    this.startDate,
    this.endDate,
    this.reminderEnabled,
    this.reminderTime,
    this.notificationEnabled,
    this.notificationMessage,
    this.warningMessages,
    this.streakCount,
    this.streaks,
  });

  // Copy With
  Medication copyWith({
    String? name,
    String? description,
    MedicationType? type,
    double? dosage,
    Units? dosageUnit,
    int? frequencyPerDay,
    List<TimeOfDay>? times,
    int? durationDays,
    bool? isPermanent,
    DateTime? startDate,
    DateTime? endDate,
    List<MedicationStreak>? streaks,
    int? streakCount,
    bool? reminderEnabled,
    TimeOfDay? reminderTime,
    bool? notificationEnabled,
    String? notificationMessage,
    String? warningMessages,
  }) {
    Medication medication = Medication(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      dosage: dosage ?? this.dosage,
      dosageUnit: dosageUnit ?? this.dosageUnit,
      frequencyPerDay: frequencyPerDay ?? this.frequencyPerDay,
      times: times ?? this.times,
      durationDays: durationDays ?? this.durationDays,
      isPermanent: isPermanent ?? this.isPermanent,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      warningMessages: warningMessages ?? this.warningMessages,
      notificationEnabled: notificationEnabled ?? this.notificationEnabled,
      reminderTime: reminderTime ?? this.reminderTime,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      streakCount: streakCount ?? this.streakCount,
    );

//    medication.streaks.addAll(streaks ?? this.streaks);
    return medication;
  }

  //-------------To Map----------//
  Map<String, dynamic> toMap() {
    return {
      'id': id, //Todo: Should I save this id??
      'name': name,
      'description': description,
      'type': type,
      'dosage': dosage,
      'dosageUnit': dosageUnit,
      'frequencyPerDay': frequencyPerDay,
      'times': times,
      'durationDays': durationDays,
      'isPermanent': isPermanent,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'warningMessages': warningMessages,
      'notificationEnabled': notificationEnabled,
      'reminderTime': reminderTime,
      'reminderEnabled': reminderEnabled,
      'streakCount': streakCount,
    };
  }

  //-------------From Map----------//
  factory Medication.fromMap(Map<String, dynamic> map) {
    return Medication(
      name: map['name'],
      description: map['description'],
      type: MedicationType.values.byName(map['type']),
      dosage: map['dosage'],
      dosageUnit: map['dosageUnit'],
      frequencyPerDay: map['frequencyPerDay'],
      times:
          List<String>.from(map['times'])
              .map((element) => TimeOfDay.fromDateTime(DateTime.parse(element)))
              .toList(),
      durationDays: map['durationDays'],
      isPermanent: map['isPermanent'],
      startDate:
          map['startDate'] != null ? DateTime.parse(map['startDate']) : null,
      endDate: map['endDate'] != null ? DateTime.parse(map['endDate']) : null,
      warningMessages: map['warningMessages'],
      notificationEnabled: map['notificationEnabled'],
      reminderTime: map['reminderTime'],
      reminderEnabled: map['reminderEnabled'],
      streakCount: map['streakCount'],
    );
  }

  //-------------Empty----------//
  @Transient()
  static Medication empty = Medication(
    name: "",
    type: MedicationType.unknown,
    dosage: 0,
    dosageUnit: Units.milligram,
    frequencyPerDay: 1,
    times: [TimeOfDay(hour: 0, minute: 0)],
    durationDays: 3,
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
    dosage,
    dosageUnit,
    frequencyPerDay,
    times,
    durationDays,
    isPermanent,
    startDate,
    endDate,
    streaks,
    streakCount,
    startDate,
    endDate,
    warningMessages,
    notificationEnabled,
    reminderTime,
    reminderEnabled,
  ];
}


//Todo: Properly Evaluate how to do streaks

class MedicationStreak
    extends Equatable {
  final int id;
  final DateTime date; // Date the medication was marked as taken
  final bool taken; // True if the medication was taken, false otherwise
  final String? notes; // Any additional notes for the day

  const MedicationStreak({
    this.id = 0,
    required this.date,
    required this.taken,
    this.notes,
  });

  // Copy With
  MedicationStreak copyWith({DateTime? date, bool? taken, String? notes}) {
    return MedicationStreak(
      id: id,
      date: date ?? this.date,
      taken: taken ?? this.taken,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [id, date, taken, notes];
}
