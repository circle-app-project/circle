import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Extension on DateTime to format dates and times.
extension FormatDateTime on DateTime {
  /// Formats the DateTime instance into a string containing both the date and time.
  ///
  /// Example output: "Jan 22, 2025, 3:30 PM".
  ///
  /// The `context` is required to format the time according to the current locale.
  String formatDateWithTime(BuildContext context) {
    final DateFormat dateFormatter = DateFormat.yMMMd();
    final String formattedDate = dateFormatter.format(this);
    final String formattedTime = TimeOfDay.fromDateTime(this).format(context);
    return "$formattedDate, $formattedTime";
  }

  /// Formats the DateTime instance into a string containing only the date.
  ///
  /// Example output: "Jan 22, 2025".
  String formatDate(BuildContext context) {
    final DateFormat dateFormatter = DateFormat.yMMMd();
    final String formattedDate = dateFormatter.format(this);
    return formattedDate;
  }
}

/// Extension on DateTime to compare dates.
extension CompareDateTime on DateTime {
  /// Checks if this DateTime instance is on the same date as [other].
  ///
  /// Compares the year, month, and day components of the two dates.
  ///
  /// Returns `true` if they are on the same date, otherwise `false`.
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  /// Checks if this DateTime instance is in the same month and year as [other].
  ///
  /// Compares the year and month components of the two dates.
  ///
  /// Returns `true` if they are in the same month, otherwise `false`.
  bool isSameMonth(DateTime other) {
    return year == other.year && month == other.month;
  }

  /// Checks if this DateTime instance is in the same year as [other].
  ///
  /// Compares the year component of the two dates.
  ///
  /// Returns `true` if they are in the same year, otherwise `false`.
  bool isSameYear(DateTime other) {
    return year == other.year;
  }

  /// Checks if this DateTime instance is on the same day (day of the month) as [other].
  ///
  /// Note: This only compares the day component and ignores the month and year.
  ///
  /// Returns `true` if they have the same day, otherwise `false`.
  bool isSameDay(DateTime other) {
    return day == other.day;
  }
}