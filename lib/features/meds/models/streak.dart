import 'package:equatable/equatable.dart';
import 'package:objectbox/objectbox.dart';

enum StreakType { medication, water }

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
@Entity()
// ignore: must_be_immutable
class Streak extends Equatable {
  @Id()
  int id;
  @Property(type: PropertyType.date)
  final DateTime date;
  final bool isCompleted;
  final bool? isSkipped;
  final String? note;
  @Transient()
  StreakType type;

  // ////////// Object Box Type Converters /////////// //
  String get dbType => type.name;
  set dbType(String value) => type = StreakType.values.byName(value);

  Streak({
    this.id = 0,
    required this.date,
    required this.isCompleted,
    this.isSkipped = false,
    this.note,
    this.type = StreakType.medication,
  });

  factory Streak.medication({
    int id = 0,
    required DateTime date,
    required bool isCompleted,
    bool? isSkipped = false,
    String? note,
  }) {
    return Streak(
      id: id,
      date: date,
      isCompleted: isCompleted,
      isSkipped: isSkipped,
      note: note,
      type: StreakType.medication,
    );
  }

  factory Streak.water({
    int id = 0,
    required DateTime date,
    required bool isCompleted,
    String? note,
  }) {
    return Streak(
      id: id,
      date: date,
      isCompleted: isCompleted,
      isSkipped: null,
      note: note,
      type: StreakType.water,
    );
  }

  Streak copyWith({
    DateTime? date,
    bool? isCompleted,
    String? note,
    bool? isSkipped,
  }) {
    if (type == StreakType.medication) {
      return Streak.medication(
        id: id,
        date: date ?? this.date,
        isCompleted: isCompleted ?? this.isCompleted,
        note: note ?? this.note,
        isSkipped: isSkipped ?? this.isSkipped,
      );
    } else {
      return Streak.water(
        id: id,
        date: date ?? this.date,
        isCompleted: isCompleted ?? this.isCompleted,
        note: note ?? this.note,
      );
    }
  }

  /// Converts the `Streak` instance into a map for serialization.
  Map<String, dynamic> toMap() {
    return {
      'date': date.toIso8601String(),
      'isCompleted': isCompleted,
      'note': note,
      'type': type.name,
      'isSkipped': isSkipped,
    };
  }

  /// Creates a `Streak` instance from a map.
  ///
  /// - The `map` parameter must contain `date`, `isCompleted`, and `note` keys.
  /// - The `date` key should be a valid ISO8601 string.
  factory Streak.fromMap(Map<String, dynamic> map) {
    StreakType type = StreakType.values.byName(map["type"]);

    if (type == StreakType.medication) {
      return Streak.medication(
        date: DateTime.parse(map['date']),
        isCompleted: map['isCompleted'],
        isSkipped: map['isSkipped'],
        note: map['note'],
      );
    } else {
      return Streak.water(
        date: DateTime.parse(map['date']),
        isCompleted: map['isCompleted'],
        note: map['note'],
      );
    }
  }


  @override
  @Transient()
  List<Object?> get props => [date, isCompleted, note];
}
