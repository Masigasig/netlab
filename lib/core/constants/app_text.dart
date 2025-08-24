import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  AppTextStyles._();

  // Define your different fonts here
  static TextStyle _primaryFont() => GoogleFonts.poppins();    // Main font
  static TextStyle _secondaryFont() => GoogleFonts.inter();   // Sub Secondary font

  // Header styles
  static TextStyle get headerLarge => _primaryFont().copyWith(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static TextStyle get headerMedium => _primaryFont().copyWith(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static TextStyle get headerSmall => _primaryFont().copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  // Body text styles
  static TextStyle get bodyLarge => _primaryFont().copyWith(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: Colors.black87,
  );

  static TextStyle get bodyMedium => _primaryFont().copyWith(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Colors.black87,
  );

  static TextStyle get bodySmall => _primaryFont().copyWith(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: Colors.black87,
  );

  // Button text styles
  static TextStyle get buttonLarge => _primaryFont().copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static TextStyle get buttonMedium => _primaryFont().copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static TextStyle get buttonSmall => _primaryFont().copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );

  // SECONDARY FONT STYLES (inter)
  // Subtitle styles using secondary font
  static TextStyle get subtitleLarge => _secondaryFont().copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: const Color(0xB3000000), // Colors.black.withOpacity(0.7)
  );

  static TextStyle get subtitleMedium => _secondaryFont().copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: const Color(0xB3000000), // Colors.black.withOpacity(0.7)
  );

  static TextStyle get subtitleSmall => _secondaryFont().copyWith(
    fontSize: 11,
    fontWeight: FontWeight.normal,
    color: const Color(0xBFFFFFFF), // Colors.white.withOpacity(0.75)
  );

  // Caption/label styles using secondary font
  static TextStyle get caption => _secondaryFont().copyWith(
    fontSize: 10,
    fontWeight: FontWeight.normal,
    color: Colors.grey,
  );

  static TextStyle get label => _secondaryFont().copyWith(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: Colors.grey,
  );

  // CUSTOM METHODS FOR DIFFERENT FONTS
  // Primary font custom variations
  static TextStyle primaryCustom({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
    double? height,
  }) {
    return _primaryFont().copyWith(
      fontSize: fontSize ?? 14,
      fontWeight: fontWeight ?? FontWeight.normal,
      color: color ?? Colors.black87,
      letterSpacing: letterSpacing,
      height: height,
    );
  }

  // Secondary font custom variations
  static TextStyle secondaryCustom({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
    double? height,
  }) {
    return _secondaryFont().copyWith(
      fontSize: fontSize ?? 14,
      fontWeight: fontWeight ?? FontWeight.normal,
      color: color ?? Colors.black87,
      letterSpacing: letterSpacing,
      height: height,
    );
  }

  // Generic custom method (uses primary font by default)
  static TextStyle custom({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
    double? height,
  }) {
    return _primaryFont().copyWith(
      fontSize: fontSize ?? 14,
      fontWeight: fontWeight ?? FontWeight.normal,
      color: color ?? Colors.black87,
      letterSpacing: letterSpacing,
      height: height,
    );
  }

  // Utility methods
  static TextStyle withColor(TextStyle baseStyle, Color color) {
    return baseStyle.copyWith(color: color);
  }

  static TextStyle withOpacity(TextStyle baseStyle, double opacity) {
    return baseStyle.copyWith(color: baseStyle.color);
  }
}