import 'package:aivi/config/theme/app_theme.dart';
import 'package:aivi/config/theme/app_theme_extension.dart';
import 'package:aivi/gen/fonts.gen.dart';
import 'package:flutter/material.dart';

class DarkTheme extends AppTheme {
  @override
  ThemeData get themeData => ThemeData(
        fontFamily: FontFamily.metropolisRegular,
        colorScheme: ColorScheme.dark(
          primary: primary,
          onPrimary: onPrimary,
          secondary: secondary,
          onSecondary: onSecondary,
          error: errorColor,
          tertiary: tertiary,
          onTertiary: onTertiary,
        ),
        tabBarTheme: TabBarTheme(
          labelColor: primary,
          unselectedLabelColor: tertiary,
          indicatorSize: TabBarIndicatorSize.tab,
        ),
        scaffoldBackgroundColor: scaffoldBackgroundColor,
        dividerTheme: DividerThemeData(color: tertiary, thickness: .2),
        dialogTheme: DialogTheme(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          backgroundColor: onPrimary,
        ),
        textTheme: textTheme,
        cardColor: cardColor,
        cardTheme: CardTheme(color: cardColor, elevation: .1, margin: const EdgeInsets.symmetric(vertical: 10.0)),
        appBarTheme: AppBarTheme(
            surfaceTintColor: Colors.transparent,
            backgroundColor: scaffoldBackgroundColor,
            centerTitle: true,
            foregroundColor: scaffoldBackgroundColor,
            titleTextStyle: TextStyle(
              color: primary,
              fontSize: 24.0,
              fontWeight: FontWeight.w600,
              fontFamily: FontFamily.metropolisRegular,
            ),
            iconTheme: IconThemeData(color: primary)),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: const BorderSide(color: Colors.transparent, width: 0.0)),
          fillColor: cardColor,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 0.0),
          filled: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(primary),
            overlayColor: MaterialStateProperty.all<Color>(onPrimary.withOpacity(0.1)),
          ),
        ),
      );

  @override
  Color get cardColor => const Color(0xff2B2B2B);

  @override
  Color get buttonPrimaryColor => const Color(0xff2B2B2B);

  @override
  Color get errorColor => Colors.red;

  @override
  Color get primary => const Color(0xffFFFFFF);

  @override
  Color get onSecondary => const Color(0xffFFFFFF);

  @override
  Color get onPrimary => const Color(0xff1E1E1E);

  @override
  Color get scaffoldBackgroundColor => const Color(0xff1E1E1E);

  @override
  Color get secondary => const Color(0xFF2764FE);

  @override
  TextTheme get textTheme => TextTheme(
        displayLarge: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w700, color: primary),
        displayMedium: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: primary),
        displaySmall: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500, color: primary),
        titleLarge: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600, color: primary),
        titleMedium: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400, color: tertiary),
        titleSmall: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, color: tertiary),
        labelLarge: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600, color: primary),
      );

  @override
  Color get onTertiary => const Color(0xffE7E7E7);

  @override
  Color get tertiary => const Color(0xff999999);

  @override
  Color get ratingColor => const Color(0xffF2BD27);

  @override
  Color get gradientBlue => const Color(0xff2764FE);

  @override
  Color get gradientOrange => const Color(0xffFFA5A5);

  @override
  Color get gradientPink => const Color(0xffD16FFE);

  @override
  AppThemeExtension get extension => AppThemeExtension(
        extraLightGrey: Colors.grey.withOpacity(0.3),
        lightGrey: Colors.grey.withOpacity(0.7),
      );
}
