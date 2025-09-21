import 'package:flutter/material.dart';
import 'app_color.dart';

class AppButtonStyles {
  // Light Theme Button Styles
  static ElevatedButtonThemeData get lightElevatedButtonTheme =>
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlue,
          foregroundColor: AppColors.oceanWhite,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );

  static OutlinedButtonThemeData get lightOutlinedButtonTheme =>
      OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryBlue,
          side: BorderSide(
            color: AppColors.primaryBlue.withAlpha(100),
            width: 1.0,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
        ),
      );

  static TextButtonThemeData get lightTextButtonTheme => TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.primaryBlue,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  );

  static FilledButtonThemeData get lightFilledButtonTheme =>
      FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.cyanAccent,
          foregroundColor: AppColors.oceanWhite,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );

  // Dark Theme Button Styles
  static ElevatedButtonThemeData get darkElevatedButtonTheme =>
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.lightBlue,
          foregroundColor: AppColors.deepNavy,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );

  static OutlinedButtonThemeData get darkOutlinedButtonTheme =>
      OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.lightBlue,
          side: const BorderSide(color: AppColors.borderGray, width: 1.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
        ),
      );

  static TextButtonThemeData get darkTextButtonTheme => TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.lightBlue,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  );

  static FilledButtonThemeData get darkFilledButtonTheme =>
      FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.lightBlue,
          foregroundColor: AppColors.deepNavy,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );

  // Custom Opacity Button Styles

  // Light Theme Opacity Buttons
  static ButtonStyle get lightOpacityButton => ElevatedButton.styleFrom(
    backgroundColor: AppColors.primaryBlue.withAlpha(64), // 25% opacity
    foregroundColor: AppColors.primaryBlue,
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  );

  static ButtonStyle get lightOpacitySecondary => ElevatedButton.styleFrom(
    backgroundColor: AppColors.cyanAccent.withAlpha(64), // 25% opacity
    foregroundColor: AppColors.cyanAccent,
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  );

  // Dark Theme Opacity Buttons
  static ButtonStyle get darkOpacityButton => ElevatedButton.styleFrom(
    backgroundColor: AppColors.lightBlue.withAlpha(77), // 30% opacity
    foregroundColor: AppColors.lightBlue,
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  );

  static ButtonStyle get darkOpacitySecondary => ElevatedButton.styleFrom(
    backgroundColor: AppColors.cyanAccent.withAlpha(77), // 30% opacity
    foregroundColor: AppColors.cyanAccent,
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  );

  // Theme-aware opacity buttons that automatically switch
  static ButtonStyle opacityButton(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? darkOpacityButton : lightOpacityButton;
  }

  static ButtonStyle opacitySecondaryButton(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? darkOpacitySecondary : lightOpacitySecondary;
  }
}
