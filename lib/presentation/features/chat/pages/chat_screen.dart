import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../controller/chat_controller.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/chat_input_area.dart';

class ChatScreen extends GetView<ChatController> {

  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        final shouldPop = await controller.handleBackPress();
        if (shouldPop) {
          Get.back();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text("Nectar Assistant", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 20),
            onPressed: () async {
              if (await controller.handleBackPress()) Get.back();
            },
          ),
          actions: [
            IconButton(
              tooltip: "Restart Session",
              icon: const Icon(Icons.refresh, color: AppColors.nectarPurple),
              onPressed: controller.resetChat,
            )
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator(color: AppColors.nectarPurple));
                }

                return ListView.builder(
                  controller: controller.scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  itemCount: controller.messages.length + (controller.isTyping.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    // Typing Indicator
                    if (controller.isTyping.value && index == controller.messages.length) {
                      return const Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 12, top: 8),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 12,
                                backgroundColor: Colors.white,
                                // Placeholder for Nectar logo
                                child: Icon(Icons.auto_awesome, size: 14, color: AppColors.nectarPurple),
                              ),
                              SizedBox(width: 8),
                              Text("Nectar is typing...", style: TextStyle(color: Colors.grey, fontSize: 12)),
                            ],
                          ),
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
            ChatInputArea(),
          ],
        ),
      ),
    );
  }
}
