import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../../../core/utils/json_parser.dart';
import '../../../data/models/form_field_model.dart';
import '../../../data/datasources/local/app_database.dart';

class ChatMessage {
  final String text;
  final bool isBot;
  final String? attachmentPath;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isBot,
    this.attachmentPath,
    required this.timestamp,
  });
}

class ChatController extends GetxController {
  final AppDatabase _db = Get.find<AppDatabase>();

  final messages = <ChatMessage>[].obs;
  final isLoading = true.obs;
  final isTyping = false.obs; // New: For typing indicator

  // Scroll Controller for the UI
  final ScrollController scrollController = ScrollController();

  List<FormFieldModel> _formSteps = [];
  int _currentStepIndex = 0;
  final Map<String, dynamic> _answers = {};

  Rx<FormFieldModel?> currentQuestion = Rx<FormFieldModel?>(null);

  @override
  void onInit() {
    super.onInit();
    _startChatSession();
  }

  // Helper to scroll down
  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _startChatSession() async {
    _formSteps = await JsonParser.loadForm('assets/json/form_template.json');
    if (_formSteps.isNotEmpty) {
      isLoading.value = false;
      _askNextQuestion();
    }
  }

  void _askNextQuestion() async {
    if (_currentStepIndex < _formSteps.length) {
      final step = _formSteps[_currentStepIndex];
      currentQuestion.value = step;

      // Simulate Bot "Thinking"
      isTyping.value = true;
      _scrollToBottom(); // Scroll to show typing indicator

      await Future.delayed(const Duration(seconds: 1));

      isTyping.value = false;
      messages.add(ChatMessage(
        text: step.question,
        isBot: true,
        timestamp: DateTime.now(),
      ));
      _scrollToBottom(); // Scroll to show new question

    } else {
      _completeTicketCreation();
    }
  }

  void handleUserResponse(String response, {String? attachmentPath}) {
    final step = _formSteps[_currentStepIndex];

    // Validation
    if (step.required && response.isEmpty) {
      Get.snackbar("Required", "Please answer the question to proceed.");
      return;
    }

    if (step.validation != null) {
      final regex = RegExp(step.validation!.pattern);
      if (!regex.hasMatch(response)) {
        Get.snackbar("Invalid Input", step.validation!.message);
        return;
      }
    }

    // Add User Answer
    messages.add(ChatMessage(
      text: response,
      isBot: false,
      attachmentPath: attachmentPath,
      timestamp: DateTime.now(),
    ));
    _scrollToBottom();

    _answers[step.id] = response;

    // Clear current question temporarily so input hides while bot thinks
    currentQuestion.value = null;

    _currentStepIndex++;
    _askNextQuestion();
  }

  void _completeTicketCreation() async {
    if (_answers['confirmation'] == 'Yes') {
      final ticket = TicketsCompanion.insert(
        id: const Uuid().v4(),
        title: _answers['title'],
        description: _answers['description'],
        category: _answers['category'],
        priority: _answers['priority'],
        location: _answers['location'],
        reportedBy: _answers['reportedBy'],
        createdAt: DateTime.now(),
        // status:  Value('Open'), // Default status
      );

      await _db.insertTicket(ticket);
      Get.offAllNamed('/ticket_list');
      Get.snackbar("Success", "Ticket Created Successfully");
    } else {
      Get.offAllNamed('/chat'); // Reset or go back
      Get.snackbar("Cancelled", "Ticket creation cancelled");
    }
  }
}