import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../../../core/core.dart';

class UserPreferences extends Equatable {
  final bool isFirstTime;
  final bool isOnboarded;
  final UnitPreferences? unitPreferences;
  final ThemeMode? themeMode;
  final DateTime? lastUpdated; //Todo: Prolly rename to updated at

  const UserPreferences({
    required this.isFirstTime,
    required this.isOnboarded,
    this.lastUpdated,
    this.themeMode = ThemeMode.system,
    this.unitPreferences,
  });

  //------CopyWith---------//
  UserPreferences copyWith({
    final String? uid,
    final Units? volumeUnit,
    final Units? lengthUnit,
    final Units? massUnit,
    final bool? isFirstTime,
    final bool? isOnboarded,
    final ThemeMode? themeMode,
    final DateTime? lastUpdated,
    final UnitPreferences? unitPreferences,
  }) {
    return UserPreferences(
      isFirstTime: isFirstTime ?? this.isFirstTime,
      isOnboarded: isOnboarded ?? this.isOnboarded,
      themeMode: themeMode ?? this.themeMode,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      unitPreferences: unitPreferences ?? this.unitPreferences,
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {
      "isFirstTime": isFirstTime,
      "isOnboarded": isOnboarded,
      "themeMode": themeMode?.name,
      "lastUpdated":
          lastUpdated != null && lastUpdated is DateTime
              ? lastUpdated!.toIso8601String()
              : DateTime.now().toIso8601String(),
      "unitPreferences":
          unitPreferences != null
              ? unitPreferences?.toMap()
              : UnitPreferences.metric().toMap(),
    };
    return data;
  }

  factory UserPreferences.fromMap({required Map<String, dynamic> data}) {
    return UserPreferences(
      isFirstTime: data["isFirstTime"] as bool,
      isOnboarded: data["isOnboarded"] as bool,
      themeMode:
          data["themeMode"] != null
              ? ThemeMode.values.byName(data["themeMode"] as String)
              : null,
      lastUpdated:
          data["lastUpdated"] != null
              ? DateTime.parse(data["lastUpdated"])
              : null,
      unitPreferences:
          data["unitPreferences"] != null
              ? UnitPreferences.fromMap(data: data["unitPreferences"])
              : null,
    );
  }

  static UserPreferences empty = UserPreferences(
    isOnboarded: false,
    isFirstTime: true,
  );

  bool get isEmpty => this == UserPreferences.empty;

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
    lastUpdated,
    unitPreferences,
  ];
}

enum UnitSystem { metric, imperial }

class UnitPreferences extends Equatable {
  final UnitSystem? unitSystem;
  final Units? heightUnit;
  final Units? weightUnit;
  final Units? distanceUnit;
  final Units? waterVolumeUnit;

  const UnitPreferences({
    this.unitSystem,
    this.heightUnit,
    this.weightUnit,
    this.distanceUnit,
    this.waterVolumeUnit,
  });
  const UnitPreferences.metric({
    this.unitSystem = UnitSystem.metric,
    this.heightUnit = Units.centimetres,
    this.weightUnit = Units.kilogram,
    this.distanceUnit = Units.kilometres,
    this.waterVolumeUnit = Units.millilitres,
  });
  const UnitPreferences.imperial({
    this.unitSystem = UnitSystem.imperial,
    this.heightUnit = Units.feet,
    this.weightUnit = Units.pound,
    this.distanceUnit = Units.miles,
    this.waterVolumeUnit = Units.gallons,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {
      "unitSystem": unitSystem?.name,
      "heightUnit": heightUnit?.name,
      "weightUnit": weightUnit?.name,
      "distanceUnit": distanceUnit?.name,
      "waterVolumeUnit": waterVolumeUnit?.name,
    };
    return data;
  }

  factory UnitPreferences.fromMap({required Map<String, dynamic> data}) {
    return UnitPreferences(
      unitSystem:
          data["unitSystem"] != null
              ? UnitSystem.values.byName(data["unitSystem"] as String)
              : null,
      heightUnit:
          data["heightUnit"] != null
              ? Units.values.byName(data["heightUnit"] as String)
              : null,
      weightUnit:
          data["weightUnit"] != null
              ? Units.values.byName(data["weightUnit"] as String)
              : null,
      distanceUnit:
          data["distanceUnit"] != null
              ? Units.values.byName(data["distanceUnit"] as String)
              : null,
      waterVolumeUnit:
          data["waterVolumeUnit"] != null
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

  static const UnitPreferences empty = UnitPreferences();

  bool get isEmpty => this == UnitPreferences.empty;
  bool get isNotEmpty => this != UnitPreferences.empty;

  @override
  String toString() {
    if (this == UserPreferences.empty) {
      return "UnitPreferences.empty";
    }
    return super.toString();
  }

  @override
  bool? get stringify => true;
}
