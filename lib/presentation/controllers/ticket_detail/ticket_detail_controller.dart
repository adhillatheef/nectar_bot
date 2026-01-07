import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../domain/entities/ticket.dart';
import '../../../domain/repositories/i_ticket_repository.dart';

class TicketDetailController extends GetxController {
  final ITicketRepository _repository = Get.find();

  // The ticket is passed as an argument from the List Screen
  late Rx<Ticket> ticket;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Read the passed Ticket object
    if (Get.arguments is Ticket) {
      ticket = (Get.arguments as Ticket).obs;
    } else {
      Get.back(); // Error safety
    }
  }

  // Update Status [cite: 69]
  void updateStatus(String newStatus) async {
    if (ticket.value.status == newStatus) return;

    isLoading.value = true;
    try {
      await _repository.updateTicketStatus(ticket.value.id, newStatus);

      // Update local observable to reflect change immediately in UI [cite: 70]
      ticket.update((val) {
        if (val != null) {
          // We create a new instance because Ticket entity is immutable
          ticket.value = Ticket(
            id: val.id,
            title: val.title,
            description: val.description,
            category: val.category,
            priority: val.priority,
            status: newStatus, // <--- changed
            location: val.location,
            createdAt: val.createdAt,
          );
        }
      });

      Get.snackbar("Updated", "Status changed to $newStatus");
    } catch (e) {
      Get.snackbar("Error", "Failed to update status");
    } finally {
      isLoading.value = false;
    }
  }

  // Delete Ticket [cite: 68]
  void deleteTicket() async {
    Get.defaultDialog(
        title: "Delete Ticket",
        middleText: "Are you sure you want to delete this ticket?",
        textConfirm: "Delete",
        textCancel: "Cancel",
        confirmTextColor: Colors.white,
        onConfirm: () async {
          await _repository.deleteTicket(ticket.value.id);
          Get.back(); // Close Dialog
          Get.back(result: true); // Go back to List and signal refresh
          Get.snackbar("Deleted", "Ticket deleted successfully");
        }
    );
  }
}