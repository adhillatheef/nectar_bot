import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Needed for SystemUiOverlayStyle
import 'app_colors.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.nexusTeal,
      scaffoldBackgroundColor: AppColors.nexusDark,

      // --- Typography ---
      fontFamily: 'Poppins',
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, letterSpacing: 1.5),
        displayMedium: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, letterSpacing: 1.0),
        bodyLarge: TextStyle(color: AppColors.textPrimary),
        bodyMedium: TextStyle(color: AppColors.textSecondary),
        titleMedium: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
      ),

      // --- AppBar Theme ---
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.nexusDark,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
        titleTextStyle: TextStyle(
          fontFamily: 'Poppins',
          color: AppColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.0,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),

      // --- Card Theme ---
      cardTheme: CardThemeData(
        color: AppColors.nexusPanel,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.white.withOpacity(0.05)),
        ),
      ),

      // --- Input Decoration (TextFields) ---
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.nexusPanel,
        hintStyle: const TextStyle(color: AppColors.textTertiary, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.05)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.nexusTeal, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.nexusRed, width: 1.0),
        ),
      ),

      // --- Button Themes ---
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.nexusTeal,
          foregroundColor: AppColors.nexusDark,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
            fontSize: 14,
            letterSpacing: 1.0,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.nexusTeal,
          side: const BorderSide(color: AppColors.nexusTeal),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),

      // --- Icon Theme ---
      iconTheme: const IconThemeData(
        color: AppColors.textSecondary,
        size: 24,
      ),

      // --- Floating Action Button ---
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.nexusTeal,
        foregroundColor: AppColors.nexusDark,
        elevation: 10,
      ),

      // --- Color Scheme (M3 Seed) ---
      colorScheme: const ColorScheme.dark(
        primary: AppColors.nexusTeal,
        secondary: Color(0xFF00A3FF),
        surface: AppColors.nexusPanel,
        background: AppColors.nexusDark,
        error: AppColors.nexusRed,
        onPrimary: AppColors.nexusDark,
        onSurface: AppColors.textPrimary,
      ),
    );
  }
}