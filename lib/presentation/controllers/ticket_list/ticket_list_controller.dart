import 'package:get/get.dart';
import '../../../domain/entities/ticket.dart';
import '../../../domain/repositories/i_ticket_repository.dart';
import '../../../domain/usecases/get_tickets_usecase.dart';

class TicketListController extends GetxController {
  final GetTicketsUseCase _getTicketsUseCase = Get.find();
  final ITicketRepository _repository = Get.find(); // For delete/update direct calls for now

  var tickets = <Ticket>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadTickets();
  }

  void loadTickets() async {
    isLoading.value = true;
    try {
      final result = await _getTicketsUseCase();
      tickets.assignAll(result);
    } catch (e) {
      Get.snackbar("Error", "Failed to load tickets");
    } finally {
      isLoading.value = false;
    }
  }

  void deleteTicket(String id) async {
    await _repository.deleteTicket(id);
    loadTickets(); // Refresh list
    Get.snackbar("Deleted", "Ticket deleted successfully");
  }

  void createNewTicket() {
    // Navigate to Chat Screen to create new
    Get.toNamed('/chat')?.then((_) => loadTickets());
  }
}