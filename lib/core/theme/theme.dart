import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:springster/springster.dart';

import '../core.dart';

class AppThemeData {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    primaryColor: AppColours.purpleSeed,
    primaryColorLight: AppColours.purple50,
    primaryColorDark: AppColours.purple30,
    scaffoldBackgroundColor: AppColours.white,
    iconTheme: const IconThemeData(color: AppColours.black),
    primaryIconTheme: const IconThemeData(color: AppColours.black),
    splashFactory: InkSparkle.splashFactory,
    expansionTileTheme: ExpansionTileThemeData(
      expansionAnimationStyle: AnimationStyle(
        curve: Spring.defaultIOS.toCurve,
        duration: 500.ms,
        reverseCurve: Spring.defaultIOS.toCurve,
        reverseDuration: 500.ms,
      ),
      shape: RoundedRectangleBorder(
        side: const BorderSide(width: 1, color: AppColours.neutral90),
        borderRadius: BorderRadius.circular(kPadding24),
      ),
      collapsedShape: RoundedRectangleBorder(
        side: const BorderSide(width: 1, color: AppColours.neutral90),
        borderRadius: BorderRadius.circular(kPadding16),
      ),
      childrenPadding: const EdgeInsets.only(
          left: kPadding16, right: kPadding16, bottom: kPadding8),
    ),

