import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:netlab/core/components/app_theme.dart';

class SettingScreen extends ConsumerWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('SettingScreen Widget rebuilt');
    final themeMode = ref.watch(themeModeProvider);
    final themeNotifier = ref.read(themeModeProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(16),
          constraints: const BoxConstraints(maxWidth: 400),
          child: Row(
            children: [
              _ThemeButton(
                mode: ThemeMode.light,
                label: 'Light',
                icon: Icons.light_mode,
                currentMode: themeMode,
                onPressed: () => themeNotifier.setThemeMode(ThemeMode.light),
              ),
              const SizedBox(width: 8),
              _ThemeButton(
                mode: ThemeMode.dark,
                label: 'Dark',
                icon: Icons.dark_mode,
                currentMode: themeMode,
                onPressed: () => themeNotifier.setThemeMode(ThemeMode.dark),
              ),
              const SizedBox(width: 8),
              _ThemeButton(
                mode: ThemeMode.system,
                label: 'System',
                icon: Icons.brightness_auto,
                currentMode: themeMode,
                onPressed: () => themeNotifier.setThemeMode(ThemeMode.system),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ThemeButton extends StatelessWidget {
  final ThemeMode mode;
  final ThemeMode currentMode;
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const _ThemeButton({
    required this.mode,
    required this.currentMode,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = mode == currentMode;

    return Expanded(
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(
          icon,
          size: 18,
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onSurface,
        ),
        label: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: isSelected
              // ignore: deprecated_member_use
              ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
              : null,
          side: BorderSide(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline,
            width: isSelected ? 2 : 1,
          ),
        ),
      ),
    );
  }
}
