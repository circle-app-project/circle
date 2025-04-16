import 'dart:core';

import 'activity_record.dart';

class Streak {
  final List<ActivityRecord> records;
  final ActivityType? type;
  final DateTime? startDate;
  final DateTime? lastCompletedDate;
  final DateTime? endDate;
  final int streakCount;
  final int currentStreakCount;
  final int longestStreakCount;
  final List<DateTime> longestStreakDates;
  final List<DateTime> currentStreakDates;
  final List<DateTime> completedDates;
  final List<DateTime> skippedDates;

  Streak._({
    required this.records,
    this.type,
    this.startDate,
    this.endDate,
    required this.currentStreakCount,
    required this.currentStreakDates,
    required this.lastCompletedDate,
    required this.longestStreakCount,
    required this.longestStreakDates,
    required this.streakCount,
    required this.completedDates,
    required this.skippedDates,
  });

  factory Streak.fromActivityRecord({
    required List<ActivityRecord> records,
    required ActivityType type,
  }) {
    /// Calculate everything necessary

    List<ActivityRecord> relevantRecords = _getRelevantRecords(records, type);
    List<DateTime> completedDates = _getCompletedDates(records, type);
    List<DateTime> skippedDates = _getSkippedDates(records, type);
    List<DateTime> longestStreakDates = _getLongestStreakDates(relevantRecords);
    List<DateTime> currentStreakDates = _getCurrentStreakDates(relevantRecords);

    return Streak._(
      records: relevantRecords,
      type: type,
      startDate: relevantRecords.first.date,
      endDate: relevantRecords.last.date,
      lastCompletedDate: relevantRecords.last.date,
      currentStreakDates: currentStreakDates,
      currentStreakCount: currentStreakDates.length,
      longestStreakDates: longestStreakDates,
      longestStreakCount: longestStreakDates.length,
      completedDates: completedDates,
      skippedDates: skippedDates,
      streakCount: relevantRecords.length,
    );
  }

  //
  // static Streak calculateStreak(
  //   List<ActivityRecord> records,
  //   ActivityType type,
  // ) {
  //   final relevantRecords =
  //   if (relevantRecords.isEmpty) {
  //     return Streak.empty;
  //   } else {
  //     for (int i = 0; i < relevantRecords.length; i++) {
  //       final record = relevantRecords[i];
  //     }
  //   }
  // }

  static List<ActivityRecord> _getRelevantRecords(
    List<ActivityRecord> records,
    ActivityType type,
  ) {
    return records.where((record) => record.activityType == type).toList();
  }

  // void _calculateMetrics() {
  //   _streakCount = records.length;
  //   int currentStreak = 0;
  //   int longestStreak = 0;
  //   List<DateTime> longestStreakDates = [];
  //   DateTime? lastCompletedDate;
  //
  //   for (int i = 0; i < records.length; i++) {
  //     if (records[i].status == CompletionsStatus.completed) {
  //       if (i == 0 ||
  //           records[i - 1].date.add(Duration(days: 1)) == records[i].date) {
  //         currentStreak++;
  //         if (currentStreak > longestStreak) {
  //           longestStreak = currentStreak;
  //           longestStreakDates = [records[i].date];
  //         } else if (currentStreak == longestStreak) {
  //           longestStreakDates.add(records[i].date);
  //         }
  //         lastCompletedDate = records[i].date;
  //       } else {
  //         currentStreak = 1;
  //       }
  //     }
  //   }
  // }
  //
  //
  static List<DateTime> _getCompletedDates(
    List<ActivityRecord> records,
    ActivityType type,
  ) {
    List<DateTime> completedDates = [];
    for (ActivityRecord record in records) {
      if (record.status == CompletionsStatus.completed) {
        completedDates.add(record.date);
      }
    }
    return completedDates;
  }

  static List<DateTime> _getSkippedDates(
    List<ActivityRecord> records,
    ActivityType type,
  ) {
    List<DateTime> skippedDates = [];
    for (ActivityRecord record in records) {
      if (record.status == CompletionsStatus.completed) {
        skippedDates.add(record.date);
      }
    }
    return skippedDates;
  }

