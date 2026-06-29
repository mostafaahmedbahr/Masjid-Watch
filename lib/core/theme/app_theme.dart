import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF0D5E2E);
  static const Color primaryDark = Color(0xFF083D1E);
  static const Color primaryLight = Color(0xFF1B8B4A);
  static const Color accentColor = Color(0xFFC8E6C9);
  static const Color goldColor = Color(0xFFD4AF37);
  static const Color goldLight = Color(0xFFFFD700);
  static const Color darkBackground = Color(0xFF0A1A0E);
  static const Color darkCard = Color(0xFF112A17);
  static const Color darkCardBorder = Color(0xFF1E4D2B);
  static const Color lightBackground = Color(0xFFF5F0E8);
  static const Color lightCard = Color(0xFFFFFDF5);
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color nextPrayerHighlight = Color(0xFF4CAF50);
  static const Color greenGlow = Color(0x332BD17E);
  static const Color goldGlow = Color(0x33D4AF37);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: darkBackground,
      cardColor: darkCard,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor, secondary: goldColor, surface: darkCard,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryDark, foregroundColor: goldColor, elevation: 0,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 72, fontWeight: FontWeight.w200, color: Colors.white, letterSpacing: 4),
        displayMedium: TextStyle(fontSize: 48, fontWeight: FontWeight.w200, color: Colors.white, letterSpacing: 3),
        headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
        headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        bodyLarge: TextStyle(fontSize: 18, color: Colors.white70),
        bodyMedium: TextStyle(fontSize: 14, color: Colors.white60),
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: lightBackground,
      cardColor: lightCard,
      colorScheme: const ColorScheme.light(
        primary: primaryColor, secondary: goldColor, surface: lightCard,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor, foregroundColor: Colors.white, elevation: 0,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 72, fontWeight: FontWeight.w200, color: textPrimary),
        displayMedium: TextStyle(fontSize: 48, fontWeight: FontWeight.w200, color: textPrimary),
        headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: textPrimary),
        headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textPrimary),
        bodyLarge: TextStyle(fontSize: 18, color: textSecondary),
        bodyMedium: TextStyle(fontSize: 14, color: textSecondary),
      ),
    );
  }

  static BoxDecoration cardDecoration({bool glowing = false}) {
    return BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.topLeft, end: Alignment.bottomRight,
        colors: [Color(0xFF112A17), Color(0xFF0A1A0E)],
      ),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: const Color(0xFF1E4D2B), width: 1),
      boxShadow: glowing
          ? [BoxShadow(color: greenGlow, blurRadius: 20, spreadRadius: 2)]
          : [BoxShadow(color: Colors.black38, blurRadius: 8, offset: const Offset(0, 2))],
    );
  }

  static BoxDecoration goldBorderDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: goldColor.withValues(alpha: 0.3), width: 1),
    );
  }

  static BoxDecoration topHeaderDecoration() {
    return BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.topCenter, end: Alignment.bottomCenter,
        colors: [Color(0xFF083D1E), Color(0xFF0D5E2E)],
      ),
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24),
      ),
      boxShadow: [BoxShadow(color: goldGlow, blurRadius: 15, spreadRadius: 1)],
    );
  }
}
