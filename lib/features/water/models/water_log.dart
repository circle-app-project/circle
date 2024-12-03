import 'package:equatable/equatable.dart';
import 'package:objectbox/objectbox.dart';
import '../../../core/core.dart';

@Entity()
// ignore: must_be_immutable
class WaterLog extends Equatable {
  @Id()
  int id;
  @Property(type: PropertyType.date)
  final DateTime timestamp;
  final double value;
  @Transient()
  Units unit;

  //Object box type converter
  String get dbUnit => unit.symbol;
  set dbUnit(String value) => unit = Units.values.byName(value);

  WaterLog({
    this.id = 0,
    required this.timestamp,
    required this.value,
    this.unit = Units.millilitres,
  });

  WaterLog copyWith({
    DateTime? timestamp,
    double? value,
    Units? unit,
  }) {
    return WaterLog(
      id: id,
      timestamp: timestamp ?? this.timestamp,
      value: value ?? this.value,
      unit: unit ?? this.unit,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'timestamp': timestamp.toIso8601String(),
      'value': value,
      'unit': unit.symbol
    };
  }

  factory WaterLog.fromMap(Map<String, dynamic> map) {
    return WaterLog(
      timestamp: DateTime.parse(map['timestamp']),
      value: map['value'] as double,
      unit: Units.values.byName(map['unit'] as String),
    );
  }

  @Transient()
  static WaterLog empty = WaterLog(
      timestamp: DateTime(0, 0, 0, 0), value: 0, unit: Units.millilitres);
  @Transient()
  bool get isEmpty => this == WaterLog.empty;
  @Transient()
  bool get isNotEmpty => this != WaterLog.empty;
  @override
  String toString() {
    if (this == WaterLog.empty) {
      return 'WaterLog.empty';
    }
    return super.toString();
  }

  @override
  @Transient()
  bool? get stringify => true;

  @override
  @Transient()
  List<Object?> get props => [timestamp, value, unit];
}
