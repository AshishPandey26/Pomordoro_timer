import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum AppThemeType {
  fiery,
  cyberpunk,
  zenForest,
}

class AppTheme {
  static ThemeData getTheme(AppThemeType type) {
    switch (type) {
      case AppThemeType.fiery:
        return ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFFF4B2B),
            brightness: Brightness.dark,
          ),
          textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
          scaffoldBackgroundColor: const Color(0xFF1A1A1A),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF1A1A1A),
            elevation: 0,
          ),
          cardTheme: CardTheme(
            color: const Color(0xFF2D2D2D),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF4B2B),
              foregroundColor: Colors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          popupMenuTheme: PopupMenuThemeData(
            color: const Color(0xFF2D2D2D),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      case AppThemeType.cyberpunk:
        return ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF00FF9F),
            brightness: Brightness.dark,
          ),
          textTheme: GoogleFonts.orbitronTextTheme(ThemeData.dark().textTheme),
          scaffoldBackgroundColor: const Color(0xFF0A0A0A),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF0A0A0A),
            elevation: 0,
          ),
          cardTheme: CardTheme(
            color: const Color(0xFF1A1A1A),
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00FF9F),
              foregroundColor: Colors.black,
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          popupMenuTheme: PopupMenuThemeData(
            color: const Color(0xFF1A1A1A),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      case AppThemeType.zenForest:
        return ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.light(
            primary: const Color(0xFF228B22), // Forest Green
            secondary: const Color(0xFFD9CAB3), // Bamboo Tan
            background: const Color(0xFFF5F5F5), // Misty White
            surface: Colors.white,
            onBackground: const Color(0xFF2E2E2E), // Deep Bark
            onSurface: const Color(0xFF2E2E2E), // Deep Bark
            onPrimary: Colors.white,
            onSecondary: const Color(0xFF2E2E2E), // Deep Bark
          ),
          textTheme: GoogleFonts.notoSansTextTheme(ThemeData.light().textTheme),
          scaffoldBackgroundColor: const Color(0xFFF5F5F5), // Misty White
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFFF5F5F5), // Misty White
            elevation: 0,
            foregroundColor: Color(0xFF2E2E2E), // Deep Bark
          ),
          cardTheme: CardTheme(
            color: Colors.white,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF228B22), // Forest Green
              foregroundColor: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          popupMenuTheme: PopupMenuThemeData(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
          ),
        );
    }
  }

  // Custom glow effect for widgets
  static List<BoxShadow> getGlowEffect(AppThemeType type) {
    switch (type) {
      case AppThemeType.fiery:
        return [
          BoxShadow(
            color: const Color(0xFFFF4B2B).withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: const Color(0xFFFF8008).withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ];
      case AppThemeType.cyberpunk:
        return [
          BoxShadow(
            color: const Color(0xFF00FF9F).withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: const Color(0xFFFF00FF).withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ];
      case AppThemeType.zenForest:
        return [
          BoxShadow(
            color: const Color(0xFF228B22).withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: const Color(0xFFD9CAB3).withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ];
    }
  }

  // Custom text styles
  static TextStyle getTimerText(AppThemeType type) {
    switch (type) {
      case AppThemeType.fiery:
        return GoogleFonts.poppins(
          fontSize: 48,
          fontWeight: FontWeight.bold,
          color: const Color(0xFFFF4B2B),
          shadows: [
            Shadow(
              color: const Color(0xFFFF4B2B).withOpacity(0.5),
              blurRadius: 15,
            ),
          ],
        );
      case AppThemeType.cyberpunk:
        return GoogleFonts.orbitron(
          fontSize: 48,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF00FF9F),
          shadows: [
            Shadow(
              color: const Color(0xFF00FF9F).withOpacity(0.5),
              blurRadius: 15,
            ),
          ],
        );
      case AppThemeType.zenForest:
        return GoogleFonts.notoSans(
          fontSize: 48,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF228B22), // Forest Green
          shadows: [
            Shadow(
              color: const Color(0xFF228B22).withOpacity(0.3),
              blurRadius: 15,
            ),
          ],
        );
    }
  }

  static TextStyle getHeaderText(AppThemeType type) {
    switch (type) {
      case AppThemeType.fiery:
        return GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: const Color(0xFFFF4B2B),
        );
      case AppThemeType.cyberpunk:
        return GoogleFonts.orbitron(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF00FF9F),
        );
      case AppThemeType.zenForest:
        return GoogleFonts.notoSans(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF228B22), // Forest Green
        );
    }
  }

  static TextStyle getRoundText(AppThemeType type) {
    switch (type) {
      case AppThemeType.fiery:
        return GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.white70,
        );
      case AppThemeType.cyberpunk:
        return GoogleFonts.orbitron(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.white70,
        );
      case AppThemeType.zenForest:
        return GoogleFonts.notoSans(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF2E2E2E), // Deep Bark
        );
    }
  }
}
