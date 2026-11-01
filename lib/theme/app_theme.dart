import 'package:flutter/material.dart';

class AppTheme {
  // Warna utama GYMPLANNER
  static const Color primaryColor = Color(0xFF2563EB);
  static const Color backgroundColor = Color(0xFF111827);
  static const Color surfaceColor = Color(0xFF1F2937);
  static const Color secondaryColor = Color(0xFF374151);
  static const Color textColor = Color(0xFFFFFFFF);
  static const Color secondaryTextColor = Color(0xFF9CA3AF);

  // Tema utama aplikasi
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      scaffoldBackgroundColor: backgroundColor,

      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: primaryColor,
        surface: surfaceColor,
        onPrimary: textColor,
        onSurface: textColor,
      ),

      // Tema AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        elevation: 0,
        centerTitle: false,
      ),

      // Tema Card
      cardTheme: CardThemeData(
        color: surfaceColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      // Tema tombol
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: textColor,
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      // Tema teks
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
        bodyMedium: TextStyle(
          color: secondaryTextColor,
        ),
      ),
    );
  }
}