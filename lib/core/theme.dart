import 'package:flutter/material.dart';

class AppTheme {
  static const _primaryColor = Colors.deepPurple;

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _primaryColor,
        primary: _primaryColor,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: _primaryColor.shade50,
        elevation: 0,
        titleTextStyle: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: _primaryColor.shade900,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      dataTableTheme: DataTableThemeData(
        headingRowColor: WidgetStatePropertyAll(_primaryColor.shade50),
        headingTextStyle: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  static const Color primaryColor = _primaryColor;
  static const Color accentGreen = Colors.green;
  static const Color accentOrange = Colors.orange;
  static const Color accentRed = Colors.red;
}