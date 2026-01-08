import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../domain/entities/ticket.dart';

class TicketInfoGrid extends StatelessWidget {
  final Ticket ticket;

  const TicketInfoGrid({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 2.2, // Rectangular modules
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: [
        _buildModule(Icons.category_outlined, "SYSTEM CATEGORY", ticket.category),
        _buildModule(
            Icons.flag_outlined,
            "PRIORITY LEVEL",
            ticket.priority,
            accentColor: ticket.priority == 'High' ? AppColors.nexusRed : null
        ),
        _buildModule(Icons.location_on_outlined, "LOCATION NODE", ticket.location),
        _buildModule(Icons.person_outline, "REPORTED BY", ticket.reportedBy),
        _buildModule(Icons.phone_outlined, "CONTACT LINK", ticket.contactNumber ?? "--"),
        _buildModule(Icons.timer_outlined, "SLA PROTOCOL", ticket.sla ?? "Standard"),
      ],
    );
  }

  Widget _buildModule(IconData icon, String label, String value, {Color? accentColor}) {
    final color = accentColor ?? AppColors.nexusTeal;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.nexusPanel.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: accentColor ?? Colors.white
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}