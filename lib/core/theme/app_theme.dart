import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const _primaryColor = Color(0xFFFF4B2B);
  static const _secondaryColor = Color(0xFFFF8008);
  static const _backgroundColor = Color(0xFF1A1A1A);
  static const _surfaceColor = Color(0xFF2D2D2D);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.dark(
        primary: _primaryColor,
        secondary: _secondaryColor,
        background: Color.fromARGB(255, 0, 0, 0),
        surface: Color.fromARGB(255, 81, 79, 79),
      ),
      textTheme: GoogleFonts.poppinsTextTheme(
        ThemeData.dark().textTheme,
      ),
      scaffoldBackgroundColor: _backgroundColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }

  // Custom glow effect for widgets
  static List<BoxShadow> get glowEffect => [
        BoxShadow(
          color: _primaryColor.withOpacity(0.3),
          blurRadius: 20,
          spreadRadius: 2,
        ),
        BoxShadow(
          color: _secondaryColor.withOpacity(0.2),
          blurRadius: 10,
          spreadRadius: 1,
        ),
      ];

  // Custom text styles
  static TextStyle get timerText => GoogleFonts.poppins(
        fontSize: 72,
        fontWeight: FontWeight.bold,
        color: _primaryColor,
        shadows: [
          Shadow(
            color: _primaryColor.withOpacity(0.5),
            blurRadius: 20,
          ),
        ],
      );

  static TextStyle get headerText => GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: _primaryColor,
      );

  static TextStyle get roundText => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Colors.white70,
      );
}
