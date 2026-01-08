import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/app_colors.dart';

class CustomSnackbar {
  static void show({required String title, required String message, bool isError = false}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: isError ? Colors.red.shade50 : Colors.white,
      colorText: AppColors.textPrimary,
      icon: Icon(
        isError ? Icons.error_outline : Icons.check_circle_outline,
        color: isError ? Colors.red : AppColors.nectarPurple,
        size: 28,
      ),
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 10,
          offset: const Offset(0, 4),
        )
      ],
      margin: const EdgeInsets.all(16),
      borderRadius: 16,
      duration: const Duration(seconds: 3),
      shouldIconPulse: true,
      barBlur: 10,
      isDismissible: true,
      titleText: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      messageText: Text(
        message,
        style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
      ),
    );
  }
}