import 'package:equatable/equatable.dart';
import 'package:objectbox/objectbox.dart';
import '../../../core/core.dart';

/// [WaterLog] represents a log entry for water consumption.
/// Each entry records the timestamp, the amount of water consumed,
/// and the unit of measurement used.
@Entity()
// ignore: must_be_immutable
class WaterLog extends Equatable {
  /// Unique identifier for the log entry, managed by ObjectBox.
  @Id()
  int id;

  /// The date and time when the water log entry was recorded.
  @Property(type: PropertyType.date)
  final DateTime timestamp;

  /// The amount of water consumed.
  final double value;

  /// The unit of measurement for the water consumed (e.g., milliliters, liters).
  @Transient()
  Units unit;

  /// Converts the [unit] to its string representation for ObjectBox storage.
  String get dbUnit => unit.name;

  /// Sets the [unit] from its string representation.
  set dbUnit(String value) => unit = Units.values.byName(value);

  /// Creates an instance of [WaterLog].
  WaterLog({
    this.id = 0,
    required this.timestamp,
    required this.value,
    this.unit = Units.millilitres,
  });

  /// Creates a copy of [WaterLog] with updated properties.
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

  /// Converts [WaterLog] to a [Map] for serialization.
  Map<String, dynamic> toMap() {
    return {
      'timestamp': timestamp.toIso8601String(),
      'value': value,
      'unit': unit.symbol,
    };
  }

  /// Creates a [WaterLog] instance from a [Map].
  factory WaterLog.fromMap(Map<String, dynamic> map) {
    return WaterLog(
      timestamp: DateTime.parse(map['timestamp']),
      value: map['value'] as double,
      unit: Units.values.byName(map['unit'] as String),
    );
  }

  /// Represents an empty [WaterLog] object.
  @Transient()
  static WaterLog empty = WaterLog(
    timestamp: DateTime(0, 0, 0, 0),
    value: 0,
    unit: Units.millilitres,
  );

  /// Checks if the [WaterLog] object is empty.
  @Transient()
  bool get isEmpty => this == WaterLog.empty;

  /// Checks if the [WaterLog] object is not empty.
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