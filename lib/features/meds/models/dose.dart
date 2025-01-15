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
/// Dose dose = Dose(dose: 500, unit: Units.milligram);
/// ```
class Dose extends Equatable {
  /// The amount of the substance.
  final double dose;

  /// The unit of measurement for the dose.
  final Units unit;

  /// Creates a new `Dose` instance.
  ///
  /// - [dose] specifies the amount of the substance.
  /// - [unit] specifies the unit of measurement.
  const Dose({required this.dose, required this.unit});

  /// Creates a copy of the current `Dose` instance with updated values.
  ///
  /// - [dose] overrides the existing dose if provided.
  /// - [unit] overrides the existing unit if provided.
  Dose copyWith({double? dose, Units? unit}) {
    return Dose(
      dose: dose ?? this.dose,
      unit: unit ?? this.unit,
    );
  }

  /// Converts the `Dose` instance into a map for serialization.
  ///
  /// Returns a map with:
  /// - `dose`: The amount of the substance.
  /// - `unit`: The name of the unit (as a string).
  Map<String, dynamic> toMap() {
    return {
      'dose': dose,
      'unit': unit.name,
    };
  }

  /// Creates a `Dose` instance from a map.
  ///
  /// - [map] must contain:
  ///   - `dose`: A numeric value representing the dose.
  ///   - `unit`: A string representing the unit (must match a valid `Units` enum value).
  factory Dose.fromMap(Map<String, dynamic> map) {
    return Dose(
      dose: map['dose'],
      unit: Units.values.byName(map['unit']),
    );
  }

  /// A predefined empty `Dose` instance, useful for default values.
  static const Dose empty = Dose(dose: 0, unit: Units.milligram);

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
  /// Two `Dose` instances are considered equal if their `dose` and `unit`
  /// properties match.
  @override
  List<Object?> get props => [dose, unit];
}