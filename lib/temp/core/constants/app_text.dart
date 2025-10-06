import 'package:flutter/material.dart';

class AppTextStyles {
  AppTextStyles._();

  // Base font providers
  static TextStyle _primaryFont({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.normal,
    double? letterSpacing,
    double? height,
  }) => TextStyle(
    fontFamily: 'Poppins', // local Poppins
    fontSize: fontSize,
    fontWeight: fontWeight,
    letterSpacing: letterSpacing,
    height: height,
  );

  static TextStyle _secondaryFont({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.normal,
    double? letterSpacing,
    double? height,
  }) => TextStyle(
    fontFamily: 'Inter', // local Inter (variable)
    fontSize: fontSize,
    fontWeight: fontWeight,
    letterSpacing: letterSpacing,
    height: height,
  );

  // ------------------- HEADERS (Poppins) -------------------
  static TextStyle get headerLarge =>
      _primaryFont(fontSize: 24, fontWeight: FontWeight.bold);

  static TextStyle get headerMedium =>
      _primaryFont(fontSize: 20, fontWeight: FontWeight.w600);

  static TextStyle get headerSmall =>
      _primaryFont(fontSize: 18, fontWeight: FontWeight.w600);

  // ------------------- BODY (Poppins) -------------------
  static TextStyle get bodyLarge =>
      _primaryFont(fontSize: 16, fontWeight: FontWeight.normal);

  static TextStyle get bodyMedium =>
      _primaryFont(fontSize: 14, fontWeight: FontWeight.normal);

  static TextStyle get bodySmall =>
      _primaryFont(fontSize: 12, fontWeight: FontWeight.normal);

  // ------------------- BUTTONS (Poppins) -------------------
  static TextStyle get buttonLarge =>
      _primaryFont(fontSize: 16, fontWeight: FontWeight.w500);

  static TextStyle get buttonMedium =>
      _primaryFont(fontSize: 14, fontWeight: FontWeight.w500);

  static TextStyle get buttonSmall =>
      _primaryFont(fontSize: 12, fontWeight: FontWeight.w500);

  // ------------------- SUBTITLES (Inter) -------------------
  static TextStyle get subtitleLarge =>
      _secondaryFont(fontSize: 14, fontWeight: FontWeight.w500);

  static TextStyle get subtitleXL =>
      _secondaryFont(fontSize: 16, fontWeight: FontWeight.w500);

  static TextStyle get subtitleMedium =>
      _secondaryFont(fontSize: 12, fontWeight: FontWeight.w500);

  static TextStyle get subtitleSmall =>
      _secondaryFont(fontSize: 11, fontWeight: FontWeight.normal);

  // ------------------- CAPTION / LABEL (Inter) -------------------
  static TextStyle get caption =>
      _secondaryFont(fontSize: 10, fontWeight: FontWeight.normal);

  static TextStyle get label =>
      _secondaryFont(fontSize: 11, fontWeight: FontWeight.w500);

  // ------------------- CUSTOM VARIATIONS -------------------
  static TextStyle primaryCustom({
    double? fontSize,
    FontWeight? fontWeight,
    double? letterSpacing,
    double? height,
  }) => _primaryFont(
    fontSize: fontSize ?? 14,
    fontWeight: fontWeight ?? FontWeight.normal,
    letterSpacing: letterSpacing,
    height: height,
  );

  static TextStyle secondaryCustom({
    double? fontSize,
    FontWeight? fontWeight,
    double? letterSpacing,
    double? height,
  }) => _secondaryFont(
    fontSize: fontSize ?? 14,
    fontWeight: fontWeight ?? FontWeight.normal,
    letterSpacing: letterSpacing,
    height: height,
  );

  static TextStyle custom({
    double? fontSize,
    FontWeight? fontWeight,
    double? letterSpacing,
    double? height,
  }) => _primaryFont(
    fontSize: fontSize ?? 14,
    fontWeight: fontWeight ?? FontWeight.normal,
    letterSpacing: letterSpacing,
    height: height,
  );

  // ------------------- THEME-AWARE HELPERS -------------------
  // Use these methods to apply colors based on current theme
  static TextStyle withThemeColor(
    TextStyle baseStyle,
    BuildContext context, {
    bool isPrimary = true,
    bool isOnSurface = true,
  }) {
    Color color;
    if (isPrimary) {
      color = isOnSurface
          ? Theme.of(context).colorScheme.onSurface
          : Theme.of(context).colorScheme.primary;
    } else {
      color = Theme.of(context).colorScheme.onSurfaceVariant;
    }
    return baseStyle.copyWith(color: color);
  }

  static TextStyle forSurface(TextStyle baseStyle, BuildContext context) =>
      baseStyle.copyWith(color: Theme.of(context).colorScheme.onSurface);

  static TextStyle forPrimary(TextStyle baseStyle, BuildContext context) =>
      baseStyle.copyWith(color: Theme.of(context).colorScheme.onPrimary);

  static TextStyle forSecondary(TextStyle baseStyle, BuildContext context) =>
      baseStyle.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant);

  // ------------------- UTILITIES -------------------
  static TextStyle withColor(TextStyle baseStyle, Color color) =>
      baseStyle.copyWith(color: color);

  static TextStyle withOpacity(TextStyle baseStyle, double opacity) =>
      baseStyle.copyWith(color: baseStyle.color?.withValues(alpha: opacity));
}

/** example usage 
 *  style: AppTextStyles.forSurface(AppTextStyles.headerSmall, context),
 */
