
import 'package:equatable/equatable.dart';
import 'package:objectbox/objectbox.dart';

import '../../../core/core.dart';

@Entity()
//ignore: must_be_immutable
class WaterPreferences extends Equatable {
  @Id()
  int id;
  final double? defaultDailyGoal;
  @Transient()
  Units? unit;
  final double? defaultLogValue;

  //Object box type converter
  String? get dbUnit => unit?.symbol;
  set dbUnit(String? value) {
    if (value != null && isNotEmpty) {
      unit = Units.values.byName(value);
    } else {
      unit = null;
    }
  }

  WaterPreferences({
    this.id = 0,
    this.defaultDailyGoal,
    this.unit,
    this.defaultLogValue,
  });

  WaterPreferences.initial({
    this.id = 0,
    this.defaultDailyGoal = 2000,
    this.unit = Units.millilitres,
    this.defaultLogValue = 250,
  });

  WaterPreferences copyWith({
    double? defaultDailyGoal,
    Units? unit,
    double? defaultLogValue,
  }) {
    return WaterPreferences(
      defaultDailyGoal: defaultDailyGoal ?? this.defaultDailyGoal,
      unit: unit ?? this.unit,
      defaultLogValue: defaultLogValue ?? this.defaultLogValue,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'defaultDailyGoal': defaultDailyGoal,
      'unit': unit?.symbol,
      'defaultLogValue': defaultLogValue,
    };
  }

  factory WaterPreferences.fromMap(Map<String, dynamic> data) {
    return WaterPreferences(
      defaultDailyGoal: data["defaultDailyGoal"],
      unit: Units.values.byName(data["unit"]),
      defaultLogValue: data["defaultLogValue"],
    );
  }

  @Transient()
  static WaterPreferences empty = WaterPreferences();
  @Transient()
  bool get isEmpty => this == WaterPreferences.empty;
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
  List<Object?> get props => [defaultDailyGoal, unit, defaultLogValue];
}
