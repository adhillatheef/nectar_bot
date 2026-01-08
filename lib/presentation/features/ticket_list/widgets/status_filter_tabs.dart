import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../controller/ticket_list_controller.dart';

class StatusFilterTabs extends GetView<TicketListController> {
  const StatusFilterTabs({super.key});

  @override
  Widget build(BuildContext context) {
    final tabs = ["Open", "In Progress", "Closed"];

    return Obx(() {
      // 1. Hide tabs if the ENTIRE database is empty (no tickets to filter)
      // We check !isLoading so we don't hide it prematurely while fetching
      if (controller.allTickets.isEmpty && !controller.isLoading.value) {
        return const SizedBox.shrink();
      }

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
        color: AppColors.nexusDark,
        child: Container(
          height: 55,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppColors.nexusPanel, // The "Track" background
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: Row(
            // 2. Row + Expanded = Full Width Tabs
            children: tabs.map((status) {
              return Expanded(
                child: Obx(() {
                  final isSelected = controller.currentFilter.value == status;
                  return GestureDetector(
                    onTap: () => controller.changeFilter(status),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        // Active tab gets a distinct color, inactive is transparent
                        color: isSelected
                            ? AppColors.nexusTeal.withOpacity(0.15)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: isSelected
                            ? Border.all(color: AppColors.nexusTeal.withOpacity(0.3), width: 1)
                            : Border.all(color: Colors.transparent),
                        boxShadow: isSelected
                            ? [
                          BoxShadow(
                            color: AppColors.nexusTeal.withOpacity(0.1),
                            blurRadius: 8,
                          )
                        ]
                            : [],
                      ),
                      child: Center(
                        child: Text(
                          status.toUpperCase(),
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                            letterSpacing: 0.5,
                            // Active text is Neon, Inactive is Grey
                            color: isSelected ? AppColors.nexusTeal : AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  );
                }),
              );
            }).toList(),
          ),
        ),
      );
    });
  }
}