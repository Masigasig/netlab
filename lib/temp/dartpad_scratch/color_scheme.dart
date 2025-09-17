// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ColorScheme Usage Demo',
      theme: ThemeData(colorScheme: lightColorScheme, useMaterial3: true),
      darkTheme: ThemeData(colorScheme: darkColorScheme, useMaterial3: true),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: ColorSchemeUsageDemo(
        onThemeToggle: () {
          setState(() {
            isDarkMode = !isDarkMode;
          });
        },
        isDarkMode: isDarkMode,
      ),
    );
  }
}

// Light Theme ColorScheme
const ColorScheme lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF1976D2),
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFFBBDEFB),
  onPrimaryContainer: Color(0xFF0D47A1),
  primaryFixed: Color(0xFF2196F3),
  primaryFixedDim: Color(0xFF1976D2),
  onPrimaryFixed: Color(0xFFFFFFFF),
  onPrimaryFixedVariant: Color(0xFF0D47A1),
  secondary: Color(0xFF9C27B0),
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFFE1BEE7),
  onSecondaryContainer: Color(0xFF4A148C),
  secondaryFixed: Color(0xFFBA68C8),
  secondaryFixedDim: Color(0xFF9C27B0),
  onSecondaryFixed: Color(0xFFFFFFFF),
  onSecondaryFixedVariant: Color(0xFF4A148C),
  tertiary: Color(0xFFFF9800),
  onTertiary: Color(0xFFFFFFFF),
  tertiaryContainer: Color(0xFFFFE0B2),
  onTertiaryContainer: Color(0xFFE65100),
  tertiaryFixed: Color(0xFFFFB74D),
  tertiaryFixedDim: Color(0xFFFF9800),
  onTertiaryFixed: Color(0xFFFFFFFF),
  onTertiaryFixedVariant: Color(0xFFE65100),
  error: Color(0xFFD32F2F),
  onError: Color(0xFFFFFFFF),
  errorContainer: Color(0xFFFFCDD2),
  onErrorContainer: Color(0xFFB71C1C),
  surface: Color(0xFFFFFBFE),
  onSurface: Color(0xFF1C1B1F),
  surfaceDim: Color(0xFFE7E0EC),
  surfaceBright: Color(0xFFFFFBFE),
  surfaceContainerLowest: Color(0xFFFFFFFF),
  surfaceContainerLow: Color(0xFFF7F2FA),
  surfaceContainer: Color(0xFFF3EDF7),
  surfaceContainerHigh: Color(0xFFECE6F0),
  surfaceContainerHighest: Color(0xFFE6E0E9),
  onSurfaceVariant: Color(0xFF49454F),
  outline: Color(0xFF79747E),
  outlineVariant: Color(0xFFCAC4D0),
  shadow: Color(0xFF000000),
  scrim: Color(0xFF000000),
  inverseSurface: Color(0xFF313033),
  onInverseSurface: Color(0xFFF4EFF4),
  inversePrimary: Color(0xFF90CAF9),
  surfaceTint: Color(0xFF1976D2),
);

