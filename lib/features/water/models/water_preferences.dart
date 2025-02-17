import 'package:equatable/equatable.dart';
import 'package:objectbox/objectbox.dart';

import '../../../core/core.dart';

/// [WaterPreferences] stores user preferences related to water intake goals and default logging values.
@Entity()
//ignore: must_be_immutable
class WaterPreferences extends Equatable {
  /// Unique identifier for the preferences entry, managed by ObjectBox.
  @Id()
  int id;

  /// The user's default daily water intake goal.
  final double? defaultDailyGoal;

  /// The unit of measurement for water intake (e.g., milliliters, liters).
  @Transient()
  Units? unit;

  /// The default value for each water log entry.
  final double? defaultLogValue;

  // Sync Related Fields
  final bool isDeleted;
  final bool isSynced;
  @PropertyType(PropertyType.date)
  final DateTime? updatedAt;
  @PropertyType(PropertyType.date)
  final DateTime? createdAt;
  /// Converts the [unit] to its string representation for ObjectBox storage.
  String? get dbUnit => unit?.symbol;

  /// Sets the [unit] from its string representation.
  set dbUnit(String? value) {
    if (value != null && isNotEmpty) {
      unit = Units.values.byName(value);
    } else {
      unit = null;
    }
  }

  /// Creates an instance of [WaterPreferences].
  WaterPreferences({
    this.id = 0,
    this.defaultDailyGoal,
    this.unit,
    this.defaultLogValue,
    this.isDeleted = false,
    this.isSynced = false,
    this.updatedAt,
    this.createdAt,
  });

  /// Creates an instance of [WaterPreferences] with default initial values.
  WaterPreferences.initial({
    this.id = 0,
    this.defaultDailyGoal = 2000,
    this.unit = Units.millilitres,
    this.defaultLogValue = 250,
    this.isDeleted = false,
    this.isSynced = false,
    this.updatedAt,
    this.createdAt,
  });

  /// Creates a copy of [WaterPreferences] with updated properties.
  WaterPreferences copyWith({
    double? defaultDailyGoal,
    Units? unit,
    double? defaultLogValue,
    bool? isDeleted,
    bool? isSynced,
    DateTime? updatedAt,
  }) {
    return WaterPreferences(
      id: id,
      defaultDailyGoal: defaultDailyGoal ?? this.defaultDailyGoal,
      unit: unit ?? this.unit,
      defaultLogValue: defaultLogValue ?? this.defaultLogValue,
      isDeleted: isDeleted ?? this.isDeleted,
      isSynced: isSynced ?? this.isSynced,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Converts [WaterPreferences] to a [Map] for serialization.
  Map<String, dynamic> toMap() {
    return {
      'defaultDailyGoal': defaultDailyGoal,
      'unit': unit?.symbol,
      'defaultLogValue': defaultLogValue,
      'isDeleted': isDeleted,
      'isSynced': isSynced,
      'updatedAt': updatedAt?.toUtc().toIso8601String(),
      'createdAt': createdAt?.toUtc().toIso8601String(),
    };
  }

  /// Creates a [WaterPreferences] instance from a [Map].
  factory WaterPreferences.fromMap(Map<String, dynamic> data) {
    return WaterPreferences(
      defaultDailyGoal: data["defaultDailyGoal"],
      unit: Units.values.byName(data["unit"]),
      defaultLogValue: data["defaultLogValue"],
      isDeleted: data["isDeleted"],
      isSynced: data["isSynced"],
      updatedAt: data["updatedAt"] != null ? DateTime.parse(data["updatedAt"]) : null,
      createdAt: data["createdAt"] != null ? DateTime.parse(data["createdAt"]) : null,
    );
  }

  /// Represents an empty [WaterPreferences] object.
  @Transient()
  static WaterPreferences empty = WaterPreferences();

  /// Checks if the [WaterPreferences] object is empty.
  @Transient()
  bool get isEmpty => this == WaterPreferences.empty;

  /// Checks if the [WaterPreferences] object is not empty.
  @Transient()
  bool get isNotEmpty => this != WaterPreferences.empty;

  @override
  String toString() {
    if (this == WaterPreferences.empty) {
      return "WaterPreferences.empty";
    }
    return super.toString();
  }

  @override
  @Transient()
  bool? get stringify => true;

  @override
  @Transient()
  List<Object?> get props => [defaultDailyGoal, unit, defaultLogValue, isDeleted, isSynced, updatedAt, createdAt];
}