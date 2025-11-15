import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:netlab/core/provider/async_shared_prefs_provider.dart';

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
