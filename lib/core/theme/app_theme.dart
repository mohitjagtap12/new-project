import 'package:flutter/material.dart';

class AgroColors {
  // Primary AgroWorld Greens
  static const Color primary = Color(0xFF2E7D32); // Deep Forest Green
  static const Color primaryLight = Color(0xFF4CAF50); // Vibrant Leaf Green
  static const Color primaryDark = Color(0xFF1B5E20);
  static const Color primaryContainer = Color(0xFFE8F5E9); // Light Mint background

  // Secondary Accents
  static const Color secondary = Color(0xFFF57F17); // Harvest Gold / Amber
  static const Color secondaryLight = Color(0xFFFFF9C4);
  static const Color tertiary = Color(0xFF00796B); // Deep Teal

  // Neutral Colors (optimized for readability & farmers)
  static const Color background = Color(0xFFF9FBF8); // Clean soft natural tint
  static const Color surface = Colors.white;
  static const Color surfaceVariant = Color(0xFFF1F4EE);
  static const Color textDark = Color(0xFF1C2819);
  static const Color textMuted = Color(0xFF556052);
  static const Color textLight = Color(0xFF889385);
  static const Color border = Color(0xFFDCE3D9);

  // Semantic Status Colors
  static const Color statusGrowing = Color(0xFF2E7D32);
  static const Color statusHarvested = Color(0xFFE65100);
  static const Color statusAvailable = Color(0xFF1565C0);
  static const Color statusAccepted = Color(0xFF2E7D32);
  static const Color statusPending = Color(0xFFF57F17);
  static const Color statusCancelled = Color(0xFFC62828);
}

class AgroTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AgroColors.primary,
        primary: AgroColors.primary,
        onPrimary: Colors.white,
        primaryContainer: AgroColors.primaryContainer,
        onPrimaryContainer: AgroColors.primaryDark,
        secondary: AgroColors.secondary,
        surface: AgroColors.surface,
        onSurface: AgroColors.textDark,
      ),
      scaffoldBackgroundColor: AgroColors.background,
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(
        backgroundColor: AgroColors.surface,
        foregroundColor: AgroColors.textDark,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AgroColors.textDark,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AgroColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 52),
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AgroColors.primary,
          side: const BorderSide(color: AgroColors.primary, width: 1.5),
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: AgroColors.surface,
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.06),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: AgroColors.border, width: 1),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AgroColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AgroColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AgroColors.primary, width: 2),
        ),
        labelStyle: const TextStyle(color: AgroColors.textMuted, fontSize: 15),
        hintStyle: const TextStyle(color: AgroColors.textLight, fontSize: 14),
      ),
    );
  }
}
