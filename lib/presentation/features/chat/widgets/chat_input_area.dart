import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/form_field_model.dart';
import '../controller/chat_controller.dart';

class ChatInputArea extends StatelessWidget {
  final ChatController controller = Get.find();

  ChatInputArea({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 12, 16, MediaQuery.of(context).viewInsets.bottom + 24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          )
        ],
      ),
      child: Obx(() {
        final question = controller.currentQuestion.value;
        final isTyping = controller.isTyping.value;
        final isDisabled = controller.isInputDisabled.value;

        // If completely loading (start of chat), show loader
        if (controller.isLoading.value) {
          return const SizedBox(height: 50, child: Center(child: CircularProgressIndicator()));
        }

        // Keep widget tree stable to prevent focus loss, just disable interactions
        return IgnorePointer(
          ignoring: isDisabled || isTyping,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: (isDisabled || isTyping) ? 0.5 : 1.0,
            child: _buildInputContent(context, question),
          ),
        );
      }),
    );
  }

  Widget _buildInputContent(BuildContext context, FormFieldModel? question) {
    if (question == null) return const SizedBox(height: 50);

    switch (question.type) {
      case 'single_choice':
        return _buildModernSelectionGrid(question);
      case 'date':
        return _buildTextInput(context, isDate: true);
      case 'time':
        return _buildTextInput(context, isTime: true);
      case 'text':
      default:
        return _buildTextInput(context);
    }
  }

  Widget _buildTextInput(BuildContext context, {bool isDate = false, bool isTime = false}) {
    final textController = TextEditingController();
    final bool allowAttachments = controller.currentQuestion.value?.id == 'attachments';
    final bool isRequired = controller.currentQuestion.value?.required ?? false;

    return Obx(() {
      if (controller.isRecording.value) {
        return _buildRecordingUI();
      }

      return Row(
        children: [
          if (allowAttachments) ...[
            _buildAttachmentButton(Icons.image, controller.pickFromGallery),
            _buildAttachmentButton(Icons.camera_alt, () => _showCameraOptions(context)),
          ],

          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: textController,
                readOnly: isDate || isTime,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  hintText: isDate
                      ? "Select Date"
                      : (isTime ? "Select Time" : (isRequired ? "Type answer..." : "Type answer (Optional)")),
                  hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  suffixIcon: (isDate || isTime)
                      ? Icon(isDate ? Icons.calendar_today : Icons.access_time, color: AppColors.nectarPurple, size: 20)
                      : null,
                ),
                onTap: () async {
                  if (isDate) {
                    DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                        builder: (context, child) => Theme(data: Theme.of(context).copyWith(colorScheme: const ColorScheme.light(primary: AppColors.nectarPurple)), child: child!)
                    );
                    if (picked != null) {
                      textController.text = picked.toString().split(' ')[0];
                      controller.handleUserResponse(textController.text);
                    }
                  } else if (isTime) {
                    TimeOfDay? picked = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                        builder: (context, child) => Theme(data: Theme.of(context).copyWith(colorScheme: const ColorScheme.light(primary: AppColors.nectarPurple)), child: child!)
                    );
                    if (picked != null) {
                      textController.text = picked.format(context);
                      controller.handleUserResponse(textController.text);
                    }
                  }
                },
                onSubmitted: (val) {
                  if (val.trim().isNotEmpty) {
                    controller.handleUserResponse(val.trim());
                    textController.clear();
                  }
                },
              ),
            ),
          ),

          if (allowAttachments)
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: _buildAttachmentButton(Icons.mic, controller.toggleRecording),
            ),

          const SizedBox(width: 8),

          // Send Button
          GestureDetector(
            onTap: () {
              // Logic: Proceed if text present OR (optional AND no text) OR (attachments present)
              // Simple logic: pass text to controller, controller decides validity
              controller.handleUserResponse(textController.text);
              textController.clear();
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
            ),
          )
        ],
      );
    });
  }

  Widget _buildRecordingUI() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Row(
        children: [
          const Icon(Icons.mic, color: Colors.red, size: 24),
          const SizedBox(width: 8),
          const Expanded(
              child: Text("Recording...", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))
          ),
          GestureDetector(
            onTap: controller.toggleRecording,
            child: const Icon(Icons.stop_circle_outlined, color: Colors.red, size: 32),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentButton(IconData icon, VoidCallback onTap) {
    return IconButton(
      icon: Icon(icon, color: Colors.grey[600], size: 24),
      onPressed: onTap,
      padding: const EdgeInsets.all(8),
      constraints: const BoxConstraints(),
      splashRadius: 20,
    );
  }

  void _showCameraOptions(BuildContext context) {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: Wrap(
          children: [
            ListTile(
                leading: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.blue.shade50, shape: BoxShape.circle), child: const Icon(Icons.camera_alt, color: Colors.blue)),
                title: const Text('Take Photo', style: TextStyle(fontWeight: FontWeight.w600)),
                onTap: () { Get.back(); controller.pickFromCamera(false); }
            ),
            ListTile(
                leading: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.orange.shade50, shape: BoxShape.circle), child: const Icon(Icons.videocam, color: Colors.orange)),
                title: const Text('Record Video', style: TextStyle(fontWeight: FontWeight.w600)),
                onTap: () { Get.back(); controller.pickFromCamera(true); }
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernSelectionGrid(FormFieldModel question) {
    return SizedBox(
      height: 60, // Fixed height for horizontal scroll or grid
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: question.options!.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final option = question.options![index];
          return ActionChip(
            label: Text(option),
            labelStyle: const TextStyle(color: AppColors.nectarPurple, fontWeight: FontWeight.w600),
            backgroundColor: Colors.white,
            side: const BorderSide(color: AppColors.nectarPurple),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            onPressed: () => controller.handleUserResponse(option),
            elevation: 1,
            pressElevation: 4,
          );
        },
      ),
    );
  }
}