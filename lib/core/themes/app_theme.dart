import 'package:flutter/material.dart';

import 'package:netlab/core/components/button_style.dart';
import 'package:netlab/core/themes/app_colors.dart';

class AppThemes {
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: AppColors.lightColorScheme,
    elevatedButtonTheme: AppButtonStyles.lightElevatedButtonTheme,
    textButtonTheme: AppButtonStyles.lightTextButtonTheme,
    outlinedButtonTheme: AppButtonStyles.lightOutlinedButtonTheme,
  );

  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: AppColors.darkColorScheme,
    elevatedButtonTheme: AppButtonStyles.darkElevatedButtonTheme,
    textButtonTheme: AppButtonStyles.darkTextButtonTheme,
    outlinedButtonTheme: AppButtonStyles.darkOutlinedButtonTheme,
  );
}
