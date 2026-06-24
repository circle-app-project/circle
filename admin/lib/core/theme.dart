import 'package:flutter/material.dart';

/// Brand purple seed, matching the mobile app's `AppColours.purpleSeed`.
const Color kBrandSeed = Color(0xFF7B4FFF);

ThemeData buildAdminTheme() {
  final ColorScheme scheme = ColorScheme.fromSeed(
    seedColor: kBrandSeed,
    brightness: Brightness.light,
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: scheme.surface,
    visualDensity: VisualDensity.comfortable,
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: scheme.outlineVariant),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      isDense: true,
    ),
  );
}

/// Shared spacing tokens.
const double kGap4 = 4;
const double kGap8 = 8;
const double kGap12 = 12;
const double kGap16 = 16;
const double kGap24 = 24;
const double kGap32 = 32;
