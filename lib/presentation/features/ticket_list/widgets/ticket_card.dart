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
    // Staggered Animation Logic
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 400 + (index * 100)),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - value)), // Slide up effect
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ID and Status Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "#${ticket.id.substring(0, 8).toUpperCase()}",
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      _buildStatusPill(ticket.status),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Title
                  Text(
                    ticket.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 1, color: AppColors.background),
                  const SizedBox(height: 12),
                  // Footer Info
                  Row(
                    children: [
                      _buildInfoIcon(Icons.category_outlined, ticket.category),
                      const SizedBox(width: 16),
                      _buildInfoIcon(
                          Icons.flag_outlined,
                          ticket.priority,
                          color: ticket.priority == 'High' ? AppColors.nectarRed : AppColors.nectarOrange
                      ),
                      const Spacer(),
                      Text(
                        DateFormat('MMM dd').format(ticket.createdAt),
                        style: TextStyle(color: Colors.grey[400], fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusPill(String status) {
    Color color = AppColors.success;
    Color bg = AppColors.success.withOpacity(0.1);

    if (status == 'Open') {
      color = AppColors.nectarBlue;
      bg = AppColors.nectarBlue.withOpacity(0.1);
    } else if (status == 'Closed') {
      color = AppColors.textSecondary;
      bg = Colors.grey[200]!;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildInfoIcon(IconData icon, String text, {Color? color}) {
    return Row(
      children: [
        Icon(icon, size: 14, color: color ?? Colors.grey[500]),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
              color: color ?? Colors.grey[600],
              fontSize: 12,
              fontWeight: FontWeight.w500
          ),
        ),
      ],
    );
  }
}