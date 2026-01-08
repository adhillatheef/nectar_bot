import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../controller/edit_ticket_controller.dart';

class AttachmentEditorGrid extends GetView<EditTicketController> {
  const AttachmentEditorGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "// EVIDENCE FILES",
          style: TextStyle(
            fontFamily: 'Courier',
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.nexusTeal.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 12),

        Obx(() {
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.attachments.length + 1, // +1 for the "Add" button
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              // The "Add Button" is always the last item
              if (index == controller.attachments.length) {
                return _buildAddButton();
              }

              // Attachment Tiles
              return _buildAttachmentTile(controller.attachments[index], index);
            },
          );
        }),
      ],
    );
  }

  Widget _buildAddButton() {
    return GestureDetector(
      onTap: controller.pickAttachment,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.nexusPanel.withOpacity(0.3),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
              color: AppColors.nexusTeal.withOpacity(0.5),
              style: BorderStyle.solid, // Dashed is hard in standard Flutter without a package, solid thin looks techy too
              width: 1
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.add, color: AppColors.nexusTeal, size: 20),
              const SizedBox(height: 4),
              Text(
                "ADD FILE",
                style: TextStyle(
                    fontSize: 8,
                    color: AppColors.nexusTeal.withOpacity(0.8),
                    fontWeight: FontWeight.bold
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAttachmentTile(String path, int index) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
                image: FileImage(File(path)),
                fit: BoxFit.cover,
                opacity: 0.7
            ),
            border: Border.all(color: Colors.white10),
          ),
        ),
        Positioned(
          top: 2, right: 2,
          child: GestureDetector(
            onTap: () => controller.removeAttachment(index),
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(Icons.close, size: 12, color: AppColors.nexusRed),
            ),
          ),
        )
      ],
    );
  }
}