  static List<DateTime> _getLongestStreakDates(List<ActivityRecord> records) {
    /// Should skipped days be considered part of the streak???
    List<DateTime> longestStreakDates = [];
    int currentStreakCount = 0;
    int longestStreakCount = 0;

    for (int i = 0; i < records.length; i++) {
      if (records[i].status != CompletionsStatus.missed &&
          records[i].status != CompletionsStatus.pending) {
        longestStreakDates.add(records[i].date);
      }
      if (currentStreakCount > longestStreakCount) {
        longestStreakCount = currentStreakCount;
        longestStreakDates.add(records[i].date);
      } else if (currentStreakCount == longestStreakCount) {
        longestStreakDates.add(records[i].date);
      } else {
        currentStreakCount = 1;
      }
    }
    return longestStreakDates;
  }

  static List<DateTime> _getCurrentStreakDates(List<ActivityRecord> records) {
    /// Should skipped days be considered part of the streak???
    List<DateTime> currentStreakDate = [];

    for (int i = records.length; i < records.length; i--) {
      if (records[i].status == CompletionsStatus.completed) {
        currentStreakDate.add(records[i].date);
      } else {
        /// Breaks the loop as soon as there is a day that is not completed
        break;
      }
    }

    currentStreakDate.sort((a, b) => b.compareTo(a));

    return currentStreakDate;
  }

  Streak copyWith({
    List<ActivityRecord>? records,
    ActivityType? type,
    DateTime? startDate,
    DateTime? endDate,
    List<DateTime>? lastCompletedDate,
    int? currentStreakCount,
    List<DateTime>? currentStreakDates,
    int? longestStreakCount,
    List<DateTime>? longestStreakDates,
    int? streakCount,
    List<DateTime>? completedDates,
    List<DateTime>? skippedDates,
  }) {
    return Streak._(
      records: records ?? this.records,
      type: type ?? this.type,
      startDate: this.startDate,
      endDate: this.endDate,
      lastCompletedDate: this.lastCompletedDate,
      currentStreakCount: this.currentStreakCount,
      currentStreakDates: this.currentStreakDates,
      longestStreakCount: this.longestStreakCount,
      longestStreakDates: this.longestStreakDates,
      streakCount: this.streakCount,
      completedDates: this.completedDates,
      skippedDates: this.skippedDates,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      // 'records': records,
      'type': type?.name,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'lastCompletedDate': lastCompletedDate?.toIso8601String(),
      'currentStreakCount': currentStreakCount,
      'currentStreakDates':
          currentStreakDates.map((e) => e.toIso8601String()).toList(),
      'longestStreakCount': longestStreakCount,
      'longestStreakDates':
          longestStreakDates.map((e) => e.toIso8601String()).toList(),
      'streakCount': streakCount,
      'completedDates': completedDates.map((e) => e.toIso8601String()).toList(),
      'skippedDates': skippedDates.map((e) => e.toIso8601String()).toList(),
    };
  }

  factory Streak.fromMap(Map<String, dynamic> map) {
    return Streak._(
      records: [],
      type: ActivityType.values.byName(map['type']),
      startDate: DateTime.parse(map['startDate']),
      endDate: DateTime.parse(map['endDate']),
      lastCompletedDate: DateTime.parse(map['lastCompletedDate']),
      currentStreakCount: map['currentStreakCount'],
      currentStreakDates:
          map['currentStreakDates'].map((e) => DateTime.parse(e)).toList(),
      longestStreakCount: map['longestStreakCount'],
      longestStreakDates:
          map['longestStreakDates'].map((e) => DateTime.parse(e)).toList(),
      streakCount: map['streakCount'],
      completedDates:
          map['completedDates'].map((e) => DateTime.parse(e)).toList(),
      skippedDates: map['skippedDates'].map((e) => DateTime.parse(e)).toList(),
    );
  }

  static Streak empty = Streak._(
    records: [],
    type: null,
    startDate: null,
    endDate: null,
    lastCompletedDate: null,
    currentStreakCount: 0,
    currentStreakDates: [],
    longestStreakCount: 0,
    longestStreakDates: [],
    streakCount: 0,
    completedDates: [],
    skippedDates: [],
  );
}
