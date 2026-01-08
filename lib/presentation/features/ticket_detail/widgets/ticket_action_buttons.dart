import 'package:flutter/material.dart';

class TicketActionButtons extends StatelessWidget {
  final String currentStatus;
  final Function(String) onStatusUpdate;

  const TicketActionButtons({
    Key? key,
    required this.currentStatus,
    required this.onStatusUpdate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildButton("Open", Colors.blue, currentStatus == "Open"),
        const SizedBox(width: 12),
        _buildButton("In Progress", Colors.orange, currentStatus == "In Progress"),
        const SizedBox(width: 12),
        _buildButton("Closed", Colors.grey, currentStatus == "Closed"),
      ],
    );
  }

  Widget _buildButton(String status, Color color, bool isActive) {
    return Expanded(
      child: InkWell(
        onTap: () => onStatusUpdate(status),
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isActive ? color : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isActive ? color : Colors.grey.shade300),
            boxShadow: isActive
                ? [BoxShadow(color: color.withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 4))]
                : [],
          ),
          child: Center(
            child: Text(
              status,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.grey[700],
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ),
    );
  }
}