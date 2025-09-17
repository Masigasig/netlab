import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ethereal Blues Dark',
      theme: ThemeData(
        brightness: Brightness.dark,
        // Primary colors - Ethereal Blue Dark theme
        primarySwatch: MaterialColor(0xFF60A5FA, {
          50: Color(0xFF0F172A),
          100: Color(0xFF1E293B),
          200: Color(0xFF334155),
          300: Color(0xFF475569),
          400: Color(0xFF64748B),
          500: Color(0xFF60A5FA),
          600: Color(0xFF3B82F6),
          700: Color(0xFF2563EB),
          800: Color(0xFF1D4ED8),
          900: Color(0xFF1E40AF),
        }),
        
        colorScheme: ColorScheme.dark(
          primary: Color(0xFF60A5FA),
          secondary: Color(0xFF06B6D4),
          surface: Color(0xFF1E293B),
          background: Color(0xFF0F172A),
          onPrimary: Color(0xFF0F172A),
          onSecondary: Color(0xFF0F172A),
          onSurface: Color(0xFFF1F5F9),
          onBackground: Color(0xFFE2E8F0),
        ),
        
        // Background colors
        scaffoldBackgroundColor: Color(0xFF0F172A),
        cardColor: Color(0xFF1E293B),
        
        // Text theme
        textTheme: TextTheme(
          headlineLarge: TextStyle(color: Color(0xFFF1F5F9), fontWeight: FontWeight.bold),
          headlineMedium: TextStyle(color: Color(0xFFF1F5F9), fontWeight: FontWeight.w600),
          bodyLarge: TextStyle(color: Color(0xFFE2E8F0)),
          bodyMedium: TextStyle(color: Color(0xFF94A3B8)),
          labelLarge: TextStyle(color: Color(0xFFF1F5F9), fontWeight: FontWeight.w500),
        ),
        
        // Component themes
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF1E293B),
          foregroundColor: Color(0xFFF1F5F9),
          elevation: 0,
        ),
        
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF60A5FA),
            foregroundColor: Color(0xFF0F172A),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: Color(0xFF60A5FA),
            side: BorderSide(color: Color(0xFF334155)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Color(0xFF334155)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Color(0xFF334155)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Color(0xFF60A5FA), width: 2),
          ),
          fillColor: Color(0xFF1E293B),
          filled: true,
          labelStyle: TextStyle(color: Color(0xFF94A3B8)),
          hintStyle: TextStyle(color: Color(0xFF64748B)),
        ),
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ethereal Blues Dark'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none),
            onPressed: () {},
          ),
          Container(
            margin: EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: Color(0xFF60A5FA).withOpacity(0.2),
              child: Icon(
                Icons.person_outline,
                size: 20,
                color: Color(0xFF60A5FA),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero section
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(28),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF60A5FA).withOpacity(0.15),
                    Color(0xFF06B6D4).withOpacity(0.08),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Color(0xFF334155).withOpacity(0.5)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color(0xFF60A5FA),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      Icons.nightlight_round,
                      color: Color(0xFF0F172A),
                      size: 28,
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ethereal Night Mode',
                          style: TextStyle(
                            color: Color(0xFFF1F5F9),
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Deep blues meet celestial tranquility',
                          style: TextStyle(
                            color: Color(0xFF94A3B8),
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 32),
            
            // Color palette showcase
            Text(
              'Dark Ethereal Palette',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 16),
            
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Color(0xFF334155)),
              ),
              child: Column(
                children: [
                  _buildColorRow('Light Blue', Color(0xFF60A5FA), '#60A5FA'),
                  _buildColorRow('Cyan Accent', Color(0xFF06B6D4), '#06B6D4'),
                  _buildColorRow('Deep Navy', Color(0xFF0F172A), '#0F172A'),
                  _buildColorRow('Slate Card', Color(0xFF1E293B), '#1E293B'),
                  _buildColorRow('Border Gray', Color(0xFF334155), '#334155'),
                  _buildColorRow('Text Light', Color(0xFFF1F5F9), '#F1F5F9'),
                ],
              ),
            ),
            
            SizedBox(height: 32),
            
            // Status cards
            Text(
              'Nocturnal Analytics',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: _buildGlowingCard(
                    'Moon Phases',
                    '2,847',
                    Icons.brightness_3,
                    Color(0xFF60A5FA),
                    '+15.3%',
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildGlowingCard(
                    'Star Energy',
                    '94.2%',
                    Icons.auto_awesome,
                    Color(0xFF06B6D4),
                    '+2.1%',
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: _buildDarkGlassCard(
                    'Night Sessions',
                    '1,429',
                    Icons.bedtime,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildDarkGlassCard(
                    'Dream State',
                    '856',
                    Icons.cloud,
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 32),
            
            // Action buttons
            Text(
              'Midnight Actions',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.add_circle_outline),
                    label: Text('Create Dream'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.explore),
                    label: Text('Night Journey'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF06B6D4),
                      foregroundColor: Color(0xFF0F172A),
                      padding: EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 16),
            
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.cloud_upload_outlined),
                label: Text('Upload to Cosmos'),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            
            SizedBox(height: 32),
            
            // Form section
            Text(
              'Conjure Your Vision',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 16),
            
            Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Color(0xFF334155)),
              ),
              child: Column(
                children: [
                  TextField(
                    style: TextStyle(color: Color(0xFFE2E8F0)),
                    decoration: InputDecoration(
                      labelText: 'Vision Name',
                      hintText: 'Name your ethereal creation',
                      prefixIcon: Icon(Icons.nightlight_round, color: Color(0xFF60A5FA)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    style: TextStyle(color: Color(0xFFE2E8F0)),
                    decoration: InputDecoration(
                      labelText: 'Mystical Description',
                      hintText: 'Describe the otherworldly atmosphere',
                      prefixIcon: Icon(Icons.auto_awesome, color: Color(0xFF06B6D4)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    maxLines: 3,
                  ),
                  SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {},
                          child: Text('Save to Dreams'),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          child: Text('Manifest Vision'),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color(0xFF1E293B),
        selectedItemColor: Color(0xFF60A5FA),
        unselectedItemColor: Color(0xFF64748B),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.nightlight_round),
            label: 'Night',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insights_outlined),
            label: 'Visions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bedtime_outlined),
            label: 'Dreams',
          ),
        ],
      ),
    );
  }
  
  Widget _buildColorRow(String name, Color color, String hex) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Color(0xFF334155)),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: Color(0xFFF1F5F9),
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
                Text(
                  hex,
                  style: TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildGlowingCard(String title, String value, IconData icon, Color color, String change) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  change,
                  style: TextStyle(
                    color: color,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            value,
            style: TextStyle(
              color: Color(0xFFF1F5F9),
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: Color(0xFF94A3B8),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildDarkGlassCard(String title, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFF334155).withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Color(0xFF475569).withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Color(0xFF60A5FA), size: 24),
              Spacer(),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFF60A5FA).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.more_horiz,
                  color: Color(0xFF60A5FA),
                  size: 16,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            value,
            style: TextStyle(
              color: Color(0xFFF1F5F9),
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: Color(0xFF94A3B8),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}