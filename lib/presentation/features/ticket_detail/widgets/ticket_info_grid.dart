import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../domain/entities/ticket.dart';

class TicketInfoGrid extends StatelessWidget {
  final Ticket ticket;

  const TicketInfoGrid({Key? key, required this.ticket}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 2.8,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: [
        _buildDetailTile(Icons.category_outlined, "Category", ticket.category),
        _buildDetailTile(
            Icons.flag_outlined,
            "Priority",
            ticket.priority,
            isHigh: ticket.priority == 'High'
        ),
        _buildDetailTile(Icons.location_on_outlined, "Location", ticket.location),
        _buildDetailTile(Icons.person_outline, "Reported By", ticket.reportedBy),
        _buildDetailTile(Icons.phone_outlined, "Contact", ticket.contactNumber ?? "--"),
        _buildDetailTile(Icons.timer_outlined, "SLA", ticket.sla ?? "Standard"),
      ],
    );
  }

  Widget _buildDetailTile(IconData icon, String label, String value, {bool isHigh = false}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 5,
              offset: const Offset(0, 2)
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
              icon,
              size: 20,
              color: isHigh ? AppColors.nectarRed : AppColors.nectarPurple.withOpacity(0.7)
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(label, style: TextStyle(fontSize: 10, color: Colors.grey[500])),
                Text(
                    value,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}