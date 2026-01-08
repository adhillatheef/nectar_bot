import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../controller/splash_controller.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SplashController());
    return Scaffold(
      backgroundColor: AppColors.nexusDark,
      body: Stack(
        children: [
          // 1. Ambient Background Glow (Top Left)
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.nexusTeal.withOpacity(0.05),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.nexusTeal.withOpacity(0.1),
                    blurRadius: 100,
                    spreadRadius: 50,
                  ),
                ],
              ),
            ),
          ),

          // 2. Ambient Background Glow (Bottom Right)
          Positioned(
            bottom: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF00A3FF).withOpacity(0.05),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00A3FF).withOpacity(0.1),
                    blurRadius: 100,
                    spreadRadius: 50,
                  ),
                ],
              ),
            ),
          ),

          // 3. Main Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated Logo Container
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 1000),
                  curve: Curves.easeOutExpo,
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Opacity(opacity: value, child: child),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.nexusPanel,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.nexusTeal.withOpacity(0.2),
                          blurRadius: 40,
                          spreadRadius: 5,
                        ),
                        BoxShadow(
                          color: AppColors.nexusTeal.withOpacity(0.1),
                          blurRadius: 20,
                        ),
                      ],
                      border: Border.all(color: AppColors.nexusTeal.withOpacity(0.3), width: 1),
                    ),
                    child: const Icon(Icons.view_in_ar, size: 64, color: AppColors.nexusTeal),
                  ),
                ),

                const SizedBox(height: 40),

                // Brand Name (Nexus)
                const FadeTransition(
                  opacity: AlwaysStoppedAnimation(1.0),
                  child: Text(
                    "NEXUS",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 8.0,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Subtitle
                const Text(
                  "ENTERPRISE TICKETING",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                    letterSpacing: 4.0,
                  ),
                ),
              ],
            ),
          ),

          // 4. Footer & Loader
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Column(
              children: [
                // Thin Tech Loader
                const SizedBox(
                  width: 120,
                  height: 2,
                  child: LinearProgressIndicator(
                    backgroundColor: AppColors.nexusPanel,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.nexusTeal),
                  ),
                ),
                const SizedBox(height: 24),

                // AI Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.nexusTeal.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.nexusTeal.withOpacity(0.2)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.auto_awesome, size: 12, color: AppColors.nexusTeal),
                      const SizedBox(width: 8),
                      Text(
                        "POWERED BY AI",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: AppColors.nexusTeal.withOpacity(0.9),
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
