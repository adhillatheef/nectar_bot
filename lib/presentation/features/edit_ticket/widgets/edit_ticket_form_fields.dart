import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';

class NexusField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final int maxLines;
  final TextInputType? keyboardType;

  const NexusField({
    super.key,
    required this.controller,
    required this.label,
    this.maxLines = 1,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tech Label
        Row(
          children: [
            Text(
              "// $label",
              style: TextStyle(
                fontFamily: 'Courier', // Monospace for code look
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.nexusTeal.withOpacity(0.7),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Input Area
        Container(
          decoration: BoxDecoration(
            color: AppColors.nexusPanel.withOpacity(0.5),
            borderRadius: BorderRadius.circular(8),
            border: Border(bottom: BorderSide(color: AppColors.nexusTeal.withOpacity(0.5), width: 1)),
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            keyboardType: keyboardType,
            style: const TextStyle(
              fontFamily: 'Poppins',
              color: Colors.white,
              fontSize: 14,
            ),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              border: InputBorder.none,
              hintText: "Enter value...",
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.2)),
            ),
          ),
        ),
      ],
    );
  }
}

class NexusSelector extends StatelessWidget {
  final String label;
  final RxString selectedValue;
  final List<String> options;

  const NexusSelector({
    super.key,
    required this.label,
    required this.selectedValue,
    required this.options,
  });

  @override
  Widget build(BuildContext context) {
    // Smart Logic: Use Scroll if items > 3 (like Category), otherwise use fixed width (like Priority)
    final bool useScroll = options.length > 3;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "// $label",
          style: TextStyle(
            fontFamily: 'Courier',
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.nexusTeal.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white10),
          ),
          child: useScroll
              ? ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: options.length,
            itemBuilder: (context, index) {
              return _buildOptionItem(options[index], isExpanded: false);
            },
          )
              : Row(
            children: options.map((option) {
              return _buildOptionItem(option, isExpanded: true);
            }).toList(),
          ),
        )
      ],
    );
  }

  Widget _buildOptionItem(String option, {required bool isExpanded}) {
    final widget = Obx(() {
      final isSelected = selectedValue.value == option;
      return GestureDetector(
        onTap: () => selectedValue.value = option,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.all(2),
          padding: isExpanded
              ? EdgeInsets.zero // Expanded handles width
              : const EdgeInsets.symmetric(horizontal: 16), // Padding for scroll mode
          decoration: BoxDecoration(
            color: isSelected ? AppColors.nexusTeal.withOpacity(0.2) : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
            border: isSelected ? Border.all(color: AppColors.nexusTeal.withOpacity(0.5)) : null,
          ),
          alignment: Alignment.center,
          child: Text(
            option.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: isSelected ? AppColors.nexusTeal : Colors.grey,
              letterSpacing: 0.5,
            ),
          ),
        ),
      );
    });

    if (isExpanded) {
      return Expanded(child: widget);
    }
    return widget;
  }
}