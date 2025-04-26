import 'dart:convert';
import 'package:circle/features/meds/models/activity_record.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'package:uuid/uuid.dart';

import 'dose.dart';
import 'frequency.dart';
import 'medication.dart';

/// Represents a single scheduled dose of medication that needs to be taken.
///
/// This class combines information from a [Medication] with its dosage and
/// scheduled time to provide a complete representation of an upcoming dose.

@Entity()
//ignore: must_be_immutable
class ScheduledDose extends Equatable implements ActivityRecord {
  @Id()
  @override
  int id;

  @Transient()
  @override
  Map<String, dynamic>? activityDetails;

  @Transient()
  @override
  CompletionsStatus status;

  @Transient()
  @override
  ActivityType activityType;

  @Property(type: PropertyType.date)
  @override
  final DateTime? completedAt;

  /// The exact date and time when this dose should be taken.
  @Property(type: PropertyType.date)
  @override
  final DateTime date;

  @Unique(onConflict: ConflictStrategy.replace)
  final String uid;

  @override
  final String? note;

  @override
  final String? skipReason;

  /// An ID to the parent activity or object that creates this id
  @override
  final String parentId;

  /// The dosage information (amount and unit).
  @Transient()
  Dose dose;

  /// The medication to which this dose belongs.
  @Transient()
  final Medication? medication;

  // Sync Related Fields
  final bool isDeleted;
  final bool isSynced;
  @Property(type: PropertyType.date)
  final DateTime? updatedAt;
  @Property(type: PropertyType.date)
  final DateTime? createdAt;

  // ////////// Object Box Type Converters /////////// //
  String get dbActivityType => activityType.name;
  String get dbStatus => status.name;
  String get dbActivityDetails => jsonEncode(activityDetails);
  String get dbDose => jsonEncode(dose.toMap());

  set dbActivityType(String value) {
    if (value.isNotEmpty) {
      activityType = ActivityType.values.byName(value);
    } else {
      activityType = ActivityType.medication;
    }
  }

  set dbStatus(String value) {
    if (value.isNotEmpty) {
      status = CompletionsStatus.values.byName(value);
    } else {
      status = CompletionsStatus.pending;
    }
  }

  set dbActivityDetails(String? value) {
    if (value != null) {
      activityDetails = jsonDecode(value);
    } else {
      activityDetails = {};
    }
  }

  set dbDose(String? value) {
    if (value != null) {
      dose = Dose.fromMap(jsonDecode(value));
    } else {
      dose = Dose.empty;
    }
  }

  ScheduledDose({
    this.id = 0,
    required this.uid,
    this.dose = Dose.empty,
    this.medication,
    required this.date,
    required this.parentId,
    this.completedAt,
    this.note,
    this.skipReason,
    this.activityDetails,
    this.status = CompletionsStatus.pending,
    this.activityType = ActivityType.medication,
    this.isDeleted = false,
    this.isSynced = false,
    this.updatedAt,
    this.createdAt,
  });

  @override
  ScheduledDose copyWith({
    DateTime? date,
    Dose? dose,
    Medication? medication,
    CompletionsStatus? status,
    DateTime? completedAt,
    String? note,
    String? skipReason,
    String? parentId,
    Map<String, dynamic>? activityDetails,

    bool? isDeleted,
    bool? isSynced,
    DateTime? updatedAt,
  }) {
    return ScheduledDose(
      id: id,
      uid: uid,
      date: date ?? this.date,
      activityDetails: activityDetails ?? this.activityDetails,
      completedAt: completedAt ?? this.completedAt,
      skipReason: skipReason ?? this.skipReason,
      note: note ?? this.note,
      dose: dose ?? this.dose,
      medication: medication ?? this.medication,
      status: status ?? this.status,
      parentId: parentId ?? this.parentId,
      isDeleted: isDeleted ?? this.isDeleted,
      isSynced: isSynced ?? this.isSynced,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uid': uid,
      'parentId': parentId,
      'date': date.toIso8601String(),
      'activityDetails': activityDetails,
      'completedAt': completedAt?.toUtc().toIso8601String(),
      'skipReason': skipReason,
      'note': note,
      'dose': dose.toMap(),
      'medication': medication?.toMap(),
      'status': status.name,
      'activityType': activityType.name,
      'isDeleted': isDeleted,
      'isSynced': isSynced,
      'updatedAt': updatedAt?.toUtc().toIso8601String(),
      'createdAt': createdAt?.toUtc().toIso8601String(),
    };
  }

  factory ScheduledDose.fromMap(Map<String, dynamic> map) {
    ActivityType activityType = ActivityType.values.byName(map["activityType"]);
    return ScheduledDose(
      uid: map['uid'],
      dose: Dose.fromMap(map['dose']),
      parentId: map['parentId'],
      date: DateTime.parse(map['date']),
      completedAt: DateTime.parse(map['completedAt']),
      status: CompletionsStatus.values.byName(map['status']),
      skipReason: map['skipReason'] as String?,
      note: map['note'] as String?,
      activityType: activityType,
      isDeleted: map['isDeleted'],
      isSynced: map['isSynced'],
      updatedAt:
          map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
      createdAt:
          map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
    );
  }

  @override
  @Transient()
  bool? get stringify => true;

  @override
  @Transient()
  List<Object?> get props => [
    dose,
    date,
    medication,
    status,
    completedAt,
    note,
    activityType,
    skipReason,
    parentId,
    activityDetails,
    isDeleted,
    isSynced,
    updatedAt,
    createdAt,
  ];
}

