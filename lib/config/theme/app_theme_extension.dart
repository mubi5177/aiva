import 'package:flutter/material.dart';

class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  final Color lightGrey;
  final Color extraLightGrey;

  AppThemeExtension({
    required this.extraLightGrey,
    required this.lightGrey,
  });

  @override
  AppThemeExtension copyWith({
    Color? extraLightGrey,
    Color? lightGrey,
    Gradient? vertical,
    Gradient? horizontal,
  }) {
    return AppThemeExtension(
      extraLightGrey: extraLightGrey ?? this.extraLightGrey,
      lightGrey: lightGrey ?? this.lightGrey,
    );
  }

  @override
  ThemeExtension<AppThemeExtension> lerp(ThemeExtension<AppThemeExtension>? other, double t) {
    if (other is! AppThemeExtension) {
      return this;
    }
    return AppThemeExtension(
      extraLightGrey: Color.lerp(extraLightGrey, other.extraLightGrey, t)!,
      lightGrey: Color.lerp(lightGrey, other.lightGrey, t)!,
    );
  }
}
