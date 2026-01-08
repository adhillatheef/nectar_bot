import 'package:get/get.dart';
import '../controller/edit_ticket_controller.dart';

class EditTicketBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditTicketController>(() => EditTicketController());
  }
}