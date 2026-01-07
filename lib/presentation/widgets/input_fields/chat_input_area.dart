import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../controllers/chat/chat_controller.dart';
import '../../../data/models/form_field_model.dart';

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
        if (question == null || controller.isTyping.value) {
          return const SizedBox(height: 50, child: Center(child: Text("...")));
        }

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
      }),
    );
  }

  Widget _buildTextInput(BuildContext context, {bool isDate = false, bool isTime = false}) {
    final textController = TextEditingController();
    final bool allowAttachments = controller.currentQuestion.value?.id == 'attachments';
    // FIX: Check if the current question is required
    final bool isRequired = controller.currentQuestion.value?.required ?? false;

    return Obx(() {
      if (controller.isRecording.value) {
        return Row(
          children: [
            const Icon(Icons.mic, color: Colors.red, size: 28),
            const SizedBox(width: 12),
            Expanded(child: Text("Recording...", style: TextStyle(color: Colors.red[700], fontWeight: FontWeight.bold))),
            GestureDetector(
              onTap: () => controller.toggleRecording(),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                child: const Icon(Icons.stop, color: Colors.white),
              ),
            ),
          ],
        );
      }

      return Row(
        children: [
          if (allowAttachments) ...[
            IconButton(
              icon: const Icon(Icons.attach_file, color: AppColors.secondaryPurple),
              onPressed: () => controller.pickFromGallery(),
            ),
            IconButton(
              icon: const Icon(Icons.camera_alt, color: AppColors.secondaryPurple),
              onPressed: () => _showCameraOptions(context),
            ),
          ],

          Expanded(
            child: TextField(
              controller: textController,
              readOnly: isDate || isTime,
              style: Theme.of(context).textTheme.bodyMedium,
              decoration: InputDecoration(
                // FIX: Update hint text to show (optional)
                hintText: isDate ? "Select Date" : (isTime ? "Select Time" : (isRequired ? "Type answer..." : "Type answer (Optional)")),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                suffixIcon: (isDate || isTime)
                    ? Icon(isDate ? Icons.calendar_today : Icons.access_time, color: AppColors.secondaryPurple)
                    : null,
              ),
              onTap: () async {
                if (isDate) {
                  DateTime? picked = await showDatePicker(
                      context: context, initialDate: DateTime.now(), firstDate: DateTime(2020), lastDate: DateTime(2030),
                      builder: (context, child) => Theme(data: Theme.of(context).copyWith(colorScheme: const ColorScheme.light(primary: AppColors.primaryPurple)), child: child!)
                  );
                  if (picked != null) textController.text = picked.toString().split(' ')[0];
                }
                else if (isTime) {
                  TimeOfDay? picked = await showTimePicker(context: context, initialTime: TimeOfDay.now(),
                      builder: (context, child) => Theme(data: Theme.of(context).copyWith(colorScheme: const ColorScheme.light(primary: AppColors.primaryPurple)), child: child!)
                  );
                  if (picked != null) textController.text = picked.format(context);
                }
              },
            ),
          ),

          if (allowAttachments)
            IconButton(
              icon: const Icon(Icons.mic, color: AppColors.secondaryPurple),
              onPressed: () => controller.toggleRecording(),
            ),

          const SizedBox(width: 4),

          // --- SEND BUTTON (FIXED) ---
          Container(
            decoration: const BoxDecoration(color: AppColors.primaryPurple, shape: BoxShape.circle),
            child: IconButton(
              // Show Checkmark if input is empty AND (it's optional OR attachment step)
              icon: Icon(
                  (textController.text.isEmpty && (!isRequired || allowAttachments))
                      ? Icons.check
                      : Icons.send_rounded,
                  color: Colors.white
              ),
              onPressed: () {
                // FIX: Allow proceed if text is NOT empty OR it is an attachment step OR it is Optional
                if (textController.text.isNotEmpty || allowAttachments || !isRequired) {
                  controller.handleUserResponse(textController.text);
                  textController.clear();
                }
              },
            ),
          )
        ],
      );
    });
  }

  void _showCameraOptions(BuildContext context) {
    Get.bottomSheet(
      Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: Wrap(
          children: [
            ListTile(leading: const Icon(Icons.camera_alt), title: const Text('Take Photo'), onTap: () { Get.back(); controller.pickFromCamera(false); }),
            ListTile(leading: const Icon(Icons.videocam), title: const Text('Record Video'), onTap: () { Get.back(); controller.pickFromCamera(true); }),
          ],
        ),
      ),
    );
  }

  Widget _buildModernSelectionGrid(FormFieldModel question) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: question.options!.map((option) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: const BorderSide(color: AppColors.secondaryPurple),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              backgroundColor: Colors.purple.withOpacity(0.05),
            ),
            onPressed: () => controller.handleUserResponse(option),
            child: Text(option, style: const TextStyle(color: AppColors.primaryPurple, fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        );
      }).toList(),
    );
  }
}