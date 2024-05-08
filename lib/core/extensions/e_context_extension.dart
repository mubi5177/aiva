import 'package:aivi/config/theme/app_theme_extension.dart';
import 'package:aivi/core/components/app_button.dart';
import 'package:aivi/core/constant/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';



extension BuildContextEntension<T> on BuildContext {
  bool get isMobile => MediaQuery.of(this).size.width <= 500.0;

  bool get isTablet => MediaQuery.of(this).size.width < 1024.0 && MediaQuery.of(this).size.width >= 650.0;

  bool get isSmallTablet => MediaQuery.of(this).size.width < 650.0 && MediaQuery.of(this).size.width > 500.0;

  bool get isDesktop => MediaQuery.of(this).size.width >= 1024.0;

  bool get isSmall => MediaQuery.of(this).size.width < 850.0 && MediaQuery.of(this).size.width >= 560.0;

  double get width => MediaQuery.of(this).size.width;

  double get height => MediaQuery.of(this).size.height;

  Size get size => MediaQuery.of(this).size;

  void closeKeyboard() {
    FocusScope.of(this).unfocus();
  }

  // textTheme
  TextStyle? get displayLarge => Theme.of(this).textTheme.displayLarge;

  TextStyle? get displayMedium => Theme.of(this).textTheme.displayMedium;

  TextStyle? get displaySmall => Theme.of(this).textTheme.displaySmall;

  TextStyle? get headlineLarge => Theme.of(this).textTheme.headlineLarge;

  TextStyle? get headlineMedium => Theme.of(this).textTheme.headlineMedium;

  TextStyle? get headlineSmall => Theme.of(this).textTheme.headlineSmall;

  TextStyle? get titleLarge => Theme.of(this).textTheme.titleLarge;

  TextStyle? get titleMedium => Theme.of(this).textTheme.titleMedium;

  TextStyle? get titleSmall => Theme.of(this).textTheme.titleSmall;

  TextStyle? get labelLarge => Theme.of(this).textTheme.labelLarge;

  TextStyle? get bodySmall => Theme.of(this).textTheme.bodySmall;

  TextStyle? get titleTextStyle => Theme.of(this).appBarTheme.titleTextStyle;

  TextStyle? get bodyExtraSmall => bodySmall?.copyWith(fontSize: 10, height: 1.6, letterSpacing: .5);

  TextStyle? get bodyLarge => Theme.of(this).textTheme.bodyLarge;

  TextStyle? get bodyMedium => Theme.of(this).textTheme.bodyMedium;

  TextStyle? get subtitleTextStyle => Theme.of(this).listTileTheme.subtitleTextStyle;

  TextStyle? get dividerTextSmall => bodySmall?.copyWith(letterSpacing: 0.5, fontWeight: FontWeight.w700, fontSize: 12.0);

  TextStyle? get dividerTextLarge => bodySmall?.copyWith(letterSpacing: 1.5, fontWeight: FontWeight.w700, fontSize: 13.0, height: 1.23);

  // color

  ThemeData get theme => Theme.of(this);

  Color get primaryColor => Theme.of(this).primaryColor;

  Color get primaryColorDark => Theme.of(this).primaryColorDark;

  Color get primaryColorLight => Theme.of(this).primaryColorLight;

  Color get primary => Theme.of(this).colorScheme.primary;

  Color get onPrimary => Theme.of(this).colorScheme.onPrimary;

  Color get tertiary => Theme.of(this).colorScheme.tertiary;

  Color get onTertiary => Theme.of(this).colorScheme.onTertiary;

  Color get secondary => Theme.of(this).colorScheme.secondary;

  Color get onSecondary => Theme.of(this).colorScheme.onSecondary;

  Color get cardColor => Theme.of(this).cardColor;

  Color get error => Theme.of(this).colorScheme.error;

  Color get onError => Theme.of(this).colorScheme.onError;

  Color get background => Theme.of(this).colorScheme.background;

  Color get scaffoldBackgroundColor => Theme.of(this).scaffoldBackgroundColor;

  Color get extraLightGrey => Theme.of(this).extension<AppThemeExtension>()!.extraLightGrey;

  Color get lightGrey => Theme.of(this).extension<AppThemeExtension>()!.lightGrey;


  // bottom sheet with dynamic height
  Future<T?> showBottomSheet<T>({
    final Widget? child,
    final bool showDragHandle = true,
    final bool isScrollControlled = true,
    final double? maxHeight,
  }) {
    return showModalBottomSheet(
      backgroundColor: this.onPrimary,
      context: this,
      showDragHandle: showDragHandle,
      constraints: BoxConstraints(maxHeight: maxHeight ?? height * .8),
      isScrollControlled: isScrollControlled,
      builder: (context) => Padding(padding: EdgeInsets.only(top: 0.0, bottom: MediaQuery.of(context).viewInsets.bottom), child: child),
    );
  }

  // dialog alert
  Future<T?> showAlertDialog({
    String title = "",
    String subtitle = "",
    VoidCallback? cancel,
    VoidCallback? confirm,
    String cancelText = AppStrings.cancel,
    String confirmText = AppStrings.confirm,
    Color? confirmColor,
    Color? confirmTextColor,
    bool isButton = true,
    bool barrierDismissible = true,
    Widget? child,
  }) {
    return showDialog(
      context: this,
      barrierDismissible: barrierDismissible,
      builder: (context) => AlertDialog(
        backgroundColor: context.onPrimary,
        surfaceTintColor: context.onPrimary,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isButton == false) child ?? const SizedBox.shrink(),
            if (isButton) ...{
              const Gap(10.0),
              Text(
                title,
                style: context.displayMedium?.copyWith(color: confirmTextColor ?? context.secondary, fontSize: 20.0),
              ),
              const Gap(6.0),
              Text(
                subtitle,
                style: context.titleSmall?.copyWith(color: context.tertiary, fontWeight: FontWeight.w400),
                textAlign: TextAlign.center,
              ),
              const Gap(20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppButton.outline(
                    width: 115,
                    borderColor: context.primary,
                    onPressed: cancel ?? () => Navigator.pop(context),
                    child: Text(cancelText, style: context.labelLarge),
                  ),
                  const Gap(10.0),
                  AppButton(
                    width: 124.0,
                    background: confirmColor ?? context.secondary,
                    onPressed: confirm,
                    child: Text(
                      confirmText,
                      style: context.labelLarge?.copyWith(color: context.onSecondary),
                    ),
                  ),
                ],
              ),
            },
          ],
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
    );
  }

  void showSnackBar({final String? text, final Color? color}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(content: Text(text ?? ""), backgroundColor: color ?? this.primary),
    );
  }
}
