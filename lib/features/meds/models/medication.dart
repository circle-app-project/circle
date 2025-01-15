import 'dart:convert';

import 'package:circle/core/utils/enums.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';

import 'dose.dart';

//@Entity()
// ignore: must_be_immutable
class Medication extends Equatable {
  /// Todo: Properly Evaluate how to do streaks
  @Id()
  int id;
  final String name;
  final String? description; // Example: "Capsules", "Tablets", etc.
  @Transient()
  Dose dose; // In mg or ml depending on medication
  final int frequencyPerDay; // Example: 1, 2, 3 times per day
  @Transient() //Todo: remove transient
  final List<TimeOfDay> frequencyTimes; // Times of day to take the medication
  final int?
  durationDays; // Number of days to take medication //Todo: Use durationDays to calculate end date
  final bool isPermanent; // True if the medication is ongoing
  /// Whether or not to send a notification reminder to take this medication
  final bool? shouldRemind;
  final String? reminderMessage;
  final String? warningMessage;
  final int? streakCount;
  @Property(type: PropertyType.date)
  final DateTime? startDate;
  @Property(type: PropertyType.date)
  final DateTime? endDate;

  @Transient()
  MedicationType type;
  // final ToMany<MedicationStreak> streaks = ToMany<MedicationStreak>();
  @Transient()
  final Streak? streaks;

  //-----Object Box Type Converters-----//
  String? get dbType => type.name;
  String? get dbDose => jsonEncode(dose.toMap());

  set dbType(String? value) {
    if (value != null) {
      type = MedicationType.values.byName(value);
    } else {
      type = MedicationType.unknown;
    }
  }

  set dbDose(String? value) {
    if (value != null) {
      final Map<String, dynamic> doseMap = jsonDecode(value);
      dose = Dose.fromMap(doseMap);
    } else {
      dose = Dose.empty;
    }
  }

  Medication({
    this.id = 0,
    this.description,
    required this.name,
    required this.type,
    required this.dose,
    required this.frequencyPerDay,
    required this.frequencyTimes,
    required this.durationDays,
    required this.isPermanent,
    this.startDate,
    this.endDate,
    this.shouldRemind,
    this.reminderMessage,
    this.warningMessage,
    this.streakCount,
    this.streaks,
  });

  // Copy With
  Medication copyWith({
    String? name,
    String? description,
    MedicationType? type,
    Dose? dose,
    Units? dosageUnit,
    int? frequencyPerDay,
    List<TimeOfDay>? frequencyTimes,
    int? durationDays,
    bool? isPermanent,
    DateTime? startDate,
    DateTime? endDate,
    List<Streak>? streaks,
    int? streakCount,
    bool? shouldRemind,
    String? notificationMessage,
    String? warningMessage,
  }) {
    Medication medication = Medication(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      dose: dose ?? this.dose,
      frequencyPerDay: frequencyPerDay ?? this.frequencyPerDay,
      frequencyTimes: frequencyTimes ?? this.frequencyTimes,
      durationDays: durationDays ?? this.durationDays,
      isPermanent: isPermanent ?? this.isPermanent,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      warningMessage: warningMessage ?? this.warningMessage,
      shouldRemind: shouldRemind ?? this.shouldRemind,
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
      'dose': dose.toMap(),
      'frequencyPerDay': frequencyPerDay,
      'frequencyTimes': frequencyTimes,
      'durationDays': durationDays,
      'isPermanent': isPermanent,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'warningMessage': warningMessage,
      'shouldRemind': shouldRemind,
      'streakCount': streakCount,
    };
  }

  //-------------From Map----------//
  factory Medication.fromMap(Map<String, dynamic> map) {
    return Medication(
      name: map['name'],
      description: map['description'],
      type: MedicationType.values.byName(map['type']),
      dose: map['dose'],
      frequencyPerDay: map['frequencyPerDay'],
      frequencyTimes:
          List<String>.from(map['frequencyTimes'])
              .map((element) => TimeOfDay.fromDateTime(DateTime.parse(element)))
              .toList(),
      durationDays: map['durationDays'],
      isPermanent: map['isPermanent'],
      startDate:
          map['startDate'] != null ? DateTime.parse(map['startDate']) : null,
      endDate: map['endDate'] != null ? DateTime.parse(map['endDate']) : null,
      warningMessage: map['warningMessages'],
      shouldRemind: map['shouldRemind'],
      streakCount: map['streakCount'],
    );
  }

  //-------------Empty----------//
  @Transient()
  static Medication empty = Medication(
    name: "",
    type: MedicationType.unknown,
    dose: Dose.empty,
    frequencyPerDay: 1,
    frequencyTimes: [TimeOfDay(hour: 0, minute: 0)],
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
    dose,
    frequencyPerDay,
    frequencyTimes,
    durationDays,
    isPermanent,
    startDate,
    endDate,
    streaks,
    streakCount,
    startDate,
    endDate,
    warningMessage,
    shouldRemind,
  ];
}

//Todo: Properly Evaluate how to do streaks
class Streak extends Equatable {
  final int id;
  final DateTime date; // Date the medication was marked as taken
  final bool isCompleted; // True if the medication was taken, false otherwise
  final String? notes; // Any additional notes for the day

  const Streak({
    this.id = 0,
    required this.date,
    required this.isCompleted,
    this.notes,
  });

  // Copy With
  Streak copyWith({DateTime? date, bool? isCompleted, String? notes}) {
    return Streak(
      id: id,
      date: date ?? this.date,
      isCompleted: isCompleted ?? this.isCompleted,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [id, date, isCompleted, notes];
}


