import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:hugeicons/hugeicons.dart';

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
  tablet(
    icon: FluentIcons.pill_24_regular,
    iconFilled: FluentIcons.pill_24_filled,
    iconPath: "assets/svg/tablet.svg",
    label: 'Tablet',
  ),
  capsule(
    icon: FluentIcons.pill_24_regular,
    iconFilled: FluentIcons.pill_24_filled,
    label: "Capsules",
  ),
  chewable(
    icon: FluentIcons.pill_24_regular,
    iconFilled: FluentIcons.pill_24_filled,
    iconPath: "assets/svg/tablet.svg",
    label: 'Chewable',
  ),
  droplet(
    icon: HugeIcons.strokeRoundedDroplet,
    iconFilled: FluentIcons.drop_16_filled,
    iconPath: "assets/svg/droplet-alt.svg",
    iconPathFilled: "assets/svg/droplet-alt-filled.svg",
    label: "Droplets",
  ),

  injection(
    icon: FluentIcons.syringe_24_regular,
    iconFilled: FluentIcons.syringe_24_filled,
    label: "Injection",
  ),
  liquid(
    icon: HugeIcons.strokeRoundedDroplet,
    iconFilled: HugeIcons.strokeRoundedDroplet,
    iconPath: "assets/svg/droplet-alt.svg",
    iconPathFilled: "assets/svg/droplet-alt-filled.svg",
    label: "Liquid",
  ),
  inhaler(
    icon: FluentIcons.drink_bottle_20_regular,
    iconFilled: FluentIcons.drink_bottle_20_filled,
    label: "Inhaler",
  ),
 creamsAndOintment(
    icon: FluentIcons.stream_24_regular,
    iconFilled: FluentIcons.stream_24_filled,
    label: "Creams & Ointments",
  ),
  unknown(
    icon: FluentIcons.pill_24_regular,
    iconFilled: FluentIcons.pill_24_filled,
    label: 'Unknown',
  );
  // custom(
  //   icon: FluentIcons.add_24_regular,
  //   iconFilled: FluentIcons.add_24_filled,
  //   label: "Custom",
  // );


  final String label;
  final IconData? icon;
  final IconData? iconFilled;
  final String? iconPath;
  final String? iconPathFilled;
  const MedicationType({
    required this.label,
    this.icon,
    this.iconPath,
    this.iconFilled,
    this.iconPathFilled,
  });
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
  droplet(symbol: 'droplet'),

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
  afterNumberOfOccurrences,
}

enum MedsHistoryMode {
  ///An Enum to define the medication history modes
  ///can be used on the [MedsHistoryItem] widget
  ///Can be used for the Meds history mode dropdown
  ///Can be used for switching medication history mode
  daily,
  weekly,
  monthly,
  yearly,
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
