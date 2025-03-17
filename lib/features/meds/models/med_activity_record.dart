import 'dart:convert';

import 'package:objectbox/objectbox.dart';
import 'activity_record.dart';



/// This streak type can be amended with more streaks

/// Represents a daily record of medication adherence.
///
/// The `Streak` class tracks whether a medication was taken on a specific date,
/// along with any additional notes for that day. It is designed to work with
/// ObjectBox for efficient local storage.
///
/// Example usage:
/// ```dart
/// Streak streak = Streak(
///   date: DateTime.now(),
///   isCompleted: true,
///   note: "Took medication on time.",
/// );
/// ```

/// Todo: This method has become so medication specific that I am considering renaming it to something like medication records,
/// And then the streaks just becomes a simple list



@Entity()
// ignore: must_be_immutable
class MedActivityRecord implements ActivityRecord {
  @override
  @Id()
  int id;

  @override
  @Transient()
  Map<String, dynamic>? activityDetails;
  @override
  @Transient()
  CompletionsStatus status;
  @override
  @Transient()
  ActivityType type;
  @override
  @Property(type: PropertyType.date)
  final DateTime? completedAt;
  @override
  @Property(type: PropertyType.date)
  final DateTime  date;
  @override
  final String? note;
  @override
  final String? skipReason;

  /// An ID to the parent activity or object that creates this id
  @override
  final String parentId;


  // ////////// Object Box Type Converters /////////// //
  String get dbType => type.name;
  String get dbStatus => status.name;
  String get dbActivityDetails => jsonEncode(activityDetails);
  set dbType(String value) => type = ActivityType.values.byName(value);
  set dbStatus(String value) => status = CompletionsStatus.values.byName(value);
  set dbActivityDetails(String? value) {
    if (value != null) {
      activityDetails = jsonDecode(value);
    } else {
      activityDetails = {};
    }
  }

  MedActivityRecord({
    this.id = 0,
    required this.date,
    required this.parentId,
    this.status = CompletionsStatus.pending,
    this.note,
    this.skipReason,
    this.completedAt,
    this.activityDetails,
    this.type = ActivityType.medication,
  });

  @override
  MedActivityRecord copyWith({
    DateTime? date,
    DateTime? completedAt,
    CompletionsStatus? status,
    String? skipReason,
    String? note,
  }) {
    return MedActivityRecord(
      id: id,
      parentId: parentId,
      date: date ?? this.date,
      status: status ?? this.status,
      completedAt: completedAt ?? this.completedAt,
      skipReason: skipReason ?? this.skipReason,
      note: note ?? this.note,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'date': date.toIso8601String(),
      'parentId': parentId,
      'status': status.name,
      'note': note,
      'type': type.name,
      'skipReason': skipReason,
      'completedAt': completedAt?.toIso8601String(),
    };
  }


  factory MedActivityRecord.fromMap(Map<String, dynamic> map) {
    ActivityType type = ActivityType.values.byName(map["type"]);
      return MedActivityRecord(
        parentId: map['parentId'],
        date: DateTime.parse(map['date']),
        completedAt: DateTime.parse(map['completedAt']),
        status: CompletionsStatus.values.byName(map['status']),
        skipReason: map['skipReason'] as String?,
        note: map['note'] as String?,
        type: type,
      );

  }

  @override
  @Transient()
  bool? get stringify => true;

  @override
  @Transient()
  List<Object?> get props => [
    date,
    status,
    note,
    skipReason,
    type,
    completedAt,
    activityDetails,
  ];



}


