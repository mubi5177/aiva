import 'package:aivi/config/theme/app_theme_extension.dart';
import 'package:flutter/material.dart';

abstract class AppTheme {
  Color get primary;

  ThemeData get themeData;

  Color get onPrimary;

  Color get secondary;

  Color get onSecondary;

  Color get errorColor;

  Color get cardColor;

  Color get scaffoldBackgroundColor;

  Color get tertiary;

  Color get onTertiary;

  Color get ratingColor;

  Color get gradientBlue;

  Color get gradientPink;

  Color get gradientOrange;

  Color get buttonPrimaryColor;

  TextTheme get textTheme;

  AppThemeExtension get extension;
}
