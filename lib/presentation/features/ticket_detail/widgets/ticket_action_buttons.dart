import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class TicketActionButtons extends StatelessWidget {
  final String currentStatus;
  final Function(String) onStatusUpdate;

  const TicketActionButtons({
    super.key,
    required this.currentStatus,
    required this.onStatusUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildProtocolButton("OPEN", AppColors.nexusTeal, currentStatus == "Open"),
        const SizedBox(width: 12),
        _buildProtocolButton("IN PROGRESS", Colors.amber, currentStatus == "In Progress"),
        const SizedBox(width: 12),
        _buildProtocolButton("CLOSED", AppColors.textSecondary, currentStatus == "Closed"),
      ],
    );
  }

  Widget _buildProtocolButton(String status, Color color, bool isActive) {
    return Expanded(
      child: InkWell(
        onTap: () => onStatusUpdate(status.split(" ").map((str) => str.capitalizeFirst).join(" ")), // Capitalize for logic match
        borderRadius: BorderRadius.circular(30),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isActive ? color.withOpacity(0.2) : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: isActive ? color : Colors.white.withOpacity(0.1), width: 1),
            boxShadow: isActive ? [BoxShadow(color: color.withOpacity(0.1), blurRadius: 10)] : [],
          ),
          child: Center(
            child: Text(
              status,
              style: TextStyle(
                color: isActive ? color : Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 10,
                letterSpacing: 1.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String get capitalizeFirst => this[0].toUpperCase() + substring(1).toLowerCase();
}
