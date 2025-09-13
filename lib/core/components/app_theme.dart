import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppThemes {
  static const Color primaryBlue = Color(0xFF3B82F6);
  static const Color cyanAccent = Color(0xFF06B6D4);
  static const Color lightSky = Color(0xFFE0F2FE);
  static const Color oceanWhite = Color(0xFFFAFBFF);
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);

  static const Color lightBlue = Color(0xFF60A5FA);
  static const Color deepNavy = Color(0xFF0F172A);
  static const Color slateCard = Color(0xFF1E293B);
  static const Color borderGray = Color(0xFF334155);
  static const Color textLight = Color(0xFFF1F5F9);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    colorScheme: const ColorScheme.light(
      primary: primaryBlue,
      onPrimary: oceanWhite,
      secondary: cyanAccent,
      onSecondary: oceanWhite,
      surface: oceanWhite,
      surfaceContainerLow: lightSky,
      onSurface: textPrimary,
      onSurfaceVariant: textSecondary,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    colorScheme: const ColorScheme.dark(
      primary: lightBlue,
      onPrimary: textLight,
      secondary: cyanAccent,
      onSecondary: textLight,
      surface: deepNavy,
      surfaceContainerLow: slateCard,
      onSurface: textLight,
      onSurfaceVariant: borderGray,
    ),
  );
}

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);

class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() => ThemeMode.system;

  void setThemeMode(ThemeMode mode) => state = mode;
}
