import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../domain/entities/ticket.dart';
import '../../../core/theme/app_colors.dart';
import '../../controllers/ticket_list/ticket_list_controller.dart';
import '../../routes/app_routes.dart';

class TicketListScreen extends StatelessWidget {
  final TicketListController controller = Get.put(TicketListController());

  TicketListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Tickets"), automaticallyImplyLeading: false),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: controller.createNewTicket,
        label: const Text("New Ticket"),
        icon: const Icon(Icons.add),
        backgroundColor: AppColors.primaryPurple,
      ),
      body: Obx(() {
        if (controller.isLoading.value) return const Center(child: CircularProgressIndicator());
        if (controller.tickets.isEmpty) return const Center(child: Text("No tickets found"));

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.tickets.length,
          itemBuilder: (context, index) {
            final ticket = controller.tickets[index];
            return _buildTicketCard(context, ticket);
          },
        );
      }),
    );
  }

  Widget _buildTicketCard(BuildContext context, Ticket ticket) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () async {
          // Navigate to detail
          await Get.toNamed(Routes.TICKET_DETAIL, arguments: ticket);
          // Always reload to reflect status changes or deletions
          controller.loadTickets();
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text(ticket.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                  _buildStatusChip(ticket.status),
                ],
              ),
              const SizedBox(height: 8),
              Row(children: [
                _buildInfoChip(Icons.category, ticket.category),
                const SizedBox(width: 12),
                _buildInfoChip(Icons.priority_high, ticket.priority, color: ticket.priority == 'High' ? Colors.red : Colors.orange),
              ]),
              const SizedBox(height: 12),
              Text("Created: ${DateFormat('MMM dd, yyyy').format(ticket.createdAt)}", style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color = Colors.green;
    if (status == 'Open') color = Colors.blue;
    if (status == 'Closed') color = Colors.grey;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
      child: Text(status, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, {Color? color}) {
    return Row(children: [
      Icon(icon, size: 16, color: color ?? Colors.grey),
      const SizedBox(width: 4),
      Text(label, style: TextStyle(color: color ?? Colors.grey[700], fontSize: 13)),
    ]);
  }
}