// Dark Theme ColorScheme
const ColorScheme darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFF90CAF9),
  onPrimary: Color(0xFF0D47A1),
  primaryContainer: Color(0xFF1565C0),
  onPrimaryContainer: Color(0xFFBBDEFB),
  primaryFixed: Color(0xFF2196F3),
  primaryFixedDim: Color(0xFF1976D2),
  onPrimaryFixed: Color(0xFFFFFFFF),
  onPrimaryFixedVariant: Color(0xFF0D47A1),
  secondary: Color(0xFFCE93D8),
  onSecondary: Color(0xFF4A148C),
  secondaryContainer: Color(0xFF7B1FA2),
  onSecondaryContainer: Color(0xFFE1BEE7),
  secondaryFixed: Color(0xFFBA68C8),
  secondaryFixedDim: Color(0xFF9C27B0),
  onSecondaryFixed: Color(0xFFFFFFFF),
  onSecondaryFixedVariant: Color(0xFF4A148C),
  tertiary: Color(0xFFFFCC02),
  onTertiary: Color(0xFFE65100),
  tertiaryContainer: Color(0xFFFF8F00),
  onTertiaryContainer: Color(0xFFFFE0B2),
  tertiaryFixed: Color(0xFFFFB74D),
  tertiaryFixedDim: Color(0xFFFF9800),
  onTertiaryFixed: Color(0xFFFFFFFF),
  onTertiaryFixedVariant: Color(0xFFE65100),
  error: Color(0xFFEF9A9A),
  onError: Color(0xFFB71C1C),
  errorContainer: Color(0xFFC62828),
  onErrorContainer: Color(0xFFFFCDD2),
  surface: Color(0xFF1C1B1F),
  onSurface: Color(0xFFE6E1E5),
  surfaceDim: Color(0xFF141218),
  surfaceBright: Color(0xFF3B383E),
  surfaceContainerLowest: Color(0xFF0F0D13),
  surfaceContainerLow: Color(0xFF1D1B20),
  surfaceContainer: Color(0xFF211F26),
  surfaceContainerHigh: Color(0xFF2B2930),
  surfaceContainerHighest: Color(0xFF36343B),
  onSurfaceVariant: Color(0xFFCAC4D0),
  outline: Color(0xFF938F99),
  outlineVariant: Color(0xFF49454F),
  shadow: Color(0xFF000000),
  scrim: Color(0xFF000000),
  inverseSurface: Color(0xFFE6E1E5),
  onInverseSurface: Color(0xFF313033),
  inversePrimary: Color(0xFF1976D2),
  surfaceTint: Color(0xFF90CAF9),
);

class ColorSchemeUsageDemo extends StatelessWidget {
  final VoidCallback onThemeToggle;
  final bool isDarkMode;

  const ColorSchemeUsageDemo({
    super.key,
    required this.onThemeToggle,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Where Colors Are Used'),
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
          actions: [
            Switch(value: isDarkMode, onChanged: (value) => onThemeToggle()),
            const SizedBox(width: 16),
          ],
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Primary'),
              Tab(text: 'Secondary'),
              Tab(text: 'Tertiary'),
              Tab(text: 'Error'),
              Tab(text: 'Surface'),
              Tab(text: 'Utility'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _PrimaryColorsTab(),
            _SecondaryColorsTab(),
            _TertiaryColorsTab(),
            _ErrorColorsTab(),
            _SurfaceColorsTab(),
            _UtilityColorsTab(),
          ],
        ),
      ),
    );
  }
}

