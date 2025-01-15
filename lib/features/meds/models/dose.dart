import 'package:equatable/equatable.dart';

import '../../../core/core.dart';

class Dose extends Equatable {
  final double dose;
  final Units unit;
  const Dose({required this.dose, required this.unit});


  /// Create copy with
  Dose copyWith({double? dose, Units? unit}) {
    return Dose(dose: dose ?? this.dose, unit: unit ?? this.unit);
  }

  /// To Map
  Map<String, dynamic> toMap() {
    return {'dose': dose, 'unit': unit.name};
  }

  factory Dose.fromMap(Map<String, dynamic> map) {
    return Dose(dose: map['dose'], unit: Units.values.byName(map['unit']));
  }

  @override
  bool? get stringify => true;

  @override
  String toString() {
    if (this == Dose.empty) {
      return "Dose.empty";
    } else {
      return super.toString();
    }
  }

  static Dose empty = Dose(dose: 0, unit: Units.milligram);
  bool get isEmpty => this == Dose.empty;
  bool get isNotEmpty => this != Dose.empty;

  @override
  List<Object?> get props => [dose, unit];
}