import 'package:circle/objectbox.g.dart';

enum AppState { initial, submitting, success, error }

enum AuthState { authenticated, unauthenticated }

enum ButtonType { primary, secondary, outline, text }

enum ChipType { filter, info }

///Todo: might deprecate selected colors
@Deprecated("Might replace the Selector Colors enum type")
enum SelectorColors { purple, blue, green, red, orange }

enum Gender { male, female }

enum Genotype { as, ss, aa, unknown }

enum AppListWheelScrollViewPickerMode { integer, duration, time, decimal, text }

enum MedicationType {
  tabletsPills,
  capsules,
  droplets,
  injections,
  liquids,
  inhaler,
  creamsOrGels,
  custom
}

enum Units {
  ///Mass Measurement Units
  pound(symbol: 'lb'),
  ounce(symbol: 'oz'),
  kilogram(symbol: 'kg'),
  gram(symbol: 'g'),
  milligram(symbol: 'mg'),

  /// Length measurement units
  kilometres(symbol: 'km'),
  metres(symbol: 'm'),
  centimetres(symbol: 'cm'),
  millimetres(symbol: 'mm'),
  miles(symbol: 'mi'),
  inches(symbol: 'in'),
  feet(symbol: 'ft'),

  ///Volume measurement units
  litres(symbol: 'L'),
  millilitres(symbol: 'ml'),
  centilitres(symbol: 'cl'),
  gallons(symbol: 'gal'),

  ///Energy measurement units
  kilocalories(symbol: 'kcal'),
  calories(symbol: 'cal'),
  joules(symbol: 'J'),

  ///Temperature measurement units
  celsius(symbol: 'C'),
  fahrenheit(symbol: 'F'),
  kelvin(symbol: 'K');

  final String symbol;
  const Units({required this.symbol});
}

enum MedsScheduleEndingState {
  ///An Enum to define the states of the Medication repeat ending format.
  never,
  onDate,
  afterNumberOfOccurrences
}

enum MedsHistoryMode {
  ///An Enum to define the medication history modes
  ///can be used on the [MedsHistoryItem] widget
  ///Can be used for the Meds history mode dropdown
  ///Can be used for switching medication history mode
  daily,
  weekly,
  monthly,
  yearly
}

enum RelationType {
  ///An Enum to define the Relation Types
  ///Can be used for selecting Emergency Contact Relations

  brother,
  sister,
  mother,
  father,
  doctor,
  nurse,
  friend,
}