class _PrimaryColorsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildUsageSection(
            context,
            'primary',
            'Main action buttons, FAB, active states',
            colorScheme.primary,
            colorScheme.onPrimary,
            [
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                ),
                child: const Text('Primary Button'),
              ),
              const SizedBox(height: 8),
              FloatingActionButton(
                onPressed: () {},
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                child: const Icon(Icons.add),
              ),
              const SizedBox(height: 8),
              Switch(
                value: true,
                onChanged: (value) {},
                activeThumbColor: colorScheme.primary,
              ),
              const SizedBox(height: 8),
              Slider(
                value: 0.5,
                onChanged: (value) {},
                activeColor: colorScheme.primary,
              ),
            ],
          ),

          _buildUsageSection(
            context,
            'primaryContainer',
            'App bars, selected navigation items, input field focus',
            colorScheme.primaryContainer,
            colorScheme.onPrimaryContainer,
            [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'App Bar Background',
                      style: TextStyle(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'This is what your app bar looks like',
                      style: TextStyle(color: colorScheme.onPrimaryContainer),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              NavigationBar(
                selectedIndex: 0,
                backgroundColor: colorScheme.surface,
                destinations: [
                  NavigationDestination(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        Icons.home,
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                    label: 'Home',
                  ),
                  const NavigationDestination(
                    icon: Icon(Icons.search),
                    label: 'Search',
                  ),
                  const NavigationDestination(
                    icon: Icon(Icons.person),
                    label: 'Profile',
                  ),
                ],
              ),
            ],
          ),

          _buildUsageSection(
            context,
            'primaryFixed',
            'Consistent branding elements (stays same in light/dark)',
            colorScheme.primaryFixed,
            colorScheme.onPrimaryFixed,
            [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.primaryFixed,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.business, color: colorScheme.onPrimaryFixed),
                    const SizedBox(width: 12),
                    Text(
                      'Brand Logo Area',
                      style: TextStyle(
                        color: colorScheme.onPrimaryFixed,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'This color stays consistent across light/dark themes for brand recognition',
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 12,
                ),
              ),
            ],
          ),

          _buildUsageSection(
            context,
            'primaryFixedDim',
            'Dimmed version of fixed primary for subtle branding',
            colorScheme.primaryFixedDim,
            colorScheme.onPrimaryFixedVariant,
            [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.primaryFixedDim,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Subtle Brand Element',
                  style: TextStyle(color: colorScheme.onPrimaryFixedVariant),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SecondaryColorsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildUsageSection(
            context,
            'secondary',
            'Secondary buttons, chips, progress indicators',
            colorScheme.secondary,
            colorScheme.onSecondary,
            [
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  backgroundColor: colorScheme.secondary,
                  foregroundColor: colorScheme.onSecondary,
                ),
                child: const Text('Secondary Action'),
              ),
              const SizedBox(height: 8),
              Chip(
                label: Text(
                  'Filter Chip',
                  style: TextStyle(color: colorScheme.onSecondary),
                ),
                backgroundColor: colorScheme.secondary,
              ),
              const SizedBox(height: 8),
              CircularProgressIndicator(
                color: colorScheme.secondary,
                strokeWidth: 3,
              ),
            ],
          ),

          _buildUsageSection(
            context,
            'secondaryContainer',
            'Cards, input fields, secondary content areas',
            colorScheme.secondaryContainer,
            colorScheme.onSecondaryContainer,
            [
              Card(
                color: colorScheme.secondaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Secondary Content Card',
                        style: TextStyle(
                          color: colorScheme.onSecondaryContainer,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'This card uses secondaryContainer for a subtle, secondary appearance',
                        style: TextStyle(
                          color: colorScheme.onSecondaryContainer,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Secondary Input',
                  filled: true,
                  fillColor: colorScheme.secondaryContainer,
                  labelStyle: TextStyle(
                    color: colorScheme.onSecondaryContainer,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: TextStyle(color: colorScheme.onSecondaryContainer),
              ),
            ],
          ),

          _buildUsageSection(
            context,
            'secondaryFixed',
            'Consistent secondary elements across themes',
            colorScheme.secondaryFixed,
            colorScheme.onSecondaryFixed,
            [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.secondaryFixed,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.star, color: colorScheme.onSecondaryFixed),
                    const SizedBox(width: 12),
                    Text(
                      'Fixed Secondary Brand Element',
                      style: TextStyle(
                        color: colorScheme.onSecondaryFixed,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TertiaryColorsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildUsageSection(
            context,
            'tertiary',
            'Accent elements, highlights, special features',
            colorScheme.tertiary,
            colorScheme.onTertiary,
            [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.tertiary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'NEW',
                  style: TextStyle(
                    color: colorScheme.onTertiary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.favorite),
                style: IconButton.styleFrom(
                  backgroundColor: colorScheme.tertiary,
                  foregroundColor: colorScheme.onTertiary,
                ),
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: 0.7,
                color: colorScheme.tertiary,
                backgroundColor: colorScheme.tertiaryContainer,
              ),
            ],
          ),

          _buildUsageSection(
            context,
            'tertiaryContainer',
            'Accent containers, highlight backgrounds',
            colorScheme.tertiaryContainer,
            colorScheme.onTertiaryContainer,
            [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.tertiaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.lightbulb,
                          color: colorScheme.onTertiaryContainer,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Pro Tip',
                          style: TextStyle(
                            color: colorScheme.onTertiaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'This is a highlighted tip or special information using tertiary container',
                      style: TextStyle(color: colorScheme.onTertiaryContainer),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              ListTile(
                tileColor: colorScheme.tertiaryContainer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                leading: Icon(
                  Icons.notifications,
                  color: colorScheme.onTertiaryContainer,
                ),
                title: Text(
                  'Special Notification',
                  style: TextStyle(color: colorScheme.onTertiaryContainer),
                ),
                subtitle: Text(
                  'Using tertiary container for emphasis',
                  style: TextStyle(
                    color: colorScheme.onTertiaryContainer.withOpacity(0.8),
                  ),
                ),
              ),
            ],
          ),

          _buildUsageSection(
            context,
            'tertiaryFixed',
            'Consistent accent elements across themes',
            colorScheme.tertiaryFixed,
            colorScheme.onTertiaryFixed,
            [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.tertiaryFixed,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.workspace_premium,
                      color: colorScheme.onTertiaryFixed,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Premium Feature',
                      style: TextStyle(
                        color: colorScheme.onTertiaryFixed,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ErrorColorsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildUsageSection(
            context,
            'error',
            'Error states, destructive actions',
            colorScheme.error,
            colorScheme.onError,
            [
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.error,
                  foregroundColor: colorScheme.onError,
                ),
                child: const Text('Delete'),
              ),
              const SizedBox(height: 8),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.delete),
                style: IconButton.styleFrom(
                  backgroundColor: colorScheme.error,
                  foregroundColor: colorScheme.onError,
                ),
              ),
              const SizedBox(height: 8),
              Icon(Icons.error, color: colorScheme.error, size: 32),
            ],
          ),

          _buildUsageSection(
            context,
            'errorContainer',
            'Error messages, validation feedback, alerts',
            colorScheme.errorContainer,
            colorScheme.onErrorContainer,
            [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: colorScheme.onErrorContainer,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Validation Error',
                            style: TextStyle(
                              color: colorScheme.onErrorContainer,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Please check the required fields and try again',
                            style: TextStyle(
                              color: colorScheme.onErrorContainer,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Invalid Input',
                  errorText: 'This field is required',
                  errorStyle: TextStyle(color: colorScheme.error),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: colorScheme.error, width: 2),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: colorScheme.error),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: colorScheme.errorContainer,
                      content: Text(
                        'Error occurred!',
                        style: TextStyle(color: colorScheme.onErrorContainer),
                      ),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.error,
                  foregroundColor: colorScheme.onError,
                ),
                child: const Text('Show Error Snackbar'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SurfaceColorsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildUsageSection(
            context,
            'surface',
            'Main background, scaffold background',
            colorScheme.surface,
            colorScheme.onSurface,
            [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  border: Border.all(color: colorScheme.outline),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Main App Background',
                  style: TextStyle(color: colorScheme.onSurface),
                ),
              ),
            ],
          ),

          _buildUsageSection(
            context,
            'surfaceContainer',
            'Cards, sheets, dialogs',
            colorScheme.surfaceContainer,
            colorScheme.onSurface,
            [
              Card(
                color: colorScheme.surfaceContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Regular Card Background',
                    style: TextStyle(color: colorScheme.onSurface),
                  ),
                ),
              ),
            ],
          ),

          _buildUsageSection(
            context,
            'surfaceContainerHigh',
            'Elevated cards, app bars',
            colorScheme.surfaceContainerHigh,
            colorScheme.onSurface,
            [
              Card(
                color: colorScheme.surfaceContainerHigh,
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Elevated Card Background',
                    style: TextStyle(color: colorScheme.onSurface),
                  ),
                ),
              ),
            ],
          ),

          _buildUsageSection(
            context,
            'surfaceContainerHighest',
            'Highest elevation elements, floating elements',
            colorScheme.surfaceContainerHighest,
            colorScheme.onSurface,
            [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.shadow.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  'Floating Action Sheet',
                  style: TextStyle(color: colorScheme.onSurface),
                ),
              ),
            ],
          ),

          _buildUsageSection(
            context,
            'onSurfaceVariant',
            'Secondary text, captions, disabled text',
            colorScheme.surface,
            colorScheme.onSurfaceVariant,
            [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  border: Border.all(color: colorScheme.outline),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Main Title',
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Subtitle or secondary information',
                      style: TextStyle(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Caption or helper text',
                      style: TextStyle(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _UtilityColorsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildUsageSection(
            context,
            'outline',
            'Borders, dividers, input field borders',
            colorScheme.surface,
            colorScheme.onSurface,
            [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: colorScheme.outline, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Container with outline border',
                  style: TextStyle(color: colorScheme.onSurface),
                ),
              ),
              const SizedBox(height: 8),
              Divider(color: colorScheme.outline, thickness: 1),
              const SizedBox(height: 8),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Outlined Input',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: colorScheme.outline),
                  ),
                ),
              ),
            ],
          ),

          _buildUsageSection(
            context,
            'outlineVariant',
            'Subtle borders, disabled borders',
            colorScheme.surface,
            colorScheme.onSurface,
            [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: colorScheme.outlineVariant),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Subtle border variant',
                  style: TextStyle(color: colorScheme.onSurface),
                ),
              ),
            ],
          ),

          _buildUsageSection(
            context,
            'inverseSurface',
            'Tooltips, snackbars, opposite theme elements',
            colorScheme.inverseSurface,
            colorScheme.onInverseSurface,
            [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.inverseSurface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.info, color: colorScheme.onInverseSurface),
                    const SizedBox(width: 8),
                    Text(
                      'Tooltip Text',
                      style: TextStyle(color: colorScheme.onInverseSurface),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Tooltip(
                message: 'This is a tooltip using inverse colors',
                decoration: BoxDecoration(
                  color: colorScheme.inverseSurface,
                  borderRadius: BorderRadius.circular(4),
                ),
                textStyle: TextStyle(color: colorScheme.onInverseSurface),
                child: Icon(Icons.help, color: colorScheme.primary),
              ),
            ],
          ),

          _buildUsageSection(
            context,
            'inversePrimary',
            'Primary elements on inverse surfaces',
            colorScheme.inverseSurface,
            colorScheme.inversePrimary,
            [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.inverseSurface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.star, color: colorScheme.inversePrimary),
                    const SizedBox(width: 12),
                    Text(
                      'Primary action on inverse surface',
                      style: TextStyle(
                        color: colorScheme.inversePrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          _buildUsageSection(
            context,
            'shadow & scrim',
            'Drop shadows, modal overlays, blur backgrounds',
            colorScheme.surface,
            colorScheme.onSurface,
            [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.shadow.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  'Card with shadow',
                  style: TextStyle(color: colorScheme.onSurface),
                ),
              ),
              const SizedBox(height: 16),
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 100,
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        'Background Content',
                        style: TextStyle(color: colorScheme.onPrimaryContainer),
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 100,
                    decoration: BoxDecoration(
                      color: colorScheme.scrim.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Modal with scrim overlay',
                          style: TextStyle(color: colorScheme.onSurface),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          _buildUsageSection(
            context,
            'surfaceTint',
            'Elevation tinting, dynamic color adjustments',
            colorScheme.surface,
            colorScheme.onSurface,
            [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color.alphaBlend(
                    colorScheme.surfaceTint.withOpacity(0.05),
                    colorScheme.surface,
                  ),
                  border: Border.all(color: colorScheme.outline),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Surface with Tint Applied',
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'This surface has a subtle tint applied for elevation effect',
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget _buildUsageSection(
  BuildContext context,
  String colorName,
  String usage,
  Color backgroundColor,
  Color textColor,
  List<Widget> examples,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    border: Border.all(color: textColor.withOpacity(0.3)),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        colorName,
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        usage,
                        style: TextStyle(
                          color: textColor.withOpacity(0.8),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Hex: #${backgroundColor.value.toRadixString(16).toUpperCase().padLeft(8, '0')}',
              style: TextStyle(
                color: textColor.withOpacity(0.7),
                fontSize: 10,
                fontFamily: 'monospace',
              ),
            ),
          ],
        ),
      ),

      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Usage Examples:',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 12),
            ...examples,
          ],
        ),
      ),

      const SizedBox(height: 24),
    ],
  );
}
