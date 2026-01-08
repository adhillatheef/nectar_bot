import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../controller/edit_ticket_controller.dart';
import '../widgets/attachment_editor_grid.dart';
import '../widgets/edit_ticket_form_fields.dart';


class EditTicketScreen extends GetView<EditTicketController> {
  const EditTicketScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
            "Edit Ticket",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
        actions: [
          // Save Button
          Padding(
            padding: const EdgeInsets.only(right: 16.0, top: 10, bottom: 10),
            child: Obx(() => ElevatedButton(
              onPressed: controller.isLoading.value ? null : controller.saveChanges,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.nectarPurple,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: controller.isLoading.value
                  ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)
              )
                  : const Text("Save", style: TextStyle(fontWeight: FontWeight.bold)),
            )),
          )
        ],
      ),
      body: GestureDetector(
        // Dismiss keyboard on tap outside
        onTap: () => FocusScope.of(context).unfocus(),
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            // 1. Core Info
            ModernTextField(
              controller: controller.titleController,
              label: "Ticket Title",
            ),
            const SizedBox(height: 24),

            ModernTextField(
              controller: controller.descController,
              label: "Description",
              maxLines: 5,
            ),
            const SizedBox(height: 24),

            ModernTextField(
              controller: controller.locationController,
              label: "Location",
            ),
            const SizedBox(height: 24),

            // 2. Dropdowns Row
            Row(
              children: [
                Expanded(
                  child: ModernDropdown(
                    label: "Category",
                    value: controller.category,
                    items: const ["Plumbing", "Electrical", "HVAC", "IT", "Other"],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ModernDropdown(
                    label: "Priority",
                    value: controller.priority,
                    items: const ["Low", "Medium", "High"],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 3. Contact Info
            ModernTextField(
              controller: controller.contactController,
              label: "Contact Number",
              keyboardType: TextInputType.phone,
            ),

            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 24),

            // 4. Attachments
            AttachmentEditorGrid(),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}