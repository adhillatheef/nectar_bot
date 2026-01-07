import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllers/ticket_detail/ticket_detail_controller.dart';

class TicketDetailScreen extends StatelessWidget {
  final TicketDetailController controller = Get.put(TicketDetailController());

  TicketDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ticket Details"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: controller.deleteTicket,
          )
        ],
      ),
      body: Obx(() {
        final t = controller.ticket.value;

        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // 1. Header Section (Title & Status)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    t.title,
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 24),
                  ),
                ),
                _buildStatusBadge(t.status),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              "Reported on ${DateFormat('MMM dd, yyyy • hh:mm a').format(t.createdAt)}",
              style: TextStyle(color: Colors.grey[600]),
            ),

            const Divider(height: 32),

            // 2. Details Grid
            _buildDetailItem("Description", t.description),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildDetailItem("Category", t.category)),
                Expanded(child: _buildDetailItem("Priority", t.priority)),
              ],
            ),
            const SizedBox(height: 16),
            _buildDetailItem("Location", t.location),

            const Divider(height: 40),

            // 3. Actions Section
            const Text("Update Status", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildStatusButton("Open", t.status == "Open", Colors.blue),
                const SizedBox(width: 10),
                _buildStatusButton("In Progress", t.status == "In Progress", Colors.orange),
                const SizedBox(width: 10),
                _buildStatusButton("Closed", t.status == "Closed", Colors.grey),
              ],
            ),
          ],
        );
      }),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(),
            style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color = Colors.green;
    if (status == 'Open') color = Colors.blue;
    if (status == 'Closed') color = Colors.grey;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(status, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildStatusButton(String status, bool isActive, Color color) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () => controller.updateStatus(status),
        style: ElevatedButton.styleFrom(
          backgroundColor: isActive ? color : Colors.grey[100],
          foregroundColor: isActive ? Colors.white : Colors.black87,
          elevation: isActive ? 2 : 0,
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child: Text(status, style: const TextStyle(fontSize: 12)),
      ),
    );
  }
}