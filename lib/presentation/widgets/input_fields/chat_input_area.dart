import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/form_field_model.dart';
import '../../controllers/chat/chat_controller.dart';

class ChatInputArea extends StatelessWidget {
  final ChatController controller = Get.find();

  ChatInputArea({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // Add safe area padding for bottom of screen
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

        // If bot is thinking or no question, hide input
        if (question == null) {
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

  // FIXED: Time Picker Logic Added
  Widget _buildTextInput(BuildContext context, {bool isDate = false, bool isTime = false}) {
    final textController = TextEditingController();

    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: textController,
            readOnly: isDate || isTime,
            style: Theme.of(context).textTheme.bodyMedium,
            decoration: InputDecoration(
              hintText: isDate ? "Select Date..." : (isTime ? "Select Time..." : "Type your answer..."),
              suffixIcon: Icon(
                isDate ? Icons.calendar_today : (isTime ? Icons.access_time : null),
                color: AppColors.secondaryPurple,
              ),
            ),
            onTap: () async {
              if (isDate) {
                DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                    builder: (context, child) => Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.light(primary: AppColors.primaryPurple),
                        ), child: child!
                    )
                );
                if (picked != null) textController.text = picked.toString().split(' ')[0];
              }
              else if (isTime) {
                // Time Picker Logic
                TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                    builder: (context, child) => Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.light(primary: AppColors.primaryPurple),
                        ), child: child!
                    )
                );
                if (picked != null) {
                  // Format TimeOfDay to String (HH:MM AM/PM)
                  textController.text = picked.format(context);
                }
              }
            },
          ),
        ),
        const SizedBox(width: 12),
        Container(
          decoration: const BoxDecoration(
            color: AppColors.primaryPurple,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.send_rounded, color: Colors.white),
            onPressed: () => controller.handleUserResponse(textController.text),
          ),
        )
      ],
    );
  }

  // IMPROVED: Better UI for Selections (Vertical list of full-width buttons)
  Widget _buildModernSelectionGrid(FormFieldModel question) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch to full width
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
            child: Text(
              option,
              style: const TextStyle(
                color: AppColors.primaryPurple,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}