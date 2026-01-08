import 'package:get/get.dart';
import '../../../../core/utils/custom_snackbar.dart';
import '../../../../domain/entities/ticket.dart';
import '../../../../domain/usecases/get_tickets_usecase.dart';

class TicketListController extends GetxController {
  final GetTicketsUseCase _getTicketsUseCase = Get.find();

  // Observables
  var allTickets = <Ticket>[].obs;
  var displayedTickets = <Ticket>[].obs;
  var isLoading = false.obs;
  var currentFilter = 'Open'.obs;

  @override
  void onInit() {
    super.onInit();
    loadTickets();
  }

  void loadTickets() async {
    isLoading.value = true;
    try {
      final result = await _getTicketsUseCase();
      result.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      allTickets.assignAll(result);
      _applyFilter();
    } catch (e) {
      CustomSnackbar.show(title: "Error", message: "Failed to load tickets", isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  void changeFilter(String status) {
    currentFilter.value = status;
    _applyFilter();
  }

  void _applyFilter() {
    displayedTickets.value = allTickets.where((t) {
      return t.status.toLowerCase() == currentFilter.value.toLowerCase();
    }).toList();
  }

  void createNewTicket() {
    Get.toNamed('/chat');
  }
}
