import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryBlue = Color(0xFF3B82F6);
  static const Color cyanAccent = Color(0xFF06B6D4);
  static const Color lightSky = Color(0xFFE0F2FE);
  static const Color oceanWhite = Color(0xFFFAFBFF);
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);

  static const Color lightBlue = Color(0xFF3B82F6);
  static const Color deepNavy = Color(0xFF0F172A);
  static const Color slateCard = Color(0xFF1E293B);
  static const Color borderGray = Color(0xFF334155);
  static const Color textLight = Color(0xFFF1F5F9);

  static const Color warningColor = Color(0xFFF59E0B);
  static const Color successColor = Color(0xFF10B981);
  static const Color errorColor = Color(0xFFEF4444);
  static const Color infoColor = Color(0xFF3B82F6);

  static const ColorScheme lightColorScheme = ColorScheme.light(
    primary: primaryBlue,
    onPrimary: oceanWhite,
    secondary: cyanAccent,
    onSecondary: oceanWhite,
    surface: oceanWhite,
    surfaceContainerLow: lightSky,
    onSurface: textPrimary,
    onSurfaceVariant: textSecondary,
  );

  static const ColorScheme darkColorScheme = ColorScheme.dark(
    primary: lightBlue,
    onPrimary: textLight,
    secondary: cyanAccent,
    onSecondary: textLight,
    surface: deepNavy,
    surfaceContainerLow: slateCard,
    onSurface: textLight,
    onSurfaceVariant: borderGray,
  );
}
