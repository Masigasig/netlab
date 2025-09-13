import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Custom theme data class
class AppThemes {
  // Light theme with custom colors
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    // Custom color scheme
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF6B46C1), // Purple
      onPrimary: Colors.white,
      primaryContainer: Color(0xFFE0E7FF),
      onPrimaryContainer: Color(0xFF4C1D95),
      secondary: Color(0xFFEC4899), // Pink
      onSecondary: Colors.white,
      secondaryContainer: Color(0xFFFCE7F3),
      onSecondaryContainer: Color(0xFFBE185D),
      tertiary: Color(0xFF059669), // Green
      onTertiary: Colors.white,
      tertiaryContainer: Color(0xFFD1FAE5),
      onTertiaryContainer: Color(0xFF064E3B),
      error: Color(0xFFDC2626),
      onError: Colors.white,
      errorContainer: Color(0xFFFEE2E2),
      onErrorContainer: Color(0xFF991B1B),
      surface: Colors.white,
      onSurface: Color(0xFF1F2937),
      surfaceContainerHighest: Color(0xFFF3F4F6),
      onSurfaceVariant: Color(0xFF6B7280),
      outline: Color(0xFFD1D5DB),
      outlineVariant: Color(0xFFE5E7EB),
      shadow: Colors.black,
      scrim: Colors.black,
      inverseSurface: Color(0xFF1F2937),
      onInverseSurface: Color(0xFFF9FAFB),
      inversePrimary: Color(0xFFA78BFA),
    ),

    // Custom text theme
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 57,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1F2937),
        fontFamily: 'serif',
      ),
      displayMedium: TextStyle(
        fontSize: 45,
        fontWeight: FontWeight.bold,
        color: Color(0xFF374151),
      ),
      displaySmall: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.w600,
        color: Color(0xFF4B5563),
      ),
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: Color(0xFF6B46C1),
        letterSpacing: -0.5,
      ),
      headlineMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: Color(0xFF6B46C1),
      ),
      headlineSmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: Color(0xFF374151),
      ),
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        color: Color(0xFF1F2937),
        letterSpacing: 0,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Color(0xFF374151),
        letterSpacing: 0.15,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Color(0xFF4B5563),
        letterSpacing: 0.1,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: Color(0xFF1F2937),
        letterSpacing: 0.5,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: Color(0xFF374151),
        letterSpacing: 0.25,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: Color(0xFF6B7280),
        letterSpacing: 0.4,
      ),
    ),

    // Custom app bar theme
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF6B46C1),
      foregroundColor: Colors.white,
      elevation: 4,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),

    // Custom elevated button theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF6B46C1),
        foregroundColor: Colors.white,
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),

    // Custom card theme
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.all(8),
    ),
  );

  // Dark theme with custom colors
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    // Custom dark color scheme
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFF8B5CF6), // Light Purple
      onPrimary: Color(0xFF1F2937),
      primaryContainer: Color(0xFF5B21B6),
      onPrimaryContainer: Color(0xFFDDD6FE),
      secondary: Color(0xFFF472B6), // Light Pink
      onSecondary: Color(0xFF1F2937),
      secondaryContainer: Color(0xFF9D174D),
      onSecondaryContainer: Color(0xFFFDF2F8),
      tertiary: Color(0xFF34D399), // Light Green
      onTertiary: Color(0xFF1F2937),
      tertiaryContainer: Color(0xFF047857),
      onTertiaryContainer: Color(0xFFECFDF5),
      error: Color(0xFFF87171),
      onError: Color(0xFF1F2937),
      errorContainer: Color(0xFF7F1D1D),
      onErrorContainer: Color(0xFFFEE2E2),
      surface: Color(0xFF1E293B),
      onSurface: Color(0xFFF8FAFC),
      surfaceContainerHighest: Color(0xFF334155),
      onSurfaceVariant: Color(0xFFCBD5E1),
      outline: Color(0xFF64748B),
      outlineVariant: Color(0xFF475569),
      shadow: Colors.black,
      scrim: Colors.black,
      inverseSurface: Color(0xFFF1F5F9),
      onInverseSurface: Color(0xFF1E293B),
      inversePrimary: Color(0xFF6B46C1),
    ),

    // Custom dark text theme
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 57,
        fontWeight: FontWeight.bold,
        color: Color(0xFFF1F5F9),
        fontFamily: 'serif',
      ),
      displayMedium: TextStyle(
        fontSize: 45,
        fontWeight: FontWeight.bold,
        color: Color(0xFFE2E8F0),
      ),
      displaySmall: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.w600,
        color: Color(0xFFCBD5E1),
      ),
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: Color(0xFF8B5CF6),
        letterSpacing: -0.5,
      ),
      headlineMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: Color(0xFF8B5CF6),
      ),
      headlineSmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: Color(0xFFE2E8F0),
      ),
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        color: Color(0xFFF8FAFC),
        letterSpacing: 0,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Color(0xFFE2E8F0),
        letterSpacing: 0.15,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Color(0xFFCBD5E1),
        letterSpacing: 0.1,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: Color(0xFFF1F5F9),
        letterSpacing: 0.5,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: Color(0xFFE2E8F0),
        letterSpacing: 0.25,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: Color(0xFF94A3B8),
        letterSpacing: 0.4,
      ),
    ),

    // Custom dark app bar theme
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF8B5CF6),
      foregroundColor: Color(0xFF1F2937),
      elevation: 4,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Color(0xFF1F2937),
      ),
    ),

    // Custom dark elevated button theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF8B5CF6),
        foregroundColor: const Color(0xFF1F2937),
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),

    // Custom dark card theme
    cardTheme: CardThemeData(
      color: const Color(0xFF1E293B),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.all(8),
    ),
  );
}

