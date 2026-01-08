import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../controller/ticket_detail_controller.dart';
import '../widgets/ticket_detail_header.dart';
import '../widgets/ticket_info_grid.dart';
import '../widgets/ticket_attachment_gallery.dart';
import '../widgets/ticket_action_buttons.dart';

class TicketDetailScreen extends GetView<TicketDetailController> {
  const TicketDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.nexusDark,
      appBar: AppBar(
        title: const Text("OPERATIONAL DOSSIER", style: TextStyle(fontSize: 14, letterSpacing: 2.0)),
        centerTitle: true,
        backgroundColor: AppColors.nexusPanel,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        final t = controller.ticket.value;

        if (t == null) {
          return const Center(child: CircularProgressIndicator(color: AppColors.nexusTeal));
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header Module
              TicketDetailHeader(
                ticket: t,
                onEdit: controller.navigateToEdit,
                onDelete: controller.deleteTicket,
              ),

              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 2. Incident Log (Description)
                    _buildSectionLabel("INCIDENT LOG"),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.nexusPanel.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white.withOpacity(0.05)),
                      ),
                      child: Text(
                        t.description,
                        style: const TextStyle(fontSize: 14, height: 1.6, color: Colors.white70, fontFamily: 'Poppins'),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // 3. Grid Details
                    _buildSectionLabel("SYSTEM METRICS"),
                    TicketInfoGrid(ticket: t),

                    const SizedBox(height: 32),

                    // 4. Evidence Files
                    _buildSectionLabel("EVIDENCE FILES (${t.attachments.length})"),
                    TicketAttachmentGallery(attachments: t.attachments),

                    const SizedBox(height: 40),

                    // 5. Status Actions
                    _buildSectionLabel("UPDATE PROTOCOL"),
                    TicketActionButtons(
                      currentStatus: t.status,
                      onStatusUpdate: controller.updateStatus,
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSectionLabel(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, left: 4),
      child: Row(
        children: [
          Container(width: 4, height: 14, color: AppColors.nexusTeal),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
