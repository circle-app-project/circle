import 'package:circle/objectbox.g.dart';
import 'package:equatable/equatable.dart';

enum ActivityType { medication, water }

enum CompletionsStatus { pending, completed, missed, skipped }
// ignore: must_be_immutable
abstract class ActivityRecord extends Equatable {
  @Id()
  int id;
  final DateTime date;
  final String? note;
  final String? skipReason;
  ActivityType type;
  CompletionsStatus status;
  final DateTime? completedAt;
  final String? parentId;
  Map<String, dynamic>? activityDetails;

  ActivityRecord({
    this.id = 0,
    required this.date,
    required this.status,
    required this.type,
    this.parentId,
    this.note,
    this.skipReason,
    this.completedAt,
    this.activityDetails,
  });

  ActivityRecord copyWith();
  Map<String, dynamic> toMap();

  @override
  List<Object?> get props => [
    date,
    status,
    note,
    skipReason,
    type,
    completedAt,
    parentId,
    activityDetails,
  ];
}
