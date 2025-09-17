import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppThemes {
  // Light Theme Color Swatch
  static const MaterialColor lightSwatch = MaterialColor(0xFF3B82F6, {
    50: Color(0xFFFAFBFF), // Ocean White
    100: Color(0xFFE0F2FE), // Light Sky
    200: Color(0xFFBAE6FD), // Pale Blue
    300: Color(0xFF7DD3FC), // Sky Blue
    400: Color(0xFF38BDF8), // Cyan Light
    500: Color(0xFF3B82F6), // Primary Blue (base color)
    600: Color(0xFF0284C7), // Blue Accent
    700: Color(0xFF0369A1), // Deep Cyan
    800: Color(0xFF075985), // Teal Navy
    900: Color(0xFF0C4A6E), // Deep Slate Blue
  });

  // Dark Theme Color Swatch
  static const MaterialColor darkSwatch = MaterialColor(0xFF60A5FA, {
    50: Color(0xFF0F172A), // Dark Navy
    100: Color(0xFF1E293B), // Slate
    200: Color(0xFF334155), // Border Gray
    300: Color(0xFF475569), // Dim Gray
    400: Color(0xFF64748B), // Muted Gray
    500: Color(0xFF60A5FA), // Light Blue (base color)
    600: Color(0xFF3B82F6), // Blue Accent
    700: Color(0xFF2563EB), // Strong Blue
    800: Color(0xFF1D4ED8), // Deep Blue
    900: Color(0xFF1E40AF), // Indigo
  });

  // Additional accent colors
  static const Color cyanAccent = Color(0xFF06B6D4);
  static const Color textLight = Color(0xFFF1F5F9);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primarySwatch: lightSwatch,
    // Use scaffoldBackgroundColor instead of deprecated background
    scaffoldBackgroundColor: lightSwatch[50],

    colorScheme: ColorScheme.light(
      // Primary
      primary: lightSwatch[500]!,
      onPrimary: lightSwatch[50]!,
      primaryContainer: lightSwatch[100]!,
      onPrimaryContainer: lightSwatch[900]!,

      // Secondary
      secondary: cyanAccent,
      onSecondary: lightSwatch[50]!,
      secondaryContainer: lightSwatch[200]!,
      onSecondaryContainer: lightSwatch[800]!,

      // Surface / container roles (new tone-based roles)
      surface: lightSwatch[50]!,
      onSurface: lightSwatch[900]!,
      // replaced deprecated surfaceVariant by using the container roles:
      surfaceContainerLowest: lightSwatch[50]!,
      surfaceContainerLow: lightSwatch[100]!,
      surfaceContainer: lightSwatch[200]!,
      surfaceContainerHigh: lightSwatch[300]!,
      surfaceContainerHighest:
          lightSwatch[400]!, // use this instead of surfaceVariant
      // optional helpful tones:
      surfaceBright: lightSwatch[50]!,
      surfaceDim: lightSwatch[900]!,

      // Error
      error: const Color(0xFFDC2626),
      onError: const Color(0xFFFFFFFF),
      errorContainer: const Color(0xFFFEE2E2),
      onErrorContainer: const Color(0xFF7F1D1D),

      // Outline & shadow
      outline: lightSwatch[300]!,
      outlineVariant: lightSwatch[200]!,
      shadow: lightSwatch[900]!,
      scrim: lightSwatch[900]!,

      // Inverse
      inverseSurface: lightSwatch[800]!,
      onInverseSurface: lightSwatch[100]!,
      inversePrimary: lightSwatch[300]!,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primarySwatch: darkSwatch,
    scaffoldBackgroundColor: darkSwatch[50],

    colorScheme: ColorScheme.dark(
      // Primary
      primary: darkSwatch[500]!,
      onPrimary: darkSwatch[50]!,
      primaryContainer: darkSwatch[100]!,
      onPrimaryContainer: darkSwatch[900]!,

      // Secondary
      secondary: cyanAccent,
      onSecondary: darkSwatch[50]!,
      secondaryContainer: darkSwatch[200]!,
      onSecondaryContainer: darkSwatch[800]!,

      // Surface / container roles
      surface: darkSwatch[50]!,
      onSurface: textLight,
      surfaceContainerLowest: darkSwatch[50]!,
      surfaceContainerLow: darkSwatch[100]!,
      surfaceContainer: darkSwatch[200]!,
      surfaceContainerHigh: darkSwatch[300]!,
      surfaceContainerHighest: darkSwatch[400]!,
      surfaceBright: darkSwatch[50]!,
      surfaceDim: const Color(0xFF000000),

      // Error
      error: const Color(0xFFEF4444),
      onError: const Color(0xFF000000),
      errorContainer: const Color(0xFF7F1D1D),
      onErrorContainer: const Color(0xFFFEE2E2),

      // Outline & shadow
      outline: darkSwatch[300]!,
      outlineVariant: darkSwatch[200]!,
      shadow: const Color(0xFF000000),
      scrim: const Color(0xFF000000),

      // Inverse
      inverseSurface: darkSwatch[800]!,
      onInverseSurface: darkSwatch[100]!,
      inversePrimary: darkSwatch[600]!,
    ),
  );
}

// Riverpod theme mode provider (unchanged)
final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);

class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() => ThemeMode.system;

  void setThemeMode(ThemeMode mode) => state = mode;
}
