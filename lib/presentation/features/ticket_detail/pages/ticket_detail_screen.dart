import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../controller/ticket_detail_controller.dart';
import '../widgets/ticket_action_buttons.dart';
import '../widgets/ticket_attachment_gallery.dart';
import '../widgets/ticket_detail_header.dart';
import '../widgets/ticket_info_grid.dart';

class TicketDetailScreen extends GetView<TicketDetailController> {
  const TicketDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
        final t = controller.ticket.value;

        if (t == null) {
          return const Center(child: CircularProgressIndicator(color: AppColors.nectarPurple));
        }

        return CustomScrollView(
          slivers: [
            // 1. Header
            TicketDetailHeader(
              ticket: t,
              onEdit: controller.navigateToEdit,
              onDelete: controller.deleteTicket,
            ),

            // 2. Content Body
            SliverToBoxAdapter(
              child: Transform.translate(
                offset: const Offset(0, -20), // Slight overlap with header
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title & Meta
                        Text(
                          t.title,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                            const SizedBox(width: 6),
                            Text(
                              DateFormat('MMMM dd, yyyy • hh:mm a').format(t.createdAt),
                              style: const TextStyle(color: Colors.grey, fontSize: 13),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Description Section
                        _buildSectionLabel("Description"),
                        Text(
                          t.description,
                          style: const TextStyle(fontSize: 15, height: 1.6, color: AppColors.textSecondary),
                        ),

                        const SizedBox(height: 24),

                        // Info Grid
                        _buildSectionLabel("Details"),
                        TicketInfoGrid(ticket: t),

                        const SizedBox(height: 24),

                        // Attachments
                        _buildSectionLabel("Attachments"),
                        TicketAttachmentGallery(attachments: t.attachments),

                        const SizedBox(height: 40),

                        // Action Buttons
                        const Text("Update Status", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                        const SizedBox(height: 12),
                        TicketActionButtons(
                          currentStatus: t.status,
                          onStatusUpdate: controller.updateStatus,
                        ),

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildSectionLabel(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
