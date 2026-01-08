import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../routes/app_routes.dart';
import '../controller/ticket_list_controller.dart';
import '../widgets/dashboard_app_bar.dart';
import '../widgets/status_filter_tabs.dart';
import '../widgets/ticket_card.dart';
import '../widgets/empty_ticket_state.dart';
import '../widgets/ai_floating_action_button.dart';

class TicketListScreen extends GetView<TicketListController> {
  const TicketListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.nexusDark,
      appBar: const DashboardAppBar(),
      floatingActionButton: AIFloatingActionButton(
        onPressed: controller.createNewTicket,
      ),
      body: Column(
        children: [
          const StatusFilterTabs(),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.nexusTeal),
                );
              }

              if (controller.displayedTickets.isEmpty) {
                return const EmptyTicketState();
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                itemCount: controller.displayedTickets.length,
                itemBuilder: (context, index) {
                  final ticket = controller.displayedTickets[index];
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
          ),
        ],
      ),
    );
  }
}
