import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/splash_controller.dart';
import '../../../../core/theme/app_colors.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 1.0, end: 30.0),
          duration: const Duration(milliseconds: 1500),
          curve: Curves.easeInOutExpo,
          onEnd: controller.onAnimationComplete,
          builder: (context, scale, child) {
            return Transform.scale(
              scale: scale,
              child: Opacity(
                opacity: scale > 20 ? (30 - scale) / 10 : 1.0,
                child: child,
              ),
            );
          },
          child: SizedBox(
            width: 100,
            height: 100,
            child: Image.asset('assets/images/nectar_logo.png'),
          ),
        ),
      ),
    );
  }
}