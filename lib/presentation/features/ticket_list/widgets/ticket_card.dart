import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../domain/entities/ticket.dart';

class TicketCard extends StatelessWidget {
  final Ticket ticket;
  final int index;
  final VoidCallback onTap;

  const TicketCard({
    super.key,
    required this.ticket,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.nexusPanel,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: IntrinsicHeight(
            child: Row(
              children: [
                // 1. Neon Status Strip (Left Border)
                Container(
                  width: 4,
                  decoration: BoxDecoration(
                    color: _getStatusColor(ticket.status),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: _getStatusColor(ticket.status).withOpacity(0.6),
                        blurRadius: 8,
                        spreadRadius: 1,
                      )
                    ],
                  ),
                ),

                // 2. Content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header: ID + Date
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "#${ticket.id.substring(0, 6).toUpperCase()}",
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                color: AppColors.textSecondary,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.0,
                              ),
                            ),
                            Text(
                              DateFormat('MMM dd • HH:mm').format(ticket.createdAt),
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: AppColors.textSecondary.withOpacity(0.5),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Title
                        Text(
                          ticket.title,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            color: AppColors.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),

                        const SizedBox(height: 12),

                        // Footer Badges
                        Row(
                          children: [
                            _buildTechBadge(ticket.category, Colors.blueGrey),
                            const SizedBox(width: 8),
                            _buildTechBadge(
                                ticket.priority,
                                ticket.priority == 'High' ? AppColors.nexusRed : AppColors.textSecondary,
                                isOutline: true
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTechBadge(String text, Color color, {bool isOutline = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isOutline ? Colors.transparent : color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
            color: isOutline ? color.withOpacity(0.5) : Colors.transparent,
            width: 1
        ),
      ),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          color: isOutline ? color : Colors.white.withOpacity(0.9),
          fontSize: 10,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Open': return AppColors.nexusTeal;
      case 'In Progress': return Colors.amber;
      case 'Closed': return AppColors.textSecondary;
      default: return AppColors.nexusTeal;
    }
  }
}