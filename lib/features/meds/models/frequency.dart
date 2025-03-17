import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum FrequencyType { daily, weekly, monthly, custom }

enum DayOfWeek {
  monday(1),
  tuesday(2),
  wednesday(3),
  thursday(4),
  friday(5),
  saturday(6),
  sunday(7);

  final int weekDay;
  const DayOfWeek(this.weekDay);
}

enum MonthOfYear {
  all(0),
  january(1),
  february(2),
  march(3),
  april(4),
  may(5),
  june(6),
  july(7),
  august(8),
  september(9),
  october(10),
  november(11),
  december(12);

  final int month;

  const MonthOfYear(this.month);
}

/// Represents the frequency of an action, such as taking medication.
///
/// The `Frequency` class supports different types of recurring schedules:
/// - **Daily**: Specifies times of the day and occurrences.
/// - **Weekly**: Specifies days of the week and times for each day.
/// - **Monthly**: Specifies dates of the month and applicable months.
/// - **Custom**: Allows complete customization of the schedule.
///
/// Example usage:
/// ```dart
/// Frequency dailyFrequency = Frequency.daily(
///   times: [TimeOfDay(hour: 8, minute: 0)],
///   timesPerDay: 1,
/// );
///
/// Frequency weeklyFrequency = Frequency.weekly(
///   daysOfWeek: [DayOfWeek.monday, DayOfWeek.friday],
///   times: [TimeOfDay(hour: 8, minute: 0)],
///   timesPerDay: 2,
/// );
/// ```
class Frequency extends Equatable {
  /// The type of frequency, indicating the schedule type.
  final FrequencyType type;

  /// The specific times of the day for the action.
  final List<TimeOfDay>? times;

  /// The number of occurrences per day.
  final int? timesPerDay;

  /// The applicable days of the week (for weekly schedules).
  final List<DayOfWeek>? daysOfWeek;

  /// The applicable months of the year (for monthly schedules).
  final List<MonthOfYear>? monthsOfYear;

  /// The specific date of the month (for monthly schedules).
  final List<int>? datesOfMonth;

  /// Constructor for daily frequency.
  const Frequency.daily({required this.times, required this.timesPerDay})
    : type = FrequencyType.daily,
      daysOfWeek = null,
      monthsOfYear = null,
      datesOfMonth = null;

  /// Constructor for weekly frequency.
  const Frequency.weekly({
    required this.daysOfWeek,
    this.timesPerDay,
    required this.times,
  }) : type = FrequencyType.weekly,
       monthsOfYear = null,
       datesOfMonth = null;

  /// Constructor for monthly frequency.
  const Frequency.monthly({
    required this.datesOfMonth,
    required this.monthsOfYear,
    required this.times,
    required this.timesPerDay,
  }) : type = FrequencyType.monthly,
       daysOfWeek = null;

  /// Constructor for custom frequency.
  const Frequency.custom({
    required this.times,
    this.daysOfWeek,
    this.timesPerDay,
    this.monthsOfYear,
    this.datesOfMonth,
  }) : type = FrequencyType.custom;

  /// Converts the `Frequency` instance into a map for serialization.
  Map<String, dynamic> toMap() {
    return {
      'type': type.name,
      'times':
          times
              ?.map(
                (e) => DateTime(2025, 1, 1, e.hour, e.minute).toIso8601String(),
              )
              .toList(),
      'timesPerDay': timesPerDay,
      'daysOfWeek': daysOfWeek?.map((e) => e.name).toList(),
      'monthsOfYear': monthsOfYear?.map((e) => e.name).toList(),
      'datesOfMonth': datesOfMonth
    };
  }

  /// Factory method to create a `Frequency` instance from a map.
  factory Frequency.fromMap(Map<String, dynamic> map) {
    final FrequencyType type = FrequencyType.values.byName(map['type']);
    switch (type) {
      case FrequencyType.daily:
        return Frequency.daily(
          times:
              (map['times'] as List<dynamic>)
                  .map((e) => TimeOfDay.fromDateTime(DateTime.parse(e)))
                  .toList(),
          timesPerDay: map['timesPerDay'] as int?,
        );
      case FrequencyType.weekly:
        return Frequency.weekly(
          daysOfWeek:
              (map['daysOfWeek'] as List<dynamic>)
                  .map((e) => DayOfWeek.values.byName(e))
                  .toList(),
          timesPerDay: map['timesPerDay'] as int?,
          times:
              (map['times'] as List<dynamic>)
                  .map((e) => TimeOfDay.fromDateTime(DateTime.parse(e)))
                  .toList(),
        );
      case FrequencyType.monthly:
        return Frequency.monthly(
          datesOfMonth: map['dateOfMonth'] as List<int>?,
          monthsOfYear:
              (map['monthsOfYear'] as List<dynamic>)
                  .map((e) => MonthOfYear.values.byName(e))
                  .toList(),
          times:
              (map['times'] as List<dynamic>)
                  .map((e) => TimeOfDay.fromDateTime(DateTime.parse(e)))
                  .toList(),
          timesPerDay: map['timesPerDay'] as int?,
        );
      case FrequencyType.custom:
        return Frequency.custom(
          times:
              (map['times'] as List<dynamic>)
                  .map((e) => TimeOfDay.fromDateTime(DateTime.parse(e)))
                  .toList(),
          daysOfWeek:
              (map['daysOfWeek'] as List<dynamic>?)
                  ?.map((e) => DayOfWeek.values.byName(e))
                  .toList(),
          timesPerDay: map['timesPerDay'] as int?,
          monthsOfYear:
              (map['monthsOfYear'] as List<dynamic>?)
                  ?.map((e) => MonthOfYear.values.byName(e))
                  .toList(),
          datesOfMonth: map['dateOfMonth'] as List<int>?,
        );
    }
  }

  /// Represents an empty frequency.
  static const Frequency empty = Frequency.custom(times: []);

  /// Checks if the frequency is empty.
  bool get isEmpty => this == Frequency.empty;

  /// Checks if the frequency is not empty.
  bool get isNotEmpty => this != Frequency.empty;

  @override
  bool get stringify => true;

  @override
  String toString() {
    return this == Frequency.empty ? "Frequency.empty" : super.toString();
  }

  @override
  List<Object?> get props => [
    type,
    times,
    timesPerDay,
    daysOfWeek,
    monthsOfYear,
    datesOfMonth,
  ];
}
