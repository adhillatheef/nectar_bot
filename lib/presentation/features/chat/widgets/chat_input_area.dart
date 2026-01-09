import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/form_field_model.dart';
import '../controller/chat_controller.dart';

class ChatInputArea extends GetView<ChatController> {
  const ChatInputArea({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.nexusDark,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Obx(() {
            final question = controller.currentQuestion.value;
            final isLoading = controller.isLoading.value;
            final isTyping = controller.isTyping.value;
            final isRecording = controller.isRecording.value;

            // 1. Loading State
            if (isLoading || question == null) {
              return const SizedBox(height: 50);
            }

            // 2. Recording State (Red Capsule)
            if (isRecording) {
              return _buildRecordingCapsule();
            }

            // 3. Normal Input State
            return IgnorePointer(
              ignoring: isTyping,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: isTyping ? 0.5 : 1.0,
                child: _buildInputContent(context, question),
              ),
            );
          }),
        ),
      ),
    );
  }

  // --- WIDGET: RECORDING CAPSULE (Red/Active State) ---
  Widget _buildRecordingCapsule() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.nexusPanel,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.nexusRed.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: AppColors.nexusRed.withOpacity(0.1),
            blurRadius: 15,
            spreadRadius: 1,
          )
        ],
      ),
      child: Row(
        children: [
          // Blinking Mic Icon
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.2, end: 1.0),
              duration: const Duration(seconds: 1),
              curve: Curves.easeInOut,
              builder: (context, value, child) {
                return Icon(Icons.mic, color: AppColors.nexusRed.withOpacity(value));
              },
              child: const Icon(Icons.mic, color: AppColors.nexusRed),
            ),
          ),

          const SizedBox(width: 12),

          const Expanded(
            child: Text(
              "Recording Audio...",
              style: TextStyle(
                  color: AppColors.nexusRed,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5
              ),
            ),
          ),

          // Stop Button
          IconButton(
            icon: const Icon(Icons.stop_circle_outlined, color: AppColors.nexusRed, size: 28),
            onPressed: controller.toggleRecording,
          ),
        ],
      ),
    );
  }

  Widget _buildInputContent(BuildContext context, FormFieldModel question) {
    switch (question.type) {
      case 'single_choice':
        return _buildHoloOptionsGrid(question);
      case 'date':
        return _buildSimpleInput(context, question, isDate: true);
      case 'time':
        return _buildSimpleInput(context, question, isTime: true);
      case 'text':
      default:
        return _buildSimpleInput(context, question);
    }
  }

  // --- WIDGET: HOLOGRAPHIC OPTIONS (Preserved) ---
  Widget _buildHoloOptionsGrid(FormFieldModel question) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0, left: 4),
          child: Row(
            children: [
              const Icon(Icons.terminal, size: 12, color: AppColors.nexusTeal),
              const SizedBox(width: 6),
              Text(
                "SELECT INPUT PROTOCOL >",
                style: TextStyle(
                    fontFamily: 'CourierPrime',
                    fontSize: 10,
                    color: AppColors.nexusTeal.withOpacity(0.7),
                    letterSpacing: 1.0,
                    fontWeight: FontWeight.bold
                ),
              ),
            ],
          ),
        ),

        SizedBox(
          height: 44,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: question.options?.length ?? 0,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final option = question.options![index];
              return _buildHoloCard(option);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHoloCard(String text) {
    return GestureDetector(
      onTap: () => controller.handleUserResponse(text),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: AppColors.nexusPanel,
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            border: Border.all(
                color: AppColors.nexusTeal.withOpacity(0.3),
                width: 1
            ),
            boxShadow: [
              BoxShadow(
                  color: AppColors.nexusTeal.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2)
              )
            ]
        ),
        child: Text(
          text.toUpperCase(),
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontFamily: 'CourierPrime',
            fontWeight: FontWeight.bold,
            fontSize: 13,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  // --- WIDGET: STANDARD TEXT INPUT ---
  Widget _buildSimpleInput(BuildContext context, FormFieldModel question, {bool isDate = false, bool isTime = false}) {
    final bool allowAttachments = question.id == 'attachments';
    final bool isOptional = !question.required;

    String hintText = "Type command...";
    if (isDate) hintText = "Select Date";
    else if (isTime) hintText = "Select Time";
    else if (isOptional) hintText = "Type message (Optional)...";

    // Preserved Decoration from your file
    return Container(
      decoration: BoxDecoration(
        color: AppColors.nexusPanel,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          // A. Attachment Icon
          if (allowAttachments)
            IconButton(
              icon: const Icon(Icons.attach_file, color: AppColors.textSecondary, size: 20),
              onPressed: () => _showAttachmentOptions(context),
            )
          else
            const SizedBox(width: 12),

          // B. Input Field
          Expanded(
            child: TextField(
              controller: controller.textController,
              readOnly: isDate || isTime,
              style: const TextStyle(color: Colors.white, fontFamily: 'Poppins', fontSize: 14),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(color: AppColors.textSecondary.withOpacity(0.5), fontSize: 13),
                filled: false,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
              ),
              onTap: () {
                if (isDate) _pickDate(context);
                if (isTime) _pickTime(context);
              },
              onSubmitted: (val) => _submitText(),
            ),
          ),

          // C. Mic Icon (New - Only if allowed)
          if (allowAttachments)
            IconButton(
              icon: const Icon(Icons.mic, color: AppColors.textSecondary, size: 20),
              onPressed: controller.toggleRecording,
            ),

          // D. Send Button (Simple Style)
          IconButton(
            icon: const Icon(Icons.arrow_upward, color: AppColors.nexusTeal, size: 20),
            onPressed: _submitText,
          ),
        ],
      ),
    );
  }

  // --- HELPERS ---
  void _submitText() {
    final text = controller.textController.text.trim();
    controller.handleUserResponse(text);
    controller.textController.clear();
  }

  Future<void> _pickDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) => Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.nexusTeal,
              onPrimary: Colors.black,
              surface: AppColors.nexusPanel,
            ),
          ),
          child: child!
      ),
    );
    if (picked != null) {
      controller.textController.text = DateFormat('yyyy-MM-dd').format(picked);
      _submitText();
    }
  }

  Future<void> _pickTime(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) => Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.nexusTeal,
              onPrimary: Colors.black,
              surface: AppColors.nexusPanel,
            ),
          ),
          child: child!
      ),
    );
    if (picked != null) {
      // ignore: use_build_context_synchronously
      controller.textController.text = picked.format(context);
      _submitText();
    }
  }

  void _showAttachmentOptions(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: AppColors.nexusPanel,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Wrap(
          children: [
            _buildOption(Icons.image, "Gallery", () => controller.pickMedia(isCamera: false)),
            _buildOption(Icons.camera_alt, "Camera", () => controller.pickMedia(isCamera: true)),
            _buildOption(Icons.videocam, "Video", () => controller.pickVideo()),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(IconData icon, String label, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.nexusTeal),
      title: Text(label, style: const TextStyle(color: Colors.white, fontFamily: 'Poppins')),
      onTap: () {
        Get.back();
        onTap();
      },
    );
  }
}