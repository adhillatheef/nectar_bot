import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../controller/edit_ticket_controller.dart';

class AttachmentEditorGrid extends StatelessWidget {
  final EditTicketController controller = Get.find();

  AttachmentEditorGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 4),
              child: Text(
                "ATTACHMENTS",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  letterSpacing: 1.0,
                ),
              ),
            ),
            TextButton.icon(
              onPressed: controller.pickAttachment,
              icon: const Icon(Icons.add_a_photo, size: 16, color: AppColors.nectarPurple),
              label: const Text(
                "Add New",
                style: TextStyle(color: AppColors.nectarPurple, fontWeight: FontWeight.bold),
              ),
              style: TextButton.styleFrom(
                backgroundColor: AppColors.nectarPurple.withOpacity(0.1),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Obx(() {
          if (controller.attachments.isEmpty) {
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 30),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!, style: BorderStyle.solid),
              ),
              child: Column(
                children: [
                  Icon(Icons.attachment, size: 32, color: Colors.grey[400]),
                  const SizedBox(height: 8),
                  Text("No attachments", style: TextStyle(color: Colors.grey[500])),
                ],
              ),
            );
          }

          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.attachments.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.0,
            ),
            itemBuilder: (context, index) {
              return _buildAttachmentTile(controller.attachments[index], index);
            },
          );
        }),
      ],
    );
  }

  Widget _buildAttachmentTile(String path, int index) {
    return Stack(
      children: [
        // Image / Thumbnail
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[200],
                image: DecorationImage(
                  image: FileImage(File(path)),
                  fit: BoxFit.cover,
                  onError: (_, __) => const AssetImage('assets/images/placeholder.png'), // Fallback
                ),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))
                ]
            ),
            child: path.endsWith('.mp4') || path.endsWith('.mov') || path.endsWith('.m4a')
                ? Center(
                child: Icon(
                    path.endsWith('.m4a') ? Icons.mic : Icons.play_circle,
                    color: Colors.white, size: 32
                )
            )
                : null,
          ),
        ),
        // Delete Button
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () => controller.removeAttachment(index),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
              ),
              child: const Icon(Icons.close, size: 14, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}