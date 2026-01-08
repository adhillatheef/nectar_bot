import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class EmptyTicketState extends StatelessWidget {
  const EmptyTicketState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Holographic Placeholder
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                        colors: [
                          AppColors.nexusTeal.withOpacity(0.2),
                          Colors.transparent
                        ]
                    )
                ),
              ),
              Icon(
                  Icons.check_circle_outline,
                  size: 64,
                  color: AppColors.nexusTeal.withOpacity(0.8)
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            "SYSTEM ALL CLEAR",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              letterSpacing: 2.0,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "No active tickets in this category.\nSwitch tabs to check other queues.",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: 'Poppins',
                color: AppColors.textSecondary,
                height: 1.5
            ),
          ),
        ],
      ),
    );
  }
}