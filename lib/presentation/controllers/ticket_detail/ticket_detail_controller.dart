import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../domain/entities/ticket.dart';
import '../../../domain/repositories/i_ticket_repository.dart';
// FIX: Alias the database import to avoid name collision with 'Ticket' class
import '../../../data/datasources/local/app_database.dart' as db;

class TicketDetailController extends GetxController {
  final ITicketRepository _repository = Get.find();
  // Use the alias 'db.'
  final db.AppDatabase _db = Get.find();

  // Use Rxn for nullable safety
  final ticket = Rxn<Ticket>();

  var isLoading = false.obs;
  var attachments = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Debug print to confirm what we received
    print("Detail Args Type: ${Get.arguments.runtimeType}");

    if (Get.arguments != null && Get.arguments is Ticket) {
      ticket.value = Get.arguments as Ticket;
      _loadAttachments();
    } else {
      print("Error: Argument mismatch. Expected 'Ticket', got '${Get.arguments.runtimeType}'");
      // Fallback: If it's not null but type check failed, try to force it (optional safety)
      if (Get.arguments != null) {
        try {
          ticket.value = Get.arguments as Ticket;
          _loadAttachments();
        } catch (e) {
          print("Force cast failed: $e");
          Get.back();
        }
      } else {
        Get.back();
      }
    }
  }

  void _loadAttachments() async {
    if (ticket.value == null) return;

    // Use the alias 'db.'
    final results = await _db.getAttachmentsForTicket(ticket.value!.id);
    attachments.value = results.map((e) => e.filePath).toList();
  }

  void updateStatus(String newStatus) async {
    if (ticket.value == null || ticket.value!.status == newStatus) return;

    isLoading.value = true;
    try {
      await _repository.updateTicketStatus(ticket.value!.id, newStatus);

      // Update local state
      final val = ticket.value!;
      ticket.value = Ticket(
        id: val.id,
        title: val.title,
        description: val.description,
        category: val.category,
        priority: val.priority,
        status: newStatus,
        location: val.location,
        createdAt: val.createdAt,
        reportedBy: val.reportedBy,

        assetId: val.assetId,
        contactNumber: val.contactNumber,
        email: val.email,
        preferredDate: val.preferredDate,
        preferredTime: val.preferredTime,
        accessRequired: val.accessRequired,
        sla: val.sla,
      );

      Get.snackbar("Updated", "Status changed to $newStatus");
    } catch (e) {
      Get.snackbar("Error", "Failed to update status");
    } finally {
      isLoading.value = false;
    }
  }

  void deleteTicket() async {
    if (ticket.value == null) return;

    Get.defaultDialog(
        title: "Delete Ticket",
        middleText: "Are you sure you want to delete this ticket?",
        textConfirm: "Delete",
        textCancel: "Cancel",
        confirmTextColor: Colors.white,
        onConfirm: () async {
          await _repository.deleteTicket(ticket.value!.id);
          Get.back();
          Get.back(result: true);
          Get.snackbar("Deleted", "Ticket deleted successfully");
        }
    );
  }
}