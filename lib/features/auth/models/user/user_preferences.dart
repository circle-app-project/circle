import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../../../core/core.dart';

class UserPreferences extends Equatable {
  const UserPreferences({
    required this.isFirstTime,
    required this.isOnboarded,
    this.lastUpdated,
    this.themeMode,
    this.unitPreferences,
  });

  //Water Preferences
  final bool isFirstTime;
  final bool isOnboarded;
  //Todo: Probably join all these unit preferences into one class
  ///So you can have for example height unit of cm,
  ///but distance unit of km. all fall under [lengthUnit] but allows for more flexibility
  final UnitPreferences? unitPreferences;
  final ThemeMode? themeMode;
  final DateTime? lastUpdated; //Todo: Prolly rename to updated at

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
      "lastUpdated": lastUpdated,
      "unitPreferences": unitPreferences?.toMap(),
    };
    return data;
  }

  factory UserPreferences.fromMap({required Map<String, dynamic> data}) {
    return UserPreferences(
      isFirstTime: data["isFirstTime"] as bool,
      isOnboarded: data["isOnboarded"] as bool,
      themeMode: ThemeMode.values.byName(data["themeMode"] as String),
      lastUpdated: DateTime.parse(data["lastUpdated"]),
      unitPreferences: UnitPreferences.fromMap(data: data["unitPreferences"]),
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

class UnitPreferences extends Equatable {
  final Units heightUnit;
  final Units weightUnit;
  final Units distanceUnit;
  final Units waterVolumeUnit;

  const UnitPreferences({
    this.heightUnit = Units.centimetres,
    this.weightUnit = Units.kilogram,
    this.distanceUnit = Units.kilometres,
    this.waterVolumeUnit = Units.millilitres,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {
      "heightUnit": heightUnit.name,
      "weightUnit": weightUnit.name,
      "distanceUnit": distanceUnit.name,
      "waterVolumeUnit": waterVolumeUnit.name,
    };
    return data;
  }

  factory UnitPreferences.fromMap({required Map<String, dynamic> data}) {
    return UnitPreferences(
      heightUnit: Units.values.byName(data["heightUnit"] as String),
      weightUnit: Units.values.byName(data["weightUnit"] as String),
      distanceUnit: Units.values.byName(data["distanceUnit"] as String),
      waterVolumeUnit: Units.values.byName(data["waterVolumeUnit"] as String),
    );
  }

  @override
  List<Object?> get props => [
    heightUnit,
    weightUnit,
    distanceUnit,
    waterVolumeUnit,
  ];

  @override
  bool? get stringify => true;
}
