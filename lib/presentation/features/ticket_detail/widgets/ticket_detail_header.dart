import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../domain/entities/ticket.dart';

class TicketDetailHeader extends StatelessWidget {
  final Ticket ticket;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TicketDetailHeader({
    Key? key,
    required this.ticket,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 180.0,
      floating: false,
      pinned: true,
      backgroundColor: AppColors.nectarPurple,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.primaryGradient,
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatusPill(ticket.status),
                const SizedBox(height: 12),
                Text(
                  "Ticket #${ticket.id.substring(0, 8).toUpperCase()}",
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 30), // Space for the overlap effect
              ],
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.edit, color: Colors.white),
          tooltip: "Edit Ticket",
          onPressed: onEdit,
        ),
        IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.white),
          tooltip: "Delete Ticket",
          onPressed: onDelete,
        )
      ],
    );
  }

  Widget _buildStatusPill(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white30),
      ),
      child: Text(
        status.toUpperCase(),
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }
}