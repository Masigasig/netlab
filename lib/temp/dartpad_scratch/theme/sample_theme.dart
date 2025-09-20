import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Theme mode provider
final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);

class ThemeModeNotifier extends Notifier<ThemeMode> {
  // ThemeModeNotifier() : super(ThemeMode.light);

  @override
  ThemeMode build() {
    return ThemeMode.light;
  }

  void toggleTheme() {
    state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }
}

// Custom painter that adapts to theme
class CirclePainter extends CustomPainter {
  final bool isDarkMode;

  CirclePainter({required this.isDarkMode});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 4.0;

    // Different colors based on theme
    final primaryColor = isDarkMode ? Colors.cyanAccent : Colors.blue;
    final secondaryColor = isDarkMode ? Colors.purpleAccent : Colors.orange;
    final accentColor = isDarkMode ? Colors.pinkAccent : Colors.green;

    // Draw circles with theme-aware colors
    paint.color = primaryColor;
    canvas.drawCircle(Offset(size.width * 0.2, size.height * 0.3), 50, paint);

    paint.color = secondaryColor;
    canvas.drawCircle(Offset(size.width * 0.7, size.height * 0.4), 40, paint);

    paint.color = accentColor;
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.7), 45, paint);

    // Draw connecting lines
    paint.color = isDarkMode ? Colors.white54 : Colors.black54;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 2.0;

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
      title: 'Theme Toggle with Custom Painter',
      themeMode: themeMode,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.cyan,
          brightness: Brightness.dark,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final isDarkMode = themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Toggle Demo'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => ref.read(themeModeProvider.notifier).toggleTheme(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Theme toggle card
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Current Mode: ${isDarkMode ? 'Dark' : 'Light'}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Switch(
                  value: isDarkMode,
                  onChanged: (_) =>
                      ref.read(themeModeProvider.notifier).toggleTheme(),
                ),
              ],
            ),
          ),

          // Custom painter showcase
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    // ignore: deprecated_member_use
                    color: Theme.of(context).shadowColor.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Custom Painter with Theme Colors',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  Expanded(
                    child: CustomPaint(
                      painter: CirclePainter(isDarkMode: isDarkMode),
                      child: Container(),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Color palette preview
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Theme Colors:',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _ColorSwatch(
                      color: isDarkMode ? Colors.cyanAccent : Colors.blue,
                      label: 'Primary',
                    ),
                    const SizedBox(width: 12),
                    _ColorSwatch(
                      color: isDarkMode ? Colors.purpleAccent : Colors.orange,
                      label: 'Secondary',
                    ),
                    const SizedBox(width: 12),
                    _ColorSwatch(
                      color: isDarkMode ? Colors.pinkAccent : Colors.green,
                      label: 'Accent',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ref.read(themeModeProvider.notifier).toggleTheme(),
        child: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
      ),
    );
  }
}

class _ColorSwatch extends StatelessWidget {
  final Color color;
  final String label;

  const _ColorSwatch({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(
              color: Theme.of(context).colorScheme.outline,
              width: 1,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
