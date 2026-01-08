import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../../../../domain/entities/ticket.dart';
import '../../../../domain/usecases/update_ticket_usecase.dart';

class EditTicketController extends GetxController {
  final UpdateTicketUseCase _updateTicketUseCase = Get.find();

  // Text Controllers
  final titleController = TextEditingController();
  final descController = TextEditingController();
  final locationController = TextEditingController();
  final contactController = TextEditingController();

  // Observables
  var category = 'Other'.obs;
  var priority = 'Low'.obs;
  var attachments = <String>[].obs;
  var isLoading = false.obs;

  late String _ticketId;
  late Ticket _originalTicket;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is Ticket) {
      _originalTicket = Get.arguments as Ticket;
      _populateFields(_originalTicket);
    }
  }

  void _populateFields(Ticket t) {
    _ticketId = t.id;
    titleController.text = t.title;
    descController.text = t.description;
    locationController.text = t.location;
    contactController.text = t.contactNumber ?? "";
    category.value = t.category;
    priority.value = t.priority;
    attachments.assignAll(t.attachments);
  }

  // --- Attachment Logic (Add/Remove) ---

  void pickAttachment() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      // Save locally
      final directory = await getApplicationDocumentsDirectory();
      final String fileName = "${DateTime.now().millisecondsSinceEpoch}_${p.basename(image.path)}";
      final String localPath = p.join(directory.path, fileName);
      await File(image.path).copy(localPath);

      attachments.add(localPath);
    }
  }

  void removeAttachment(int index) {
    attachments.removeAt(index);
  }

  // --- Save Logic ---

  void saveChanges() async {
    if (titleController.text.isEmpty || descController.text.isEmpty) {
      Get.snackbar("Error", "Title and Description are required");
      return;
    }

    isLoading.value = true;

    // Create updated entity
    final updatedTicket = Ticket(
      id: _ticketId,
      title: titleController.text,
      description: descController.text,
      category: category.value,
      priority: priority.value,
      location: locationController.text,
      contactNumber: contactController.text,
      // Keep original values for uneditable fields
      status: _originalTicket.status,
      createdAt: _originalTicket.createdAt,
      reportedBy: _originalTicket.reportedBy,
      assetId: _originalTicket.assetId,
      email: _originalTicket.email,
      preferredDate: _originalTicket.preferredDate,
      preferredTime: _originalTicket.preferredTime,
      accessRequired: _originalTicket.accessRequired,
      sla: _originalTicket.sla,
      attachments: List.from(attachments),
    );

    try {
      await _updateTicketUseCase(updatedTicket);
      Get.back(result: true); // Return 'true' to trigger refresh
    } catch (e) {
      Get.snackbar("Error", "Failed to update ticket");
    } finally {
      isLoading.value = false;
    }
  }
}