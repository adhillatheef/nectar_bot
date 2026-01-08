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
          Opacity(
            opacity: 0.8,
            // Ensure this asset exists in your pubspec.yaml
            child: Image.asset(
              'assets/images/empty_state.png',
              height: 200,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "No tickets yet",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Ask Nectar AI to create your first ticket.",
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}