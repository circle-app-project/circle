import 'package:equatable/equatable.dart';
import '../../../core/core.dart';

class WaterLog extends Equatable {
  //final int id;
  final DateTime timestamp;
  final double amount;
  final Units unit;

  const WaterLog({

    required this.timestamp,
    required this.amount,
    this.unit = Units.millilitres,
  });

  WaterLog copyWith({
    DateTime? timestamp,
    double? amount,
    Units? unit,
  }) {
    return WaterLog(
      timestamp: timestamp ?? this.timestamp,
      amount: amount ?? this.amount,
      unit: unit ?? this.unit,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'timestamp': timestamp.toIso8601String(),
      'amount': amount,
      'unit': unit.symbol
    };
  }

  factory WaterLog.fromMap(Map<String, dynamic> map) {
    return WaterLog(
      timestamp: DateTime.parse(map['timestamp']),
      amount: map['amount'] as double,
      unit: Units.values.byName(map['unit'] as String),
    );
  }


  static WaterLog empty = WaterLog(
      timestamp: DateTime(0, 0, 0, 0), amount: 0, unit: Units.millilitres);

  bool get isEmpty => this == WaterLog.empty;

  bool get isNotEmpty => this != WaterLog.empty;
  @override
  String toString() {
    if (this == WaterLog.empty) {
      return 'WaterLog.empty';
    }
    return super.toString();
  }

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [timestamp, amount, unit];
}
