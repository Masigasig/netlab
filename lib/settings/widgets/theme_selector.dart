import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';

import 'package:netlab/core/provider/theme_mode_notifier.dart';
import 'package:netlab/temp/core/constants/app_text.dart';

class ThemeSelector extends ConsumerWidget {
  const ThemeSelector({super.key});

  String _getThemeLabel(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }

  Widget _getThemeIcon(ThemeMode mode, BuildContext context) {
    switch (mode) {
      case ThemeMode.light:
        return HugeIcon(
          icon: HugeIcons.strokeRoundedSun03,
          color: Theme.of(context).colorScheme.onSurface,
          size: 18,
        );
      case ThemeMode.dark:
        return HugeIcon(
          icon: HugeIcons.strokeRoundedMoon02,
          color: Theme.of(context).colorScheme.onSurface,
          size: 18,
        );
      case ThemeMode.system:
        return HugeIcon(
          icon: HugeIcons.strokeRoundedComputerSettings,
          color: Theme.of(context).colorScheme.onSurface,
          size: 18,
        );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final themeNotifier = ref.read(themeModeProvider.notifier);

    return SizedBox(
      width: 140,
      child: DropdownButtonFormField<ThemeMode>(
        initialValue: themeMode,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        style: AppTextStyles.forSurface(AppTextStyles.bodyMedium, context),
        items: ThemeMode.values.map((ThemeMode mode) {
          return DropdownMenuItem<ThemeMode>(
            value: mode,
            child: Row(
              children: [
                _getThemeIcon(mode, context),
                const SizedBox(width: 12),
                Text(
                  _getThemeLabel(mode),
                  style: AppTextStyles.forSurface(
                    AppTextStyles.bodyMedium,
                    context,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
        onChanged: (ThemeMode? newValue) {
          if (newValue != null) {
            themeNotifier.setThemeMode(newValue);
          }
        },
      ),
    );
  }
}
