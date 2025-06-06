import 'package:flutter/material.dart';

///-------Paddings--------///
const double kDefaultPadding = 16.0;
const double kDefaultPaddingLarge = 24.0;
const double kPadding4 = 4.0;
const double kPadding8 = 8.0;
const double kPadding12 = 12.0;
const double kPadding16 = 16.0;
const double kPadding24 = 24.0;
const double kPadding32 = 32.0;
const double kPadding48 = 48.0;
const double kPadding64 = 64.0;

///------Input Decorations-------///
class AppInputDecoration {
  static InputDecoration inputDecoration(BuildContext context) {
    return InputDecoration(
        contentPadding: const EdgeInsets.all(12),
        errorStyle: AppTextStyles.bodyMedium
            .copyWith(color: Theme.of(context).colorScheme.error),
        errorBorder: OutlineInputBorder(
          gapPadding: 4,
          borderSide:
              BorderSide(color: Theme.of(context).colorScheme.error, width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
        border: OutlineInputBorder(
          gapPadding: 0,
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          gapPadding: 0,
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(12),
        ),
        disabledBorder: OutlineInputBorder(
          gapPadding: 0,
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          gapPadding: 0,
          borderSide:
              const BorderSide(width: 1, color: AppColours.purple60),
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        isDense: true,
        fillColor: Theme.of(context).colorScheme.surfaceContainerLow,
        hintStyle: AppTextStyles.bodyMedium
            .copyWith(color: AppColours.neutral50),
        labelStyle:
            AppTextStyles.bodyMedium.copyWith(color: AppColours.black));
  }

  static InputDecorationTheme inputDecorationTheme(BuildContext context) {
    return InputDecorationTheme(
      constraints: const BoxConstraints(maxHeight: 48),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      errorStyle: AppTextStyles.bodyMedium
          .copyWith(color: Theme.of(context).colorScheme.error),
      errorBorder: OutlineInputBorder(
        gapPadding: 4,
        borderSide:
        BorderSide(color: Theme.of(context).colorScheme.error, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      border: OutlineInputBorder(
        gapPadding: 0,
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(12),
      ),
      enabledBorder: OutlineInputBorder(
        gapPadding: 0,
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(12),
      ),
      disabledBorder: OutlineInputBorder(
        gapPadding: 0,
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        gapPadding: 0,
        borderSide: const BorderSide(width: 1, color: AppColours.purple70),
        borderRadius: BorderRadius.circular(12),
      ),
      filled: true,
      isDense: true,
      fillColor: Theme.of(context).colorScheme.surfaceContainerLow,
      suffixIconColor: Theme.of(context).colorScheme.primary,
    );
  }
}

///------Colours-------///
class AppColours {
  // static const Color black = Color(0xFF1C1A22);
  static const Color black = Color(0xFF000000);
  // static const Color white = Color(0xFFFFFBFF);
  static const Color white = Color(0xFFFFFFFF);

  ///-----------Purple---------///
  static const Color purpleSeed = Color(0xFF7B4FFF);
  static const Color purple0 = Color(0xFF000000);
  static const Color purple05 = Color(0xFF130043);
  static const Color purple10 = Color(0xFF1F0060);
  static const Color purple15 = Color(0xFF2A007A);
  static const Color purple20 = Color(0xFF350097);
  static const Color purple25 = Color(0xFF4100B4);
  static const Color purple30 = Color(0xFF4E00D2);
  static const Color purple35 = Color(0xFF5A21DD);
  static const Color purple40 = Color(0xFF6635E9);
  static const Color purple50 = Color(0xFF7F56FF);
  static const Color purple60 = Color(0xFF987BFF);
  static const Color purple70 = Color(0xFFB29DFF);
  static const Color purple80 = Color(0xFFCCBDFF);
  static const Color purple90 = Color(0xFFE7DEFF);
  static const Color purple95 = Color(0xFFF5EEFF);
  static const Color purple98 = Color(0xFFFDF7FF);
  static const Color purple99 = Color(0xFFFFFBFF);

  ///-----------Orange---------///
  static const Color orangeSeed = Color(0xFFFE764A);
  static const Color orange0 = Color(0xFF000000);
  static const Color orange05 = Color(0xFF270500);
  static const Color orange10 = Color(0xFF3A0B00);
  static const Color orange15 = Color(0xFF4B1100);
  static const Color orange20 = Color(0xFF5E1700);
  static const Color orange25 = Color(0xFF711E00);
  static const Color orange30 = Color(0xFF852400);
  static const Color orange35 = Color(0xFF982D03);
  static const Color orange40 = Color(0xFFA83810);
  static const Color orange50 = Color(0xFFCA5027);
  static const Color orange60 = Color(0xFFEC693E);
  static const Color orange70 = Color(0xFFFF8B67);
  static const Color orange80 = Color(0xFFFFB59E);
  static const Color orange90 = Color(0xFFFFDBD0);
  static const Color orange95 = Color(0xFFFFEDE8);
  static const Color orange98 = Color(0xFFFFF8F6);
  static const Color orange99 = Color(0xFFFFFBFF);

  ///-----------Green---------///
  static const Color greenSeed = Color(0xFF17D074);
  static const Color green0 = Color(0xFF000000);
  static const Color green05 = Color(0xFF001507);
  static const Color green10 = Color(0xFF00210D);
  static const Color green15 = Color(0xFF002D14);
  static const Color green20 = Color(0xFF00391B);
  static const Color green25 = Color(0xFF004522);
  static const Color green30 = Color(0xFF00522A);
  static const Color green35 = Color(0xFF005F31);
  static const Color green40 = Color(0xFF006D39);
  static const Color green50 = Color(0xFF008949);
  static const Color green60 = Color(0xFF00A65A);
  static const Color green70 = Color(0xFF00C46C);
  static const Color green80 = Color(0xFF39E283);
  static const Color green90 = Color(0xFFABF3BC);
  static const Color green95 = Color(0xFFC3FFCF);
  static const Color green98 = Color(0xFFEAFFEA);
  static const Color green99 = Color(0xFFF5FFF3);

  ///-----------Red---------///
  static const Color redSeed = Color(0xFFF5043E);
  static const Color red0 = Color(0xFF000000);
  static const Color red05 = Color(0xFF2C0004);
  static const Color red10 = Color(0xFF400009);
  static const Color red15 = Color(0xFF54000E);
  static const Color red20 = Color(0xFF680014);
  static const Color red25 = Color(0xFF7D001A);
  static const Color red30 = Color(0xFF920021);
  static const Color red35 = Color(0xFFA80027);
  static const Color red40 = Color(0xFFBF002E);
  static const Color red50 = Color(0xFFEE003B);
  static const Color red60 = Color(0xFFFF525F);
  static const Color red70 = Color(0xFFFF888B);
  static const Color red80 = Color(0xFFFFB3B3);
  static const Color red90 = Color(0xFFFFDAD9);
  static const Color red95 = Color(0xFFFFEDEC);
  static const Color red98 = Color(0xFFFFF8F7);
  static const Color red99 = Color(0xFFFFFBFF);

  ///-----------Blue---------///
  static const Color blueSeed = Color(0xFF1CA8FF);
  static const Color blue0 = Color(0xFF000000);
  static const Color blue05 = Color(0xFF001222);
  static const Color blue10 = Color(0xFF001D32);
  static const Color blue15 = Color(0xFF002842);
  static const Color blue20 = Color(0xFF003353);
  static const Color blue25 = Color(0xFF003E64);
  static const Color blue30 = Color(0xFF004A76);
  static const Color blue35 = Color(0xFF005688);
  static const Color blue40 = Color(0xFF00639A);
  static const Color blue50 = Color(0xFF007DC1);
  static const Color blue60 = Color(0xFF0097E9);
  static const Color blue70 = Color(0xFF4FB2FF);
  static const Color blue80 = Color(0xFF96CCFF);
  static const Color blue90 = Color(0xFFCEE5FF);
  static const Color blue95 = Color(0xFFE8F2FF);
  static const Color blue98 = Color(0xFFF7F9FF);
  static const Color blue99 = Color(0xFFFCFCFF);

  ///-----------Neutral---------///
  static const Color neutral0 = Color(0xFF000000);
  static const Color neutral05 = Color(0xFF111014);
  static const Color neutral10 = Color(0xFF1C1B1E);
  static const Color neutral15 = Color(0xFF272529);
  static const Color neutral20 = Color(0xFF313033);
  static const Color neutral25 = Color(0xFF3C3B3E);
  static const Color neutral30 = Color(0xFF48464A);
  static const Color neutral35 = Color(0xFF545256);
  static const Color neutral40 = Color(0xFF605D62);
  static const Color neutral50 = Color(0xFF79767A);
  static const Color neutral60 = Color(0xFF938F94);
  static const Color neutral70 = Color(0xFFAEAAAF);
  static const Color neutral80 = Color(0xFFCAC4CF);
  static const Color neutral90 = Color(0xFFE6E1E6);
  static const Color neutral95 = Color(0xFFF4EFF4);
  static const Color neutral98 = Color(0xFFFDF8FD);
  static const Color neutral99 = Color(0xFFFFFBFF);
}

///------Text Styles-------///
class AppTextStyles {
  ///---Display---//

  static TextStyle displayLarge = const TextStyle(
    fontWeight: FontWeight.w800,
    fontSize: 57,
    height: 1,
  );

  static TextStyle displayMedium = const TextStyle(
    fontWeight: FontWeight.w800,
    fontSize: 45,
    height: 1,
  );

  static TextStyle displaySmall = const TextStyle(
    fontWeight: FontWeight.w800,
    fontSize: 36,
    height: 1,
  );

  ///---Headline---///
  static TextStyle headlineLarge = const TextStyle(
    fontWeight: FontWeight.w800,
    fontSize: 32,
    //  height: 1,
  );
  static TextStyle headlineMedium = const TextStyle(
    fontWeight: FontWeight.w800,
    fontSize: 28,
    //   height: 1,
  );
  static TextStyle headlineSmall = const TextStyle(
    fontWeight: FontWeight.w800,
    fontSize: 24,
    //   height: 1,
  );

  ///---Title---///

  static TextStyle titleLarge = const TextStyle(
    fontWeight: FontWeight.w800,
    fontSize: 22,

  );

  static TextStyle titleMedium = const TextStyle(
    fontWeight: FontWeight.w800,
    fontSize: 16,

  );

  static TextStyle titleSmall = const TextStyle(
    fontWeight: FontWeight.w800,
    fontSize: 14,

  );

  ///---Body---///

  static TextStyle bodyLarge = const TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 16,
  );

  static TextStyle bodyMedium = const TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 14,
  );

  static TextStyle bodySmall = const TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 12,
  );
}
