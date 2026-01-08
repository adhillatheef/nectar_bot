import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/utils/custom_snackbar.dart';
import '../../../../domain/entities/ticket.dart';
import '../../../../domain/usecases/delete_ticket_usecase.dart';
import '../../../../domain/usecases/update_ticket_status_usecase.dart';
import '../../../../domain/usecases/get_ticket_by_id_usecase.dart';
import '../../../routes/app_routes.dart';

class TicketDetailController extends GetxController {
  // Inject Use Cases
  final DeleteTicketUseCase _deleteTicketUseCase = Get.find();
  final UpdateTicketStatusUseCase _updateStatusUseCase = Get.find();
  final GetTicketByIdUseCase _getTicketByIdUseCase = Get.find();

  final ticket = Rxn<Ticket>();
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is Ticket) {
      ticket.value = Get.arguments as Ticket;
      // Immediately refresh to get attachments if they weren't passed fully
      _refreshTicketDetails();
    } else {
      Get.back();
    }
  }

  void _refreshTicketDetails() async {
    if (ticket.value == null) return;
    final freshTicket = await _getTicketByIdUseCase(ticket.value!.id);
    if (freshTicket != null) {
      ticket.value = freshTicket;
    }
  }

  void updateStatus(String newStatus) async {
    if (ticket.value == null) return;
    isLoading.value = true;
    try {
      await _updateStatusUseCase(ticket.value!.id, newStatus);
      _refreshTicketDetails(); // Reload to reflect changes
      CustomSnackbar.show(title: "Success", message: "Status updated to $newStatus");
    } catch (e) {
      CustomSnackbar.show(title: "Error", message: "Failed to update status", isError: true );
    } finally {
      isLoading.value = false;
    }
  }

  void deleteTicket() {
    Get.defaultDialog(
        title: "Delete Ticket",
        middleText: "Are you sure you want to delete this ticket?",
        textConfirm: "Delete",
        textCancel: "Cancel",
        confirmTextColor: Colors.white,
        onConfirm: () async {
          await _deleteTicketUseCase(ticket.value!.id);
          Get.back(); // Close Dialog
          Get.back(result: true); // Go back to List
          CustomSnackbar.show(title: "Success", message: "Ticket deleted successfully");
        }
    );
  }

  void navigateToEdit() async {
    if (ticket.value == null) return;

    final result = await Get.toNamed(Routes.EDIT_TICKET, arguments: ticket.value);

    if (result == true) {
      _refreshTicketDetails();
      CustomSnackbar.show(title: "Success", message: "Ticket updated successfully");
    }
  }
}