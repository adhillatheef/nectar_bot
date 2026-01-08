import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../controller/ticket_list_controller.dart';
import '../../../routes/app_routes.dart';
import '../widgets/ai_floating_action_button.dart';
import '../widgets/empty_ticket_state.dart';
import '../widgets/ticket_card.dart';

class TicketListScreen extends GetView<TicketListController> {
  const TicketListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(TicketListController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      floatingActionButton: AIFloatingActionButton(
        onPressed: controller.createNewTicket,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: AppColors.nectarPurple));
        }

        if (controller.tickets.isEmpty) {
          return const EmptyTicketState();
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          itemCount: controller.tickets.length,
          itemBuilder: (context, index) {
            final ticket = controller.tickets[index];
            return TicketCard(
              ticket: ticket,
              index: index,
              onTap: () async {
                await Get.toNamed(Routes.TICKET_DETAIL, arguments: ticket);
                controller.loadTickets();
              },
            );
          },
        );
      }),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: const Row(
        children: [
          Text(
            "nectar.",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: AppColors.nectarPurple,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }
}