import 'package:flutter/material.dart';

import 'dose.dart';
import 'frequency.dart';
import 'medication.dart';

/// Represents a single scheduled dose of medication that needs to be taken.
///
/// This class combines information from a [Medication] with its dosage and
/// scheduled time to provide a complete representation of an upcoming dose.
class NextDose {
  /// The exact date and time when this dose should be taken.
  final DateTime scheduledTime;

  /// The dosage information (amount and unit).
  final Dose dose;

  /// The medication to which this dose belongs.
  final Medication medication;

  /// Whether this dose has been taken already.
  ///
  /// This can be updated based on activity records.
  bool isTaken = false;
  NextDose({
    required this.scheduledTime,
    required this.dose,
    required this.medication,
  });
}




/// Extension methods for calculating upcoming doses for a medication.
extension MedicationSchedule on Medication {
  /// Generates a list of upcoming doses for this medication within a date range.
  ///
  /// [from] - The start date/time to calculate doses from.
  /// [until] - The end date/time to calculate doses until.
  ///
  /// Returns an empty list if the medication has no frequency or dose information.
  List<NextDose> getUpcomingDoses({
    required DateTime from,
    required DateTime until,
  }) {
    if (frequency == null || dose == null) return [];

    List<NextDose> upcomingDoses = [];

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

    // Mark doses as taken based on activity records
    // _markTakenDoses(upcomingDoses);

    return upcomingDoses;
  }

  /// Generates daily doses within the given date range.
  void _generateDailyDoses(DateTime from, DateTime until, List<NextDose> upcomingDoses) {
    if (frequency?.times == null) return;

    // Add one day to until to include the end date
    final untilPlusOne = until.add(Duration(days: 1));

    for (DateTime day = from; day.isBefore(untilPlusOne); day = day.add(Duration(days: 1))) {
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
            NextDose(
              scheduledTime: doseTime,
              dose: dose!,
              medication: this,
            ),
          );
        }
      }
    }
  }

  /// Generates weekly doses within the given date range.
  void _generateWeeklyDoses(DateTime from, DateTime until, List<NextDose> upcomingDoses) {
    List<DayOfWeek>? daysOfWeek = frequency?.daysOfWeek;

    if (daysOfWeek == null || frequency?.times == null) return;

    // Add one day to until to include the end date
    final untilPlusOne = until.add(Duration(days: 1));

    for (DateTime currentDay = from; currentDay.isBefore(untilPlusOne); currentDay = currentDay.add(Duration(days: 1))) {
      // Check if current day is one of the selected days of week
      final matchingDays = daysOfWeek.where((day) => currentDay.weekday == day.weekDay);

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
              NextDose(
                scheduledTime: doseTime,
                dose: dose!,
                medication: this,
              ),
            );
          }
        }
      }
    }
  }

  /// Generates monthly doses within the given date range.
  void _generateMonthlyDoses(DateTime from, DateTime until, List<NextDose> upcomingDoses) {
    if (frequency?.datesOfMonth == null || frequency?.times == null) return;

    // Add one day to until to include the end date
    final untilPlusOne = until.add(Duration(days: 1));

    for (DateTime currentDate = from; currentDate.isBefore(untilPlusOne); currentDate = currentDate.add(Duration(days: 1))) {
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
              NextDose(
                scheduledTime: doseTime,
                dose: dose!,
                medication: this,
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