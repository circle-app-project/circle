import 'package:equatable/equatable.dart';
import '../../../core/core.dart';

/// Represents a dosage measurement with a specified unit.
///
/// The `Dose` class is used to define the amount of a substance (e.g., medication)
/// and its unit (e.g., milligram, gram). It supports immutability and can be
/// serialized or deserialized for storage and transfer.
///
/// Example usage:
/// ```dart
/// Dose dose = Dose(amount: 500, number:1, unit: Units.milligram);
/// ```
class Dose extends Equatable {
  /// The amount of the substance per serving (per pill)
  final double amount;

  /// The number of servings to take.
  final double number;

  /// The unit of measurement for the dose.
  final Units unit;

  /// Creates a new `Dose` instance.
  ///
  /// - [amount] specifies the amount of the substance.
  /// - [number] specifies the number of servings of the substance.
  /// - [unit] specifies the unit of measurement.
  const Dose({required this.amount, required this.unit, required this.number});

  /// Creates a copy of the current `Dose` instance with updated values.
  ///
  /// - [amount] overrides the existing dose if provided.
  /// - [unit] overrides the existing unit if provided.
  Dose copyWith({double? amount, Units? unit,  double? number}) {
    return Dose(
      amount: amount ?? this.amount,
      unit: unit ?? this.unit,
      number: number ?? this.number
    );
  }

  /// Converts the `Dose` instance into a map for serialization.
  ///
  /// Returns a map with:
  /// - `dose`: The amount of the substance.
  /// - `unit`: The name of the unit (as a string).
  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'unit': unit.name,
      'number': number

    };
  }

  /// Creates a `Dose` instance from a map.
  ///
  /// - [map] must contain:
  ///   - `dose`: A numeric value representing the dose.
  ///   - `unit`: A string representing the unit (must match a valid `Units` enum value).
  factory Dose.fromMap(Map<String, dynamic> map) {
    return Dose(
      amount: map['amount'],
      unit: Units.values.byName(map['unit']),
      number: map['number']
    );
  }

  /// A predefined empty `Dose` instance, useful for default values.
  static const Dose empty = Dose(amount: 0, unit: Units.milligram, number: 0);

  /// Checks if the current `Dose` instance is empty.
  bool get isEmpty => this == Dose.empty;

  /// Checks if the current `Dose` instance is not empty.
  bool get isNotEmpty => this != Dose.empty;

  /// Enables stringification of the `Dose` instance for easier debugging.
  @override
  bool? get stringify => true;

  /// Returns a string representation of the `Dose` instance.
  ///
  /// If the `Dose` is empty, it returns `"Dose.empty"`. Otherwise, it calls the
  /// parent class's `toString()` method.
  @override
  String toString() {
    if (this == Dose.empty) {
      return "Dose.empty";
    } else {
      return super.toString();
    }
  }

  /// Defines the properties used for equality checks.
  ///
  /// Two `Dose` instances are considered equal if their `amount`,`number`, and `unit`
  /// properties match.
  @override
  List<Object?> get props => [amount, unit, number];
}