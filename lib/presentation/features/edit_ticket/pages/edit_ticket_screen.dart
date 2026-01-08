import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../controller/edit_ticket_controller.dart';
import '../widgets/edit_ticket_form_fields.dart';
import '../widgets/attachment_editor_grid.dart';

class EditTicketScreen extends GetView<EditTicketController> {
  const EditTicketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.nexusDark,
      appBar: AppBar(
        title: const Text("EDIT CONFIGURATION", style: TextStyle(fontSize: 14, letterSpacing: 2.0)),
        centerTitle: true,
        backgroundColor: AppColors.nexusDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ticket ID Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.nexusPanel,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.white10),
                ),
                child: Text(
                  "TICKET_ID: #${controller.titleController.text.isEmpty ? 'Unknown' : '8849-XC'}", // Placeholder ID logic or pass real ID
                  style: const TextStyle(fontFamily: 'Courier', color: AppColors.nexusTeal, fontSize: 10),
                ),
              ),
              const SizedBox(height: 32),

              // 1. Core Info
              NexusField(
                controller: controller.titleController,
                label: "TICKET TITLE",
              ),
              const SizedBox(height: 24),

              NexusField(
                controller: controller.descController,
                label: "SYSTEM LOG / DESCRIPTION",
                maxLines: 5,
              ),
              const SizedBox(height: 24),

              // 2. Selectors (Category & Priority)
              NexusSelector(
                label: "PRIORITY LEVEL",
                selectedValue: controller.priority,
                options: const ["Low", "Medium", "High"],
              ),
              const SizedBox(height: 24),

              NexusSelector(
                label: "SYSTEM CATEGORY",
                selectedValue: controller.category,
                options: const ["Plumbing", "Electrical", "HVAC", "IT", "Other"],
              ),
              const SizedBox(height: 24),

              // 3. Location & Contact
              NexusField(
                controller: controller.locationController,
                label: "LOCATION NODE",
              ),
              const SizedBox(height: 24),

              NexusField(
                controller: controller.contactController,
                label: "CONTACT FREQUENCY",
                keyboardType: TextInputType.phone,
              ),

              const SizedBox(height: 32),

              // 4. Attachments
              const AttachmentEditorGrid(),

              const SizedBox(height: 48),

              // 5. Execute Button
              Obx(() => SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: controller.isLoading.value ? null : controller.saveChanges,
                      icon: controller.isLoading.value
                          ? Container(
                              width: 24,
                              height: 24,
                              padding: const EdgeInsets.all(2),
                              child: const CircularProgressIndicator(color: Colors.black, strokeWidth: 2))
                          : const Icon(Icons.terminal, color: Colors.black),
                      label: Text(
                        controller.isLoading.value ? "PROCESSING..." : "EXECUTE UPDATE",
                        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.nexusTeal,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        shadowColor: AppColors.nexusTeal.withOpacity(0.4),
                        elevation: 10,
                      ),
                    ),
                  )),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
