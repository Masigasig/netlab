import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Colors
  static const Color primary = Color(0xFF6C63FF);
  static const Color secondary = Color(0xFFD77EFF);
  static const Color accent = Color(0xFFFF4D94);
  
  // Background Colors
  static const Color background = Color(0xFF0B0F1E);
  static const Color overlay = Color(0x4D000000); // Colors.black.withOpacity(0.3)
  
  // Text Colors
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xB3FFFFFF); // Colors.white70
  
  // UI Element Colors for page indicator
  static const Color active = Colors.blue;
  static const Color inactive = Colors.grey;
  static const Color divider = Color(0x1AFFFFFF);
  
  // Gradient Colors
  static const List<Color> primaryGradient = [
    Color(0xFF6C63FF),
    Color(0xFFD77EFF),
    Color(0xFFFF4D94),
  ];
  
  // Extended gradient (if you need the primary color repeated) this is actually for button 
  static const List<Color> extendedGradient = [
    Color(0xFF6C63FF),
    Color(0xFFD77EFF),
    Color(0xFFFF4D94),
    Color(0xFF6C63FF),
  ];
}