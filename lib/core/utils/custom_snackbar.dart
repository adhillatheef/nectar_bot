import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/app_colors.dart';

class CustomSnackbar {
  static void show({
    required String title,
    required String message,
    bool isError = false,
  }) {
    final Color accentColor = isError ? AppColors.nexusRed : AppColors.nexusTeal;

    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      borderRadius: 12,
      padding: const EdgeInsets.all(16),
      backgroundColor: AppColors.nexusPanel,
      colorText: AppColors.textPrimary,
      titleText: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.bold,
          fontSize: 12,
          color: accentColor,
          letterSpacing: 1.0,
        ),
      ),
      messageText: Text(
        message,
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 13,
          color: AppColors.textSecondary,
        ),
      ),
      borderWidth: 1,
      borderColor: accentColor.withOpacity(0.5),
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.4),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
        BoxShadow(
          color: accentColor.withOpacity(0.1),
          blurRadius: 20,
          spreadRadius: -5,
        ),
      ],
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: accentColor.withOpacity(0.1),
        ),
        child: Icon(
          isError ? Icons.warning_amber_rounded : Icons.check_circle_outline,
          color: accentColor,
          size: 20,
        ),
      ),
      duration: const Duration(seconds: 3),
      animationDuration: const Duration(milliseconds: 400),
      isDismissible: true,
      shouldIconPulse: true,
    );
  }
}
