import 'package:flutter/material.dart';

class AppColors {
  // --- Brand Colors (Extracted from Nectar Logo) ---
  static const Color nectarPurple = Color(0xFF6C3FA8); // Deep Purple
  static const Color nectarBlue = Color(0xFF4A90E2);   // Bright Blue
  static const Color nectarOrange = Color(0xFFFF8A65); // Soft Orange
  static const Color nectarRed = Color(0xFFFF5252);    // Accent Red

  // --- Gradients ---
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [nectarBlue, nectarPurple],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [nectarOrange, nectarRed],
  );

  // --- Neutrals ---
  static const Color background = Color(0xFFF5F7FA); // Light Grey-Blue (Modern Background)
  static const Color surface = Colors.white;
  static const Color textPrimary = Color(0xFF2D3436);
  static const Color textSecondary = Color(0xFF636E72);
  static const Color divider = Color(0xFFDFE6E9);

  // --- Status Colors ---
  static const Color success = Color(0xFF00B894);
  static const Color warning = Color(0xFFFDCB6E);
  static const Color error = Color(0xFFFF7675);
}