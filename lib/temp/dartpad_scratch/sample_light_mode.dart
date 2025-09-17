import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ethereal Blues Demo',
      theme: ThemeData(
        // Primary colors - Ethereal Blue theme
        primarySwatch: MaterialColor(0xFF3B82F6, {
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
        scaffoldBackgroundColor: Color(0xFFFAFBFF), // Almost white blue
        cardColor: Color(0xFFFFFFFF),
        
        // Text colors
        textTheme: TextTheme(
          headlineLarge: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold),
          headlineMedium: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.w600),
          bodyLarge: TextStyle(color: Color(0xFF1E293B)),
          bodyMedium: TextStyle(color: Color(0xFF64748B)),
          labelLarge: TextStyle(color: Color(0xFFFFFFFF), fontWeight: FontWeight.w500),
        ),
        
        // Component themes
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFFFFFFFF),
          foregroundColor: Color(0xFF1E293B),
          elevation: 1,
          shadowColor: Color(0xFFE0F2FE),
        ),
        
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF3B82F6),
            foregroundColor: Color(0xFFFFFFFF),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: Color(0xFF3B82F6),
            side: BorderSide(color: Color(0xFFE0F2FE)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Color(0xFFE0F2FE)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Color(0xFFE0F2FE)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Color(0xFF3B82F6), width: 2),
          ),
          fillColor: Color(0xFFFFFFFF),
          filled: true,
          labelStyle: TextStyle(color: Color(0xFF64748B)),
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
        title: Text('Ethereal Blues'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none),
            onPressed: () {},
          ),
          CircleAvatar(
            radius: 16,
            backgroundColor: Color(0xFF3B82F6).withOpacity(0.1),
            child: Icon(
              Icons.person_outline,
              size: 20,
              color: Color(0xFF3B82F6),
            ),
          ),
          SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero section with ethereal gradient
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(28),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF3B82F6).withOpacity(0.08),
                    Color(0xFF06B6D4).withOpacity(0.04),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Color(0xFFE0F2FE).withOpacity(0.5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Color(0xFF3B82F6),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF3B82F6).withOpacity(0.3),
                              blurRadius: 12,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.waves,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
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
            
            SizedBox(height: 32),
            
            // Color palette showcase
            Text(
              'Ethereal Blues Palette',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 16),
            
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Color(0xFFE0F2FE)),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF3B82F6).withOpacity(0.04),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildColorRow('Primary Blue', Color(0xFF3B82F6), '#3B82F6'),
                  _buildColorRow('Cyan Accent', Color(0xFF06B6D4), '#06B6D4'),
                  _buildColorRow('Light Sky', Color(0xFFE0F2FE), '#E0F2FE'),
                  _buildColorRow('Ocean White', Color(0xFFFAFBFF), '#FAFBFF'),
                  _buildColorRow('Text Primary', Color(0xFF1E293B), '#1E293B'),
                  _buildColorRow('Text Secondary', Color(0xFF64748B), '#64748B'),
                ],
              ),
            ),
            
            SizedBox(height: 32),
            
            // Floating status cards
            Text(
              'Analytics Overview',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: _buildFloatingCard(
                    'Wave Interactions',
                    '2,847',
                    Icons.trending_up,
                    Color(0xFF3B82F6),
                    '+15.3%',
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildFloatingCard(
                    'Flow Rate',
                    '94.2%',
                    Icons.water_drop,
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
                  child: _buildGlassCard(
                    'Active Sessions',
                    '1,429',
                    Icons.blur_on,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildGlassCard(
                    'Peaceful Users',
                    '856',
                    Icons.self_improvement,
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 32),
            
            // Ethereal action buttons
            Text(
              'Serene Actions',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.add_circle_outline),
                    label: Text('Create Flow'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                      shadowColor: Color(0xFF3B82F6).withOpacity(0.3),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.auto_awesome),
                    label: Text('Begin Journey'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF06B6D4),
                      foregroundColor: Color(0xFFFFFFFF),
                      padding: EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
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
                label: Text('Upload to Cloud'),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: BorderSide(color: Color(0xFFE0F2FE)),
                ),
              ),
            ),
            
            SizedBox(height: 32),
            
            // Dreamy form section
            Text(
              'Create Your Experience',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 16),
            
            Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Color(0xFFE0F2FE)),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF3B82F6).withOpacity(0.06),
                    blurRadius: 20,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Experience Name',
                      hintText: 'Name your ethereal journey',
                      prefixIcon: Icon(Icons.waves, color: Color(0xFF3B82F6)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Description',
                      hintText: 'Describe the serene atmosphere you want to create',
                      prefixIcon: Icon(Icons.edit_note, color: Color(0xFF06B6D4)),
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
                          child: Text('Save Draft'),
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
                          child: Text('Launch Experience'),
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
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Color(0xFFFFFFFF),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF3B82F6).withOpacity(0.08),
              blurRadius: 12,
              offset: Offset(0, -4),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          selectedItemColor: Color(0xFF3B82F6),
          unselectedItemColor: Color(0xFF64748B),
          elevation: 0,
          items: [
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
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Color(0xFFE0F2FE)),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.2),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
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
                    color: Color(0xFF1E293B),
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
                Text(
                  hex,
                  style: TextStyle(
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
  
  Widget _buildFloatingCard(String title, String value, IconData icon, Color color, String change) {
    return Container(
      padding: EdgeInsets.all(20),
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
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white.withOpacity(0.9), size: 24),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  change,
                  style: TextStyle(
                    color: Colors.white,
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
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
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
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFFE0F2FE).withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Color(0xFFE0F2FE).withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Color(0xFF3B82F6), size: 24),
              Spacer(),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFF3B82F6).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.more_horiz,
                  color: Color(0xFF3B82F6),
                  size: 16,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            value,
            style: TextStyle(
              color: Color(0xFF1E293B),
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: Color(0xFF64748B),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
