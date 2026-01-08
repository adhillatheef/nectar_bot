import 'package:flutter/material.dart';

class AppColors {
  static const Color nexusDark = Color(0xFF101214);
  static const Color nexusPanel = Color(0xFF1E2224);
  static const Color nexusTeal = Color(0xFF00F0FF);
  static const Color nexusGreen = Color(0xFF00FF94);
  static const Color nexusRed = Color(0xFFFF4C4C);

  // --- Text Colors ---
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF8A9499);
  static const Color textTertiary = Color(0xFF4B5559);

  // --- Gradients ---
  static const LinearGradient nexusGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [nexusTeal, Color(0xFF00A3FF)],
  );

  static const Color primaryPurple = nexusTeal;
  static const Color background = nexusDark;
}
