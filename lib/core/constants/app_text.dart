import 'package:flutter/material.dart';

class AppTextStyles {
  AppTextStyles._();

  // Base font providers
  static TextStyle _primaryFont({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.normal,
    Color color = Colors.black87,
    double? letterSpacing,
    double? height,
  }) =>
      TextStyle(
        fontFamily: 'Poppins', // local Poppins
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        letterSpacing: letterSpacing,
        height: height,
      );

  static TextStyle _secondaryFont({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.normal,
    Color color = Colors.black87,
    double? letterSpacing,
    double? height,
  }) =>
      TextStyle(
        fontFamily: 'Inter', // local Inter (variable)
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        letterSpacing: letterSpacing,
        height: height,
      );

  // ------------------- HEADERS (Poppins) -------------------
  static TextStyle get headerLarge => _primaryFont(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      );

  static TextStyle get headerMedium => _primaryFont(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      );

  static TextStyle get headerSmall => _primaryFont(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      );

  // ------------------- BODY (Poppins) -------------------
  static TextStyle get bodyLarge => _primaryFont(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: Colors.black87,
      );

  static TextStyle get bodyMedium => _primaryFont(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: Colors.black87,
      );

  static TextStyle get bodySmall => _primaryFont(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: Colors.black87,
      );

  // ------------------- BUTTONS (Poppins) -------------------
  static TextStyle get buttonLarge => _primaryFont(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      );

  static TextStyle get buttonMedium => _primaryFont(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      );

  static TextStyle get buttonSmall => _primaryFont(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      );

  // ------------------- SUBTITLES (Inter) -------------------
  static TextStyle get subtitleLarge => _secondaryFont(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: const Color(0xB3000000), // black 70%
      );

  static TextStyle get subtitleMedium => _secondaryFont(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: const Color(0xB3000000), // black 70%
      );

  static TextStyle get subtitleSmall => _secondaryFont(
        fontSize: 11,
        fontWeight: FontWeight.normal,
        color: const Color(0xBFFFFFFF), // white 75%
      );

  // ------------------- CAPTION / LABEL (Inter) -------------------
  static TextStyle get caption => _secondaryFont(
        fontSize: 10,
        fontWeight: FontWeight.normal,
        color: Colors.grey,
      );

  static TextStyle get label => _secondaryFont(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: Colors.grey,
      );

  // ------------------- CUSTOM VARIATIONS -------------------
  static TextStyle primaryCustom({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
    double? height,
  }) =>
      _primaryFont(
        fontSize: fontSize ?? 14,
        fontWeight: fontWeight ?? FontWeight.normal,
        color: color ?? Colors.black87,
        letterSpacing: letterSpacing,
        height: height,
      );

  static TextStyle secondaryCustom({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
    double? height,
  }) =>
      _secondaryFont(
        fontSize: fontSize ?? 14,
        fontWeight: fontWeight ?? FontWeight.normal,
        color: color ?? Colors.black87,
        letterSpacing: letterSpacing,
        height: height,
      );

  static TextStyle custom({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
    double? height,
  }) =>
      _primaryFont(
        fontSize: fontSize ?? 14,
        fontWeight: fontWeight ?? FontWeight.normal,
        color: color ?? Colors.black87,
        letterSpacing: letterSpacing,
        height: height,
      );

  // ------------------- UTILITIES -------------------
  static TextStyle withColor(TextStyle baseStyle, Color color) =>
      baseStyle.copyWith(color: color);

  static TextStyle withOpacity(TextStyle baseStyle, double opacity) =>
      baseStyle.copyWith(
        color: baseStyle.color?.withOpacity(opacity),
      );
}