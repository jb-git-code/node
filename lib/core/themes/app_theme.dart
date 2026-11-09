import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Core Brand Colors
  static const Color _primaryGreen = Color(0xFF4CAF50);
  static const Color _lightGreenAccent = Color(0xFF69F0AE);

  // Brighter for dark mode visibility

  // ☀️ LIGHT MODE
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(
        0xFFF9F9F9,
      ), // Soft off-white to reduce glare
      colorScheme: const ColorScheme.light(
        primary: _primaryGreen,
        onPrimary: Colors.white, // Text/icons sitting on top of green buttons
        surface: Colors.white, // Background for Cards, Dialogs, BottomSheets
        onSurface: Colors.black, // Main text color
        secondary: Colors.black, // Used for secondary buttons or active toggles
        onSecondary: Colors.white,
        error: Color(0xFFB00020),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFF9F9F9),
        foregroundColor: Colors.black, // Title and icon color
        elevation: 0,
      ),
      // Global TextField styling so you don't have to style each one manually
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        hintStyle: const TextStyle(color: Colors.black54),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.black12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.black12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: _primaryGreen, width: 2),
        ),
      ),
    );
  }

  // 🌙 DARK MODE
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.black, // Pure black background
      colorScheme: const ColorScheme.dark(
        primary: _lightGreenAccent,
        onPrimary:
            Colors.black, // Black text on green buttons for sharp contrast
        surface: Color(
          0xFF1A1A1A,
        ), // Very dark gray for cards so they don't blend into the black background
        onSurface: Colors.white, // Main text color
        secondary: Colors.white,
        onSecondary: Colors.black,
        error: Color(0xFFCF6679),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF1A1A1A),
        hintStyle: const TextStyle(color: Colors.white54),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.white24),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.white24),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: _lightGreenAccent, width: 2),
        ),
      ),
    );
  }
}
