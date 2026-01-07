import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/chat/chat_controller.dart';
import '../../widgets/input_fields/chat_input_area.dart';
import '../../widgets/chat_bubble.dart';

class ChatScreen extends StatelessWidget {
  final ChatController controller = Get.put(ChatController());

  ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar automatically uses the style from AppTheme
      appBar: AppBar(
        title: const Text("Nectar Support"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Optional: Reset chat for testing
              // controller.resetChat();
            },
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              return ListView.builder(
                controller: controller.scrollController, // <--- Attach Controller Here
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                itemCount: controller.messages.length + (controller.isTyping.value ? 1 : 0),
                itemBuilder: (context, index) {
                  // Show "Typing..." indicator as the last item if isTyping is true
                  if (controller.isTyping.value && index == controller.messages.length) {
                    return const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Text("Typing...", style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic)),
                      ),
                    );
                  }

                  final msg = controller.messages[index];
                  return ChatBubble(text: msg.text, isBot: msg.isBot);
                },
              );
            }),
          ),
          ChatInputArea(),
        ],
      ),
    );
  }
}