/// Extension methods for calculating upcoming doses for a medication.
extension MedicationSchedule on Medication {
  /// Generates a list of upcoming doses for this medication within a date range.
  ///
  /// [from] - The start date/time to calculate doses from.
  /// [until] - The end date/time to calculate doses until.
  ///
  /// Returns an empty list if the medication has no frequency or dose information.
  List<ScheduledDose> createUpcomingDoseSchedule({
    required DateTime from,
    required DateTime until,
  }) {
    if (frequency == null || dose == null) return [];

    List<ScheduledDose> upcomingDoses = [];

    // Logic to generate dose time based on frequency type
    switch (frequency!.type) {
      case FrequencyType.daily:
        _generateDailyDoses(from, until, upcomingDoses);
        break;

      case FrequencyType.weekly:
        _generateWeeklyDoses(from, until, upcomingDoses);
        break;

      case FrequencyType.monthly:
        _generateMonthlyDoses(from, until, upcomingDoses);
        break;

      case FrequencyType.custom:
        // TODO: Implement custom frequency logic
        return [];
    }

    return upcomingDoses;
  }

  /// Generates daily doses within the given date range.
  void _generateDailyDoses(
    DateTime from,
    DateTime until,
    List<ScheduledDose> upcomingDoses,
  ) {
    if (frequency?.times == null) return;

    // Add one day to until to include the end date
    final untilPlusOne = until.add(const Duration(days: 1));

    for (
      DateTime day = from;
      day.isBefore(untilPlusOne);
      day = day.add(const Duration(days: 1))
    ) {
      for (TimeOfDay time in frequency!.times!) {
        DateTime doseTime = DateTime(
          day.year,
          day.month,
          day.day,
          time.hour,
          time.minute,
        );

        if (doseTime.isAfter(from) && doseTime.isBefore(until)) {
          upcomingDoses.add(
            ScheduledDose(
              uid: const Uuid().v4(),
              date: doseTime,
              dose: dose!,
              medication: this,
              parentId: uid,
              status: CompletionsStatus.pending,
              createdAt: DateTime.now(),
              completedAt: null,
              updatedAt: null,
            ),
          );
        }
      }
    }
  }

  /// Generates weekly doses within the given date range.
  void _generateWeeklyDoses(
    DateTime from,
    DateTime until,
    List<ScheduledDose> upcomingDoses,
  ) {
    List<DayOfWeek>? daysOfWeek = frequency?.daysOfWeek;

    if (daysOfWeek == null || frequency?.times == null) return;

    // Add one day to until to include the end date
    final untilPlusOne = until.add(const Duration(days: 1));

    for (
      DateTime currentDay = from;
      currentDay.isBefore(untilPlusOne);
      currentDay = currentDay.add(const Duration(days: 1))
    ) {
      // Check if current day is one of the selected days of week
      final matchingDays = daysOfWeek.where(
        (day) => currentDay.weekday == day.weekDay,
      );

      if (matchingDays.isNotEmpty) {
        for (TimeOfDay time in frequency!.times!) {
          DateTime doseTime = DateTime(
            currentDay.year,
            currentDay.month,
            currentDay.day,
            time.hour,
            time.minute,
          );

          if (doseTime.isAfter(from) && doseTime.isBefore(until)) {
            upcomingDoses.add(
              ScheduledDose(
                uid: const Uuid().v4(),
                date: doseTime,
                dose: dose!,
                medication: this,
                parentId: uid,
                status: CompletionsStatus.pending,
                createdAt: DateTime.now(),
                completedAt: null,
                updatedAt: null,
              ),
            );
          }
        }
      }
    }
  }

  /// Generates monthly doses within the given date range.
  void _generateMonthlyDoses(
    DateTime from,
    DateTime until,
    List<ScheduledDose> upcomingDoses,
  ) {
    if (frequency?.datesOfMonth == null || frequency?.times == null) return;

    // Add one day to until to include the end date
    final untilPlusOne = until.add(const Duration(days: 1));

    for (
      DateTime currentDate = from;
      currentDate.isBefore(untilPlusOne);
      currentDate = currentDate.add(const Duration(days: 1))
    ) {
      // Check if current day is one of the selected dates of month
      if (frequency!.datesOfMonth!.contains(currentDate.day)) {
        for (TimeOfDay time in frequency!.times!) {
          DateTime doseTime = DateTime(
            currentDate.year,
            currentDate.month,
            currentDate.day,
            time.hour,
            time.minute,
          );

          if (doseTime.isAfter(from) && doseTime.isBefore(until)) {
            upcomingDoses.add(
              ScheduledDose(
                uid: const Uuid().v4(),
                date: doseTime,
                dose: dose!,
                medication: this,
                parentId: uid,
                status: CompletionsStatus.pending,
                createdAt: DateTime.now(),
                completedAt: null,
                updatedAt: null,
              ),
            );
          }
        }
      }
    }
  }

  /// Marks doses as taken based on existing activity records.
  // void _markTakenDoses(List<NextDose> upcomingDoses) {
  //   // Skip if no activity records
  //   if (activityRecord.isEmpty) return;
  //
  //   for (var dose in upcomingDoses) {
  //     // Check if any activity record matches this dose's time
  //     for (var record in activityRecord) {
  //       // Using a small time window to account for slight differences
  //       final timeDifference = dose.scheduledTime.difference(record.).inMinutes.abs();
  //
  //       if (timeDifference < 5) { // Within 5 minutes
  //         dose.isTaken = true;
  //         break;
  //       }
  //     }
  //   }
  // }
}
