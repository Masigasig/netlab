import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_color.dart';
import '../components/button_style.dart';

export 'app_color.dart';
export '../components/button_style.dart';
export '../components/app_styles.dart';

class AppThemes {
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: AppColors.lightColorScheme,
    elevatedButtonTheme: AppButtonStyles.lightElevatedButtonTheme,
    outlinedButtonTheme: AppButtonStyles.lightOutlinedButtonTheme,
    textButtonTheme: AppButtonStyles.lightTextButtonTheme,
    filledButtonTheme: AppButtonStyles.lightFilledButtonTheme,
  );

  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: AppColors.darkColorScheme,
    elevatedButtonTheme: AppButtonStyles.darkElevatedButtonTheme,
    outlinedButtonTheme: AppButtonStyles.darkOutlinedButtonTheme,
    textButtonTheme: AppButtonStyles.darkTextButtonTheme,
    filledButtonTheme: AppButtonStyles.darkFilledButtonTheme,
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
