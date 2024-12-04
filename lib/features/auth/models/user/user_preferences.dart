import 'package:circle/objectbox.g.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import '../../../../core/core.dart';

@Entity()
// ignore: must_be_immutable
class UserPreferences extends Equatable {
  UserPreferences({
    this.id = 0,
    required this.uid,
    required this.isFirstTime,
    required this.isOnboarded,
    this.volumeUnit,
    this.lengthUnit,
    this.massUnit,
    this.lastUpdated,
    this.themeMode,
  });

  //Water Preferences
  @Id()
  int id;
  @Unique(onConflict: ConflictStrategy.replace)
  final String? uid;
  final bool isFirstTime;
  final bool isOnboarded;
  //Todo: Probably join all these unit preferences into one class
  ///So you can have for example height unit of cm,
  ///but distance unit of km. all fall under [lengthUnit] but allows for more flexibility
  @Transient()
  Units? volumeUnit;
  @Transient()
  Units? lengthUnit;
  @Transient()
  Units? massUnit;
  @Transient()
  ThemeMode? themeMode;

  //ObjectBox enum converters
  //themMode
  String? get dbThemeMode => themeMode?.name;
  String? get dbVolumeUnit => volumeUnit?.name;
  String? get dbLengthUnit => lengthUnit?.name;
  String? get dbMassUnit => massUnit?.name;

  set dbThemeMode(String? value) {
    if (value != null) {
      themeMode = ThemeMode.values.byName(value);
    } else {
      themeMode == null;
    }
  }

  set dbVolumeUnit(String? value) {
    if (value != null) {
      volumeUnit = Units.values.byName(value);
    } else {
      volumeUnit == null;
    }
  }

  set dbLengthUnit(String? value) {
    if (value != null) {
      lengthUnit = Units.values.byName(value);
    } else {
      lengthUnit == null;
    }
  }

  set dbMassUnit(String? value) {
    if (value != null) {
      massUnit = Units.values.byName(value);
    } else {
      massUnit == null;
    }
  }

  @Property(type: PropertyType.date)
  final DateTime? lastUpdated; //Prolly rename to updated at

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
  }) {
    return UserPreferences(
      id: id,
      uid: uid ?? this.uid,
      volumeUnit: volumeUnit ?? this.volumeUnit,
      massUnit: massUnit ?? this.massUnit,
      lengthUnit: lengthUnit ?? this.lengthUnit,
      isFirstTime: isFirstTime ?? this.isFirstTime,
      isOnboarded: isOnboarded ?? this.isOnboarded,
      themeMode: themeMode ?? this.themeMode,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {
      "uid": uid,
      "volumeUnit": volumeUnit,
      "lengthUnit": lengthUnit,
      "massUnit": massUnit,
      "isFirstTime": isFirstTime,
      "isOnboarded": isOnboarded,
      "themeMode": themeMode?.name,
      "lastUpdated": lastUpdated,
    };
    return data;
  }

  factory UserPreferences.fromMap({required Map<String, dynamic> data}) {
    return UserPreferences(
      uid: "", //Todo: replace this with a target to the user object
      volumeUnit: Units.values.byName(data["volumeUnit"] as String),
      massUnit: Units.values.byName(data["massUnit"] as String),
      lengthUnit: Units.values.byName(data["lengthUnit"] as String),
      isFirstTime: data["isFirstTime"] as bool,
      isOnboarded: data["isOnboarded"] as bool,
      themeMode: ThemeMode.values.byName(data["themeMode"] as String),
      lastUpdated: DateTime.parse(data["lastUpdated"]),
    );
  }
  @Transient()
  static UserPreferences empty = UserPreferences(
    uid: "",
    isOnboarded: false,
    isFirstTime: true,
  );

  @Transient()
  bool get isEmpty => this == UserPreferences.empty;
  @Transient()
  bool get isNotEmpty => this != UserPreferences.empty;

  @override
  String toString() {
    if (this == UserPreferences.empty) {
      return "UserPreferences.empty";
    }
    return super.toString();
  }

  @override
  @Transient()
  bool? get stringify => true;

  @override
  @Transient()
  List<Object?> get props => [
    id,
    uid,
    volumeUnit,
    lengthUnit,
    massUnit,
    themeMode,
    isFirstTime,
    isOnboarded,
    lastUpdated,
  ];
}

class UnitPreferences {
  final Units height;
  final Units weight;
  final Units distance;
  final Units waterVolume;

  UnitPreferences({
    this.height = Units.centimetres,
    this.weight = Units.kilogram,
    this.distance = Units.kilometres,
    this.waterVolume = Units.millilitres,
  });
}
