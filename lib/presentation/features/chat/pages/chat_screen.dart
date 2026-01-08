import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../controller/chat_controller.dart';
import '../widgets/chat_input_area.dart';
import '../widgets/chat_bubble.dart';

class ChatScreen extends GetView<ChatController> {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        final shouldPop = await controller.handleBackPress();
        if (shouldPop) Get.back();
      },
      child: Scaffold(
        backgroundColor: AppColors.nexusDark,
        appBar: _buildAppBar(),
        body: Column(
          children: [
            // Chat List
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator(color: AppColors.nexusTeal));
                }

                return ListView.builder(
                  controller: controller.scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  // Add 1 for the "Typing..." indicator
                  itemCount: controller.messages.length + (controller.isTyping.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    // Show "Nexus is processing..." if typing
                    if (controller.isTyping.value && index == controller.messages.length) {
                      return const Padding(
                        padding: EdgeInsets.only(left: 0, bottom: 20),
                        child: Row(
                          children: [
                            SizedBox(width: 12, height: 12, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.nexusTeal)),
                            SizedBox(width: 12),
                            Text("Nexus is processing...", style: TextStyle(color: AppColors.nexusTeal, fontSize: 12, fontStyle: FontStyle.italic)),
                          ],
                        ),
                      );
                    }

                    final msg = controller.messages[index];
                    return ChatBubble(
                      text: msg.text,
                      isBot: msg.isBot,
                      attachmentPath: msg.attachmentPath,
                      attachmentType: msg.attachmentType,
                    );
                  },
                );
              }),
            ),

            // Input Capsule
            const ChatInputArea(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.nexusDark,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: Colors.white),
        onPressed: () async {
          if (await controller.handleBackPress()) Get.back();
        },
      ),
      title: Column(
        children: [
          const Text(
            "NEXUS AI SUPPORT",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: 1.5, color: Colors.white),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                    color: AppColors.nexusGreen,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: AppColors.nexusGreen.withOpacity(0.6), blurRadius: 6, spreadRadius: 1)]),
              ),
              const SizedBox(width: 6),
              const Text(
                "SECURE CONNECTION",
                style: TextStyle(color: AppColors.nexusGreen, fontSize: 8, letterSpacing: 1.0, fontWeight: FontWeight.bold),
              ),
            ],
          )
        ],
      ),
      actions: [
        IconButton(
          tooltip: "Reboot Session",
          icon: const Icon(Icons.refresh, color: AppColors.textSecondary, size: 20),
          onPressed: controller.resetChat,
        )
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(color: Colors.white.withOpacity(0.05), height: 1),
      ),
    );
  }
}