    fontFamily: 'Plus Jakarta Sans',
    textTheme: TextTheme(
      displayLarge:
          AppTextStyles.displayLarge.copyWith(color: AppColours.black),
      displayMedium:
          AppTextStyles.displayMedium.copyWith(color: AppColours.black),
      displaySmall:
          AppTextStyles.displaySmall.copyWith(color: AppColours.black),
      headlineLarge:
          AppTextStyles.headlineLarge.copyWith(color: AppColours.black),
      headlineSmall:
          AppTextStyles.headlineSmall.copyWith(color: AppColours.black),
      headlineMedium: AppTextStyles.headlineMedium
          .copyWith(color: AppColours.black),
      titleLarge:
          AppTextStyles.titleLarge.copyWith(color: AppColours.black),
      titleMedium:
          AppTextStyles.titleMedium.copyWith(color: AppColours.black),
      titleSmall:
          AppTextStyles.titleSmall.copyWith(color: AppColours.black),
      bodyLarge:
          AppTextStyles.bodyLarge.copyWith(color: AppColours.black),
      bodyMedium:
          AppTextStyles.bodyMedium.copyWith(color: AppColours.black),
      bodySmall:
          AppTextStyles.bodySmall.copyWith(color: AppColours.black),
    ),
    appBarTheme:
        const AppBarTheme(elevation: 0, backgroundColor: Colors.transparent),
    cardColor: AppColours.purple95,
    elevatedButtonTheme: const ElevatedButtonThemeData(
      style: ButtonStyle(
        splashFactory: InkSparkle.splashFactory,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        fixedSize: WidgetStatePropertyAll<Size>(Size.fromHeight(52)),
        padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(
            EdgeInsets.symmetric(horizontal: 16)),
        elevation: WidgetStatePropertyAll<double>(0),
      ),
    ),
    iconButtonTheme: const IconButtonThemeData(
        style: ButtonStyle(
      splashFactory: InkSparkle.splashFactory,
      elevation: WidgetStatePropertyAll<double>(0),
    )),
    textButtonTheme: const TextButtonThemeData(
        style: ButtonStyle(
      elevation: WidgetStatePropertyAll<double>(0),
      splashFactory: InkSparkle.splashFactory,
    )),
    chipTheme: ChipThemeData(
      labelStyle:
          AppTextStyles.bodyMedium.copyWith(color: AppColours.purple10),
      elevation: 0,
      selectedColor: AppColours.purple90,
      backgroundColor: AppColours.neutral95,
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
    ),
    sliderTheme: const SliderThemeData(
        activeTickMarkColor: AppColours.purpleSeed,
        inactiveTrackColor: AppColours.neutral90,
        trackHeight: 4,
        trackShape: RoundedRectSliderTrackShape(),
        thumbShape: RoundSliderThumbShape(
          elevation: 0,
          enabledThumbRadius: 18,
          disabledThumbRadius: 4,
          pressedElevation: 0,
        ),
        thumbColor: AppColours.white,
        overlayColor: Colors.transparent,
        overlayShape: RoundSliderOverlayShape(overlayRadius: 0)),
    switchTheme: SwitchThemeData(
      thumbColor: const WidgetStatePropertyAll<Color>(AppColours.white),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColours.purpleSeed;
        }
        return AppColours.purple90;
      }),
      trackOutlineColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColours.purpleSeed;
        }
        return AppColours.purple90;
      }),
      trackOutlineWidth: const WidgetStatePropertyAll<double>(0),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    ),
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.light,
      seedColor: AppColours.purpleSeed,
      primary: AppColours.purpleSeed,
      onPrimary: AppColours.white,
      primaryContainer: AppColours.purple95,
      onPrimaryContainer: AppColours.purple10,
      secondary: AppColours.orangeSeed,
      onSecondary: AppColours.white,
      secondaryContainer: AppColours.orange95,
      tertiary: AppColours.blueSeed,
      onTertiary: AppColours.blue10,
      tertiaryContainer: AppColours.blue95,
      onTertiaryContainer: AppColours.blue10,
      error: AppColours.red50,
      onError: AppColours.white,
      errorContainer: AppColours.red95,
      onErrorContainer: AppColours.red10,
      surface: AppColours.neutral95
    ),
  );

  ///--------Dark Theme-------///
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: AppColours.purple70,
    primaryColorLight: AppColours.purple90,
    primaryColorDark: AppColours.purple70,
    scaffoldBackgroundColor: AppColours.black,
    iconTheme: const IconThemeData(color: AppColours.white),
    primaryIconTheme: const IconThemeData(color: AppColours.white),
    splashFactory: InkSparkle.splashFactory,
    expansionTileTheme: ExpansionTileThemeData(

        expansionAnimationStyle: AnimationStyle(
          curve: Spring.defaultIOS.toCurve,
          duration: 500.ms,
          reverseCurve: Spring.defaultIOS.toCurve,
          reverseDuration: 500.ms,

      ),
      shape: RoundedRectangleBorder(
        side: const BorderSide(width: 1, color: AppColours.neutral20),
        borderRadius: BorderRadius.circular(kPadding24),
      ),
      collapsedShape: RoundedRectangleBorder(
        side: const BorderSide(width: 1, color: AppColours.neutral20),
        borderRadius: BorderRadius.circular(kPadding16),
      ),
      childrenPadding: const EdgeInsets.only(
          left: kPadding16, right: kPadding16, bottom: kPadding8),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColours.purple10;
        }
        return AppColours.neutral70;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColours.purple70;
        }
        return AppColours.neutral10;
      }),
      trackOutlineColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColours.purple70;
        }
        return AppColours.neutral10;
      }),
      trackOutlineWidth: const WidgetStatePropertyAll<double>(0),
    ),

    fontFamily: 'Plus Jakarta Sans',
    textTheme: TextTheme(
      displayLarge:
          AppTextStyles.displayLarge.copyWith(color: AppColours.white),
      displayMedium:
          AppTextStyles.displayMedium.copyWith(color: AppColours.white),
      displaySmall:
          AppTextStyles.displaySmall.copyWith(color: AppColours.white),
      headlineLarge:
          AppTextStyles.headlineLarge.copyWith(color: AppColours.white),
      headlineSmall:
          AppTextStyles.headlineSmall.copyWith(color: AppColours.white),
      headlineMedium: AppTextStyles.headlineMedium
          .copyWith(color: AppColours.white),
      titleLarge:
          AppTextStyles.titleLarge.copyWith(color: AppColours.white),
      titleMedium:
          AppTextStyles.titleMedium.copyWith(color: AppColours.white),
      titleSmall:
          AppTextStyles.titleSmall.copyWith(color: AppColours.white),
      bodyLarge:
          AppTextStyles.bodyLarge.copyWith(color: AppColours.white),
      bodyMedium:
          AppTextStyles.bodyMedium.copyWith(color: AppColours.white),
      bodySmall:
          AppTextStyles.bodySmall.copyWith(color: AppColours.white),
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.transparent,
    ),
    cardColor: AppColours.neutral10,
    elevatedButtonTheme: const ElevatedButtonThemeData(
      style: ButtonStyle(
        splashFactory: InkSparkle.splashFactory,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        fixedSize: WidgetStatePropertyAll<Size>(Size.fromHeight(52)),
        padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(
            EdgeInsets.symmetric(horizontal: 16)),
        elevation: WidgetStatePropertyAll<double>(0),
      ),
    ),
    iconButtonTheme: const IconButtonThemeData(
        style: ButtonStyle(
      splashFactory: InkSparkle.splashFactory,
      elevation: WidgetStatePropertyAll<double>(0),
    )),
    textButtonTheme: const TextButtonThemeData(
        style: ButtonStyle(
      elevation: WidgetStatePropertyAll<double>(0),
      splashFactory: InkSparkle.splashFactory,
    )),
    chipTheme: ChipThemeData(
      elevation: 0,
      selectedColor: AppColours.purple70,
      backgroundColor: AppColours.neutral10,
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
    ),
    sliderTheme: const SliderThemeData(
        activeTickMarkColor: AppColours.purple40,
        inactiveTrackColor: AppColours.neutral90,
        trackHeight: 2,
        trackShape: RoundedRectSliderTrackShape(),
        thumbShape: RoundSliderThumbShape(
          elevation: 0,
          enabledThumbRadius: 18,
          disabledThumbRadius: 4,
          pressedElevation: 0,
        ),
        thumbColor: AppColours.white,
        overlayColor: Colors.transparent,
        overlayShape: RoundSliderOverlayShape(overlayRadius: 0)),
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.dark,
      seedColor: AppColours.purpleSeed,
      primary: AppColours.purple70,
      onPrimary: AppColours.purple10,
      primaryContainer: AppColours.purple10,
      onPrimaryContainer: AppColours.purple95,
      secondary: AppColours.orange70,
      onSecondary: AppColours.black,
      secondaryContainer: AppColours.orange10,
      tertiary: AppColours.blueSeed,
      onTertiary: AppColours.white,
      tertiaryContainer: AppColours.blue10,
      onTertiaryContainer: AppColours.white,
      error: AppColours.red60,
      onError: AppColours.white,
      errorContainer: AppColours.red10,
      onErrorContainer: AppColours.red90,
      surface: AppColours.neutral10,
    ),
  );
}
