import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';

class ChatBubble extends StatelessWidget {
  final String? text;
  final bool isBot;
  final String? attachmentPath;
  final String? attachmentType; // 'image', 'video', 'audio'

  const ChatBubble({
    super.key,
    this.text,
    required this.isBot,
    this.attachmentPath,
    this.attachmentType,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: isBot ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 6.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isBot) ...[
                  // Bot Identity
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                        border: Border.all(color: AppColors.nexusTeal, width: 1),
                        shape: BoxShape.circle
                    ),
                    child: const Icon(Icons.view_in_ar, size: 10, color: AppColors.nexusTeal),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "NEXUS AI",
                    style: TextStyle(
                        color: AppColors.nexusTeal,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                        letterSpacing: 1.0
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                Text(
                  DateTime.now().toString(),
                  style: TextStyle(
                    color: AppColors.textSecondary.withOpacity(0.5),
                    fontSize: 10,
                  ),
                ),
                if (!isBot) ...[
                  const SizedBox(width: 8),
                  const Text("YOU", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10, letterSpacing: 1.0)),
                ]
              ],
            ),
          ),

          // Main Message Module
          Container(
            constraints: BoxConstraints(maxWidth: Get.width * 0.8),
            decoration: isBot
                ? _buildBotDecoration()
                : _buildUserDecoration(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (attachmentPath != null) _buildAttachmentPreview(),
                if (text != null && text!.isNotEmpty) ...[
                  if (attachmentPath != null) const SizedBox(height: 12),
                  Text(
                    text!,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: isBot ? AppColors.textPrimary : Colors.white,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- STYLING LOGIC ---

  BoxDecoration _buildBotDecoration() {
    return BoxDecoration(
      color: AppColors.nexusPanel.withOpacity(0.6), // Glass-like
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(12),
        bottomRight: Radius.circular(12),
        bottomLeft: Radius.circular(12),
      ),
      // The "System" Border on the left
      border: const Border(
        left: BorderSide(color: AppColors.nexusTeal, width: 3),
      ),
    );
  }

  BoxDecoration _buildUserDecoration() {
    return const BoxDecoration(
      color: Color(0xFF2C3032), // Solid dark grey
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(12),
        bottomLeft: Radius.circular(12),
        bottomRight: Radius.circular(12),
      ),
    );
  }

  Widget _buildAttachmentPreview() {
    final bool isImage = attachmentType == 'image';
    final bool isVideo = attachmentType == 'video';
    final bool isAudio = attachmentType == 'audio';

    if (isAudio) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black26,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white10),
        ),
        child: const Row(
          children: [
            Icon(Icons.mic, color: AppColors.nexusTeal),
            SizedBox(width: 12),
            Text("Audio Note.m4a", style: TextStyle(color: Colors.white70, fontSize: 12)),
          ],
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.file(
              File(attachmentPath!),
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover
          ),
          if (isVideo)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle
              ),
              child: const Icon(Icons.play_arrow, color: Colors.white, size: 32),
            )
        ],
      ),
    );
  }
}