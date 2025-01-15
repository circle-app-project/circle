import 'package:equatable/equatable.dart';
import '../../../objectbox.g.dart';

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
@Entity()
// ignore: must_be_immutable
class Streak extends Equatable {
  /// The unique identifier for the streak record (managed by ObjectBox).
  @Id()
  int id;

  /// The date the medication was marked as taken.
  @Property(type: PropertyType.date)
  final DateTime date;

  /// Whether the medication was taken (`true`) or missed (`false`).
  final bool isCompleted;

  /// Any additional notes for the day (optional).
  final String? note;

  /// Creates a new `Streak` instance.
  ///
  /// - [id] is optional and defaults to `0`. It is assigned by ObjectBox when
  ///   persisted.
  /// - [date] specifies the date the medication was tracked.
  /// - [isCompleted] indicates whether the medication was taken.
  /// - [note] is an optional description or remark for the day.
  Streak({
    this.id = 0,
    required this.date,
    required this.isCompleted,
    this.note,
  });

  /// Creates a copy of the current `Streak` instance with updated values.
  ///
  /// - [date] overrides the existing date if provided.
  /// - [isCompleted] overrides the existing completion status if provided.
  /// - [note] overrides the existing note if provided.
  Streak copyWith({DateTime? date, bool? isCompleted, String? note}) {
    return Streak(
      id: id,
      date: date ?? this.date,
      isCompleted: isCompleted ?? this.isCompleted,
      note: note ?? this.note,
    );
  }

  /// Converts the `Streak` instance into a map for serialization.
  Map<String, dynamic> toMap() {
    return {
      'date': date.toIso8601String(),
      'isCompleted': isCompleted,
      'note': note,
    };
  }

  /// Creates a `Streak` instance from a map.
  ///
  /// - The `map` parameter must contain `date`, `isCompleted`, and `note` keys.
  /// - The `date` key should be a valid ISO8601 string.
  factory Streak.fromMap(Map<String, dynamic> map) {
    return Streak(
      date: DateTime.parse(map['date']),
      isCompleted: map['isCompleted'],
      note: map['note'],
    );
  }

  /// Defines the properties that will be used for equality checks.
  ///
  /// Two `Streak` instances are considered equal if their `date`, `isCompleted`,
  /// and `note` properties match.
  @override
  List<Object?> get props => [date, isCompleted, note];
}