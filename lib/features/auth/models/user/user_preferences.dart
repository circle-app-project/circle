import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../../../core/core.dart';

/// [UserPreferences] represents the preferences of a user in the application.
/// It stores settings such as theme mode, onboarding status, unit preferences,
/// and the last time the preferences were updated.
class UserPreferences extends Equatable {
  /// Indicates if the user is opening the app for the first time.
  final bool isFirstTime;

  /// Indicates if the user has completed the onboarding process.
  final bool isOnboarded;

  /// Stores the user's preferences for unit systems (e.g., metric or imperial).
  final UnitPreferences? unitPreferences;

  /// Stores the theme mode preferred by the user (e.g., light, dark, or system default).
  final ThemeMode? themeMode;

  /// Sync Related Fields
  final bool isDeleted;
  final bool isSynced;
  final DateTime? updatedAt;
  final DateTime? createdAt;

  /// Creates an instance of [UserPreferences].
  const UserPreferences({
    required this.isFirstTime,
    required this.isOnboarded,
    this.themeMode = ThemeMode.system,
    this.unitPreferences,
    this.isDeleted = false,
    this.isSynced = false,
    this.updatedAt,
    this.createdAt,
  });

  /// Creates a copy of [UserPreferences] with updated properties.
  UserPreferences copyWith({
    final bool? isFirstTime,
    final bool? isOnboarded,
    final ThemeMode? themeMode,
    final UnitPreferences? unitPreferences,
    final bool? isDeleted,
    final bool? isSynced,
    final DateTime? updatedAt,
  }) {

    return UserPreferences(
      isFirstTime: isFirstTime ?? this.isFirstTime,
      isOnboarded: isOnboarded ?? this.isOnboarded,
      themeMode: themeMode ?? this.themeMode,
      isDeleted: isDeleted ?? this.isDeleted,
      isSynced: isSynced ?? this.isSynced,
      updatedAt: updatedAt ?? this.updatedAt,
      unitPreferences: unitPreferences ?? this.unitPreferences,
    );
  }

  /// Converts [UserPreferences] to a [Map] for serialization.
  Map<String, dynamic> toMap() {
    return {
      "isFirstTime": isFirstTime,
      "isOnboarded": isOnboarded,
      "themeMode": themeMode?.name,
      "isDeleted": isDeleted,
      "isSynced": isSynced,
      "updatedAt": updatedAt?.toIso8601String() ?? DateTime.now().toIso8601String(),
      "createdAt": createdAt?.toIso8601String() ?? DateTime.now().toIso8601String(),
      "unitPreferences": unitPreferences?.toMap() ?? const UnitPreferences.metric().toMap(),
    };
  }

  /// Creates a [UserPreferences] instance from a [Map].
  factory UserPreferences.fromMap({required Map<String, dynamic> data}) {
    return UserPreferences(
      isFirstTime: data["isFirstTime"] as bool,
      isOnboarded: data["isOnboarded"] as bool,
      themeMode: data["themeMode"] != null
          ? ThemeMode.values.byName(data["themeMode"] as String)
          : null,
      isDeleted: data["isDeleted"] as bool,
      isSynced: data["isSynced"] as bool,
      updatedAt: data["updatedAt"] != null ? DateTime.parse(data["updatedAt"]) : null,
      createdAt: data["createdAt"] != null ? DateTime.parse(data["createdAt"]) : null,
      unitPreferences: data["unitPreferences"] != null
          ? UnitPreferences.fromMap(data: data["unitPreferences"])
          : null,
    );
  }

  /// Represents an empty [UserPreferences] object.
  static const UserPreferences empty = UserPreferences(
    isOnboarded: false,
    isFirstTime: true,
  );

  /// Checks if the [UserPreferences] object is empty.
  bool get isEmpty => this == UserPreferences.empty;

  /// Checks if the [UserPreferences] object is not empty.
  bool get isNotEmpty => this != UserPreferences.empty;

  @override
  String toString() {
    if (this == UserPreferences.empty) {
      return "UserPreferences.empty";
    }
    return super.toString();
  }

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [
    themeMode,
    isFirstTime,
    isOnboarded,
    isDeleted,
    isSynced,
    updatedAt,
    createdAt,
    unitPreferences,
  ];
}

/// Enum representing the unit systems (e.g., metric or imperial).
enum UnitSystem { metric, imperial }

/// [UnitPreferences] stores the user's preferences for various measurement units.
class UnitPreferences extends Equatable {
  /// The system of units (metric or imperial).
  final UnitSystem? unitSystem;

  /// The unit of measurement for height.
  final Units? heightUnit;

  /// The unit of measurement for weight.
  final Units? weightUnit;

  /// The unit of measurement for distance.
  final Units? distanceUnit;

  /// The unit of measurement for water volume.
  final Units? waterVolumeUnit;

  /// Creates an instance of [UnitPreferences].
  const UnitPreferences({
    this.unitSystem,
    this.heightUnit,
    this.weightUnit,
    this.distanceUnit,
    this.waterVolumeUnit,
  });

  /// Factory constructor for metric units.
  const UnitPreferences.metric({
    this.unitSystem = UnitSystem.metric,
    this.heightUnit = Units.centimetres,
    this.weightUnit = Units.kilogram,
    this.distanceUnit = Units.kilometres,
    this.waterVolumeUnit = Units.millilitres,
  });

  /// Factory constructor for imperial units.
  const UnitPreferences.imperial({
    this.unitSystem = UnitSystem.imperial,
    this.heightUnit = Units.feet,
    this.weightUnit = Units.pound,
    this.distanceUnit = Units.miles,
    this.waterVolumeUnit = Units.gallons,
  });

  /// Converts [UnitPreferences] to a [Map] for serialization.
  Map<String, dynamic> toMap() {
    return {
      "unitSystem": unitSystem?.name,
      "heightUnit": heightUnit?.name,
      "weightUnit": weightUnit?.name,
      "distanceUnit": distanceUnit?.name,
      "waterVolumeUnit": waterVolumeUnit?.name,
    };
  }

  /// Creates a [UnitPreferences] instance from a [Map].
  factory UnitPreferences.fromMap({required Map<String, dynamic> data}) {
    return UnitPreferences(
      unitSystem: data["unitSystem"] != null
          ? UnitSystem.values.byName(data["unitSystem"] as String)
          : null,
      heightUnit: data["heightUnit"] != null
          ? Units.values.byName(data["heightUnit"] as String)
          : null,
      weightUnit: data["weightUnit"] != null
          ? Units.values.byName(data["weightUnit"] as String)
          : null,
      distanceUnit: data["distanceUnit"] != null
          ? Units.values.byName(data["distanceUnit"] as String)
          : null,
      waterVolumeUnit: data["waterVolumeUnit"] != null
          ? Units.values.byName(data["waterVolumeUnit"] as String)
          : null,
    );
  }

  @override
  List<Object?> get props => [
    unitSystem,
    heightUnit,
    weightUnit,
    distanceUnit,
    waterVolumeUnit,
  ];

  /// Represents an empty [UnitPreferences] object.
  static const UnitPreferences empty = UnitPreferences();

  /// Checks if the [UnitPreferences] object is empty.
  bool get isEmpty => this == UnitPreferences.empty;

  /// Checks if the [UnitPreferences] object is not empty.
  bool get isNotEmpty => this != UnitPreferences.empty;

  @override
  String toString() {
    if (this == UnitPreferences.empty) {
      return "UnitPreferences.empty";
    }
    return super.toString();
  }

  @override
  bool? get stringify => true;
}