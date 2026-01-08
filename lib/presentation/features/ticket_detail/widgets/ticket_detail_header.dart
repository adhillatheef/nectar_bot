import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../domain/entities/ticket.dart';

class TicketDetailHeader extends StatelessWidget {
  final Ticket ticket;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TicketDetailHeader({
    super.key,
    required this.ticket,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.nexusPanel,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
        border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.05))),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Status Badge & Date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNeonBadge(ticket.status),
              Text(
                "REPORTED: ${DateFormat('HH:mm • MMM dd').format(ticket.createdAt).toUpperCase()}",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 10,
                  color: AppColors.textSecondary.withOpacity(0.7),
                  letterSpacing: 1.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Ticket Title
          Text(
            ticket.title,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),

          // Ticket ID (Monospace style)
          Row(
            children: [
              Icon(Icons.tag, size: 14, color: AppColors.nexusTeal.withOpacity(0.7)),
              const SizedBox(width: 4),
              Text(
                ticket.id.toUpperCase(),
                style: TextStyle(
                  fontFamily: 'Courier', // Monospace for ID
                  fontSize: 12,
                  color: AppColors.nexusTeal.withOpacity(0.7),
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Action Icons Row (Edit/Delete)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildActionIcon(Icons.edit_outlined, "EDIT", onEdit),
              const SizedBox(width: 16),
              _buildActionIcon(Icons.delete_outline, "DELETE", onDelete, isDestructive: true),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildNeonBadge(String status) {
    Color color = AppColors.nexusTeal;
    if (status == 'In Progress') color = Colors.amber;
    if (status == 'Closed') color = AppColors.textSecondary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 8,
            spreadRadius: -2,
          )
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(
            status.toUpperCase(),
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionIcon(IconData icon, String label, VoidCallback onTap, {bool isDestructive = false}) {
    final color = isDestructive ? AppColors.nexusRed : Colors.white;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color, letterSpacing: 1.0),
            ),
          ],
        ),
      ),
    );
  }
}
