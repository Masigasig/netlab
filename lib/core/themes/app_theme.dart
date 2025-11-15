import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:netlab/core/components/button_style.dart';
import 'package:netlab/core/themes/app_color.dart';
import 'package:netlab/core/utils/async_shared_prefs_notifier.dart';

export 'package:netlab/core/themes/app_color.dart';
export '../components/button_style.dart';
export '../components/app_styles.dart';

class AppThemes {
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: AppColors.lightColorScheme,
    elevatedButtonTheme: AppButtonStyles.lightElevatedButtonTheme,
    textButtonTheme: AppButtonStyles.lightTextButtonTheme,
    outlinedButtonTheme: AppButtonStyles.lightOutlinedButtonTheme,
    filledButtonTheme: AppButtonStyles.lightFilledButtonTheme,
  );

  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: AppColors.darkColorScheme,
    elevatedButtonTheme: AppButtonStyles.darkElevatedButtonTheme,
    textButtonTheme: AppButtonStyles.darkTextButtonTheme,
    outlinedButtonTheme: AppButtonStyles.darkOutlinedButtonTheme,
    // filledButtonTheme: AppButtonStyles.darkFilledButtonTheme,
  );
}

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);

class ThemeModeNotifier extends Notifier<ThemeMode> {
  static const _key = 'theme_mode';
  late final SharedPreferencesAsync _asyncPrefs;

  @override
  ThemeMode build() {
    _asyncPrefs = ref.read(asyncSharedPrefsProvider);
    return ThemeMode.system;
  }

  Future<void> loadThemeMode() async {
    final index = await _asyncPrefs.getInt(_key);
    if (index != null) {
      state = ThemeMode.values[index];
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    await _asyncPrefs.setInt(_key, mode.index);
  }
}
