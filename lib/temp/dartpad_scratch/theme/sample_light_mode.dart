// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ethereal Blues Demo',
      theme: ThemeData(
        // Primary colors - Ethereal Blue theme
        primarySwatch: const MaterialColor(0xFF3B82F6, {
          50: Color(0xFFFAFBFF),
          100: Color(0xFFE0F2FE),
          200: Color(0xFFBAE6FD),
          300: Color(0xFF7DD3FC),
          400: Color(0xFF38BDF8),
          500: Color(0xFF3B82F6),
          600: Color(0xFF0284C7),
          700: Color(0xFF0369A1),
          800: Color(0xFF075985),
          900: Color(0xFF0C4A6E),
        }),

        // Background colors
        scaffoldBackgroundColor: const Color(0xFFFAFBFF), // Almost white blue
        cardColor: const Color(0xFFFFFFFF),

        // Text colors
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.bold,
          ),
          headlineMedium: TextStyle(
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.w600,
          ),
          bodyLarge: TextStyle(color: Color(0xFF1E293B)),
          bodyMedium: TextStyle(color: Color(0xFF64748B)),
          labelLarge: TextStyle(
            color: Color(0xFFFFFFFF),
            fontWeight: FontWeight.w500,
          ),
        ),

        // Component themes
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFFFFFF),
          foregroundColor: Color(0xFF1E293B),
          elevation: 1,
          shadowColor: Color(0xFFE0F2FE),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF3B82F6),
            foregroundColor: const Color(0xFFFFFFFF),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),

        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF3B82F6),
            side: const BorderSide(color: Color(0xFFE0F2FE)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),

        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFE0F2FE)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFE0F2FE)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2),
          ),
          fillColor: const Color(0xFFFFFFFF),
          filled: true,
          labelStyle: const TextStyle(color: Color(0xFF64748B)),
          hintStyle: const TextStyle(color: Color(0xFF64748B)),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ethereal Blues'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
          CircleAvatar(
            radius: 16,
            backgroundColor: const Color(0xFF3B82F6).withOpacity(0.1),
            child: const Icon(
              Icons.person_outline,
              size: 20,
              color: Color(0xFF3B82F6),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero section with ethereal gradient
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF3B82F6).withOpacity(0.08),
                    const Color(0xFF06B6D4).withOpacity(0.04),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFFE0F2FE).withOpacity(0.5),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3B82F6),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF3B82F6).withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.waves,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 20),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ethereal Experience',
                              style: TextStyle(
                                color: Color(0xFF1E293B),
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Soft, calming, and otherworldly design',
                              style: TextStyle(
                                color: Color(0xFF64748B),
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Color palette showcase
            Text(
              'Ethereal Blues Palette',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE0F2FE)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF3B82F6).withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildColorRow(
                    'Primary Blue',
                    const Color(0xFF3B82F6),
                    '#3B82F6',
                  ),
                  _buildColorRow(
                    'Cyan Accent',
                    const Color(0xFF06B6D4),
                    '#06B6D4',
                  ),
                  _buildColorRow(
                    'Light Sky',
                    const Color(0xFFE0F2FE),
                    '#E0F2FE',
                  ),
                  _buildColorRow(
                    'Ocean White',
                    const Color(0xFFFAFBFF),
                    '#FAFBFF',
                  ),
                  _buildColorRow(
                    'Text Primary',
                    const Color(0xFF1E293B),
                    '#1E293B',
                  ),
                  _buildColorRow(
                    'Text Secondary',
                    const Color(0xFF64748B),
                    '#64748B',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Floating status cards
            Text(
              'Analytics Overview',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _buildFloatingCard(
                    'Wave Interactions',
                    '2,847',
                    Icons.trending_up,
                    const Color(0xFF3B82F6),
                    '+15.3%',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildFloatingCard(
                    'Flow Rate',
                    '94.2%',
                    Icons.water_drop,
                    const Color(0xFF06B6D4),
                    '+2.1%',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _buildGlassCard(
                    'Active Sessions',
                    '1,429',
                    Icons.blur_on,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildGlassCard(
                    'Peaceful Users',
                    '856',
                    Icons.self_improvement,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Ethereal action buttons
            Text(
              'Serene Actions',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add_circle_outline),
                    label: const Text('Create Flow'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                      shadowColor: const Color(0xFF3B82F6).withOpacity(0.3),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.auto_awesome),
                    label: const Text('Begin Journey'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF06B6D4),
                      foregroundColor: const Color(0xFFFFFFFF),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.cloud_upload_outlined),
                label: const Text('Upload to Cloud'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: const BorderSide(color: Color(0xFFE0F2FE)),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Dreamy form section
            Text(
              'Create Your Experience',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE0F2FE)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF3B82F6).withOpacity(0.06),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Experience Name',
                      hintText: 'Name your ethereal journey',
                      prefixIcon: const Icon(
                        Icons.waves,
                        color: Color(0xFF3B82F6),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Description',
                      hintText:
                          'Describe the serene atmosphere you want to create',
                      prefixIcon: const Icon(
                        Icons.edit_note,
                        color: Color(0xFF06B6D4),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Save Draft'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Launch Experience'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF3B82F6).withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          selectedItemColor: const Color(0xFF3B82F6),
          unselectedItemColor: const Color(0xFF64748B),
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.waves),
              activeIcon: Icon(Icons.waves),
              label: 'Flow',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore_outlined),
              activeIcon: Icon(Icons.explore),
              label: 'Explore',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.analytics_outlined),
              activeIcon: Icon(Icons.analytics),
              label: 'Insights',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.self_improvement_outlined),
              activeIcon: Icon(Icons.self_improvement),
              label: 'Zen',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorRow(String name, Color color, String hex) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE0F2FE)),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Color(0xFF1E293B),
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
                Text(
                  hex,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 13,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingCard(
    String title,
    String value,
    IconData icon,
    Color color,
    String change,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white.withOpacity(0.9), size: 24),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  change,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFE0F2FE).withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE0F2FE).withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF3B82F6), size: 24),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF3B82F6).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.more_horiz,
                  color: Color(0xFF3B82F6),
                  size: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF1E293B),
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(color: Color(0xFF64748B), fontSize: 14),
          ),
        ],
      ),
    );
  }
}