// Theme mode provider with three options
final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);

class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    return ThemeMode.system;
  }

  void setThemeMode(ThemeMode mode) {
    state = mode;
  }

  void toggleTheme() {
    switch (state) {
      case ThemeMode.light:
        state = ThemeMode.dark;
        break;
      case ThemeMode.dark:
        state = ThemeMode.system;
        break;
      case ThemeMode.system:
        state = ThemeMode.light;
        break;
    }
  }

  String get currentThemeName {
    switch (state) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }

  IconData get currentThemeIcon {
    switch (state) {
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
      case ThemeMode.system:
        return Icons.brightness_auto;
    }
  }
}

// Custom painter that adapts to theme
class CirclePainter extends CustomPainter {
  final ColorScheme colorScheme;

  CirclePainter({required this.colorScheme});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 4.0;

    // Use theme colors directly
    paint.color = colorScheme.primary;
    canvas.drawCircle(Offset(size.width * 0.2, size.height * 0.3), 50, paint);

    paint.color = colorScheme.secondary;
    canvas.drawCircle(Offset(size.width * 0.7, size.height * 0.4), 40, paint);

    paint.color = colorScheme.tertiary;
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.7), 45, paint);

    // Draw connecting lines using outline color
    paint.color = colorScheme.outline;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 3.0;

    canvas.drawLine(
      Offset(size.width * 0.2, size.height * 0.3),
      Offset(size.width * 0.7, size.height * 0.4),
      paint,
    );

    canvas.drawLine(
      Offset(size.width * 0.7, size.height * 0.4),
      Offset(size.width * 0.5, size.height * 0.7),
      paint,
    );

    canvas.drawLine(
      Offset(size.width * 0.5, size.height * 0.7),
      Offset(size.width * 0.2, size.height * 0.3),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'Custom Theme Demo',
      themeMode: themeMode,
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final themeNotifier = ref.read(themeModeProvider.notifier);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Theme Demo'),
        actions: [
          PopupMenuButton<ThemeMode>(
            icon: Icon(themeNotifier.currentThemeIcon),
            onSelected: (ThemeMode mode) {
              themeNotifier.setThemeMode(mode);
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<ThemeMode>>[
              const PopupMenuItem<ThemeMode>(
                value: ThemeMode.light,
                child: Row(
                  children: [
                    Icon(Icons.light_mode),
                    SizedBox(width: 8),
                    Text('Light'),
                  ],
                ),
              ),
              const PopupMenuItem<ThemeMode>(
                value: ThemeMode.dark,
                child: Row(
                  children: [
                    Icon(Icons.dark_mode),
                    SizedBox(width: 8),
                    Text('Dark'),
                  ],
                ),
              ),
              const PopupMenuItem<ThemeMode>(
                value: ThemeMode.system,
                child: Row(
                  children: [
                    Icon(Icons.brightness_auto),
                    SizedBox(width: 8),
                    Text('System'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Theme info card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Theme: ${themeNotifier.currentThemeName}',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'This demonstrates custom ThemeData with personalized colors, typography, and component styles. Choose between Light, Dark, or System theme.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () => themeNotifier.toggleTheme(),
                          child: const Text('Cycle Theme'),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Tap the icon in app bar for options',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Theme selection buttons
                    Row(
                      children: [
                        _ThemeButton(
                          mode: ThemeMode.light,
                          label: 'Light',
                          icon: Icons.light_mode,
                          currentMode: themeMode,
                          onPressed: () =>
                              themeNotifier.setThemeMode(ThemeMode.light),
                        ),
                        const SizedBox(width: 8),
                        _ThemeButton(
                          mode: ThemeMode.dark,
                          label: 'Dark',
                          icon: Icons.dark_mode,
                          currentMode: themeMode,
                          onPressed: () =>
                              themeNotifier.setThemeMode(ThemeMode.dark),
                        ),
                        const SizedBox(width: 8),
                        _ThemeButton(
                          mode: ThemeMode.system,
                          label: 'System',
                          icon: Icons.brightness_auto,
                          currentMode: themeMode,
                          onPressed: () =>
                              themeNotifier.setThemeMode(ThemeMode.system),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Typography showcase
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Typography Styles',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Display Large',
                      style: Theme.of(
                        context,
                      ).textTheme.displayLarge?.copyWith(fontSize: 28),
                    ),
                    Text(
                      'Headline Large',
                      style: Theme.of(
                        context,
                      ).textTheme.headlineLarge?.copyWith(fontSize: 20),
                    ),
                    Text(
                      'Title Large',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      'Body Large - This is regular body text with custom styling',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text(
                      'Body Medium - Smaller body text',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      'Body Small - Caption text',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Custom painter showcase
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Custom Painter with Theme Colors',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 300,
                      child: CustomPaint(
                        painter: CirclePainter(colorScheme: colorScheme),
                        child: Container(),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Color palette preview
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Custom Color Palette',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _ColorSwatch(
                          color: colorScheme.primary,
                          label: 'Primary',
                          textColor: colorScheme.onPrimary,
                        ),
                        _ColorSwatch(
                          color: colorScheme.secondary,
                          label: 'Secondary',
                          textColor: colorScheme.onSecondary,
                        ),
                        _ColorSwatch(
                          color: colorScheme.tertiary,
                          label: 'Tertiary',
                          textColor: colorScheme.onTertiary,
                        ),
                        _ColorSwatch(
                          color: colorScheme.surface,
                          label: 'Surface',
                          textColor: colorScheme.onSurface,
                        ),
                        _ColorSwatch(
                          color: colorScheme.surface,
                          label: 'Background',
                          textColor: colorScheme.onSurface,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => themeNotifier.toggleTheme(),
        child: Icon(themeNotifier.currentThemeIcon),
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

class _ColorSwatch extends StatelessWidget {
  final Color color;
  final Color textColor;
  final String label;

  const _ColorSwatch({
    required this.color,
    required this.textColor,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 60,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline,
          width: 1,
        ),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: textColor,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
