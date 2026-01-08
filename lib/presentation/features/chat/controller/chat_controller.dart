import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nectar_bot/domain/entities/ticket.dart';
import 'package:nectar_bot/presentation/routes/app_routes.dart';
import 'package:uuid/uuid.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:record/record.dart';
import 'package:drift/drift.dart' as drift;

import '../../../../core/utils/json_parser.dart';
import '../../../../core/utils/custom_snackbar.dart';
import '../../../../data/models/form_field_model.dart';
import '../../../../data/datasources/local/app_database.dart' hide Ticket;
import '../../../../domain/usecases/create_ticket_usecase.dart';


class ChatMessage {
  final String text;
  final bool isBot;
  final String? attachmentPath;
  final String? attachmentType;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isBot,
    this.attachmentPath,
    this.attachmentType,
    required this.timestamp,
  });
}

class ChatController extends GetxController {
  final AppDatabase _db = Get.find<AppDatabase>();
  final CreateTicketUseCase _createTicketUseCase = Get.find<CreateTicketUseCase>();
  // -- UI State --
  final messages = <ChatMessage>[].obs;
  final isLoading = true.obs;
  final isTyping = false.obs;
  final isInputDisabled = false.obs;
  final ScrollController scrollController = ScrollController();

  // -- Form State --
  List<FormFieldModel> _formSteps = [];
  int _currentStepIndex = 0;
  final Map<String, dynamic> _answers = {};
  Rx<FormFieldModel?> currentQuestion = Rx<FormFieldModel?>(null);
  String? _sessionId;

  // -- Attachment State --
  final ImagePicker _picker = ImagePicker();
  final AudioRecorder _audioRecorder = AudioRecorder();
  final isRecording = false.obs;

  // We keep track of temp attachments for the CURRENT step only
  var tempAttachments = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    _startChatSession();
  }

  @override
  void onClose() {
    _audioRecorder.dispose();
    scrollController.dispose();
    super.onClose();
  }

  // --- 0. NAVIGATION & CONFIRMATION ---

  Future<bool> handleBackPress() async {
    // If ticket is created or session not started, just go back
    if (_currentStepIndex >= _formSteps.length || _formSteps.isEmpty) {
      return true;
    }

    // Otherwise, ask for confirmation
    bool? shouldExit = await Get.dialog<bool>(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Exit Ticket Creation?"),
        content: const Text("Your progress is saved draft. You can resume later."),
        actions: [
          TextButton(onPressed: () => Get.back(result: false), child: const Text("Stay")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Get.back(result: true),
            child: const Text("Exit"),
          ),
        ],
      ),
    );
    return shouldExit ?? false;
  }

  void resetChat() async {
    bool? confirm = await Get.dialog<bool>(
      AlertDialog(
        title: const Text("Restart Session?"),
        content: const Text("This will clear your current answers and start fresh."),
        actions: [
          TextButton(onPressed: () => Get.back(result: false), child: const Text("Cancel")),
          TextButton(onPressed: () => Get.back(result: true), child: const Text("Restart")),
        ],
      ),
    );

    if (confirm == true) {
      if (_sessionId != null) {
        await _db.completeSession(_sessionId!);
      }
      messages.clear();
      _answers.clear();
      tempAttachments.clear();
      _currentStepIndex = 0;
      currentQuestion.value = null;
      _startChatSession();
    }
  }

  // --- 1. SESSION MANAGEMENT ---

  void _startChatSession() async {
    isLoading.value = true;
    _formSteps = await JsonParser.loadForm('assets/json/form_template.json');

    if (_formSteps.isEmpty) {
      isLoading.value = false;
      return;
    }

    final session = await _db.getLastIncompleteSession();
    final directory = await getApplicationDocumentsDirectory();

    if (session != null) {
      // --- RESUME ---
      _sessionId = session.sessionId;
      final savedAnswers = await _db.getAnswersForSession(_sessionId!);

      CustomSnackbar.show(title: "Welcome Back", message: "Resuming your previous session...");

      // Replay History
      for (int i = 0; i < _formSteps.length; i++) {
        final step = _formSteps[i];
        final answerRow = savedAnswers.firstWhereOrNull((a) => a.questionId == step.id);

        if (answerRow != null) {
          _answers[step.id] = answerRow.answer;

          // Reconstruct Chat History
          messages.add(ChatMessage(text: step.question, isBot: true, timestamp: DateTime.now()));

          String? attachmentPath;
          String? type;

          // Check if answer is a file path
          if (answerRow.answer.contains('/') && File(answerRow.answer).existsSync()) {
            // It's a valid local path (simplified for demo)
            attachmentPath = answerRow.answer;
            if (attachmentPath.endsWith('.mp4'))
              type = 'video';
            else if (attachmentPath.endsWith('.m4a'))
              type = 'audio';
            else
              type = 'image';
          }

          if (attachmentPath != null || answerRow.answer.isNotEmpty) {
            messages.add(ChatMessage(
              text: attachmentPath != null ? "" : answerRow.answer,
              isBot: false,
              attachmentPath: attachmentPath,
              attachmentType: type,
              timestamp: DateTime.now(),
            ));
          }
          _currentStepIndex = i + 1;
        } else {
          _currentStepIndex = i;
          break;
        }
      }
    } else {
      // --- FRESH START ---
      _sessionId = const Uuid().v4();
      await _db.saveSession(_sessionId!, "start");
    }

    isLoading.value = false;
    _askNextQuestion();
  }

  // --- 2. CHAT FLOW ---

  void _askNextQuestion() async {
    if (_currentStepIndex < _formSteps.length) {
      final step = _formSteps[_currentStepIndex];
      currentQuestion.value = step;
      tempAttachments.clear(); // Clear temp attachments for the new question

      isTyping.value = true;
      isInputDisabled.value = true; // Disable input while bot "types"
      _scrollToBottom();

      // Simulate network/bot delay
      await Future.delayed(const Duration(milliseconds: 1000));

      isTyping.value = false;
      isInputDisabled.value = false;

      messages.add(ChatMessage(
        text: step.question,
        isBot: true,
        timestamp: DateTime.now(),
      ));
      _scrollToBottom();
    } else {
      _completeTicketCreation();
    }
  }

  void handleUserResponse(String response) {
    if (isInputDisabled.value) return;

    final step = _formSteps[_currentStepIndex];
    bool isAttachmentStep = step.id == 'attachments';

    // Validation
    if (step.required && response.isEmpty && tempAttachments.isEmpty) {
      CustomSnackbar.show(title: "Required", message: "This field is required.", isError: true);
      return;
    }

    if (step.validation != null && response.isNotEmpty) {
      final regex = RegExp(step.validation!.pattern);
      if (!regex.hasMatch(response)) {
        CustomSnackbar.show(title: "Invalid Input", message: step.validation!.message, isError: true);
        return;
      }
    }

    // --- Add User Message ---
    // If it's text, add text bubble.
    // If it's attachment step, attachments are already added visually via _processAndAddAttachment.
    // We just need a confirmation message if they pressed "Done" without typing text.

    if (response.isNotEmpty) {
      messages.add(ChatMessage(text: response, isBot: false, timestamp: DateTime.now()));
    } else if (tempAttachments.isNotEmpty && isAttachmentStep) {
      // Optional: Add a "Finished uploading" system note or just proceed
    } else if (!step.required && response.isEmpty && tempAttachments.isEmpty) {
      // Skipped
    }

    _scrollToBottom();

    // --- Save Data ---
    // If attachments exist, we save the FIRST one as the primary answer for now,
    // or join them. For this SQL schema, we'll save the text or the first path.
    // Ideally, attachments are saved in a separate table linked to session,
    // but here we follow the prompt's flow.

    String valueToSave = response;
    if (valueToSave.isEmpty && tempAttachments.isNotEmpty) {
      valueToSave = tempAttachments.first; // Save reference to first file
    }

    _answers[step.id] = valueToSave;

    // Save to DB
    if (_sessionId != null) {
      _db.saveAnswer(FormAnswersCompanion(
        sessionId: drift.Value(_sessionId!),
        questionId: drift.Value(step.id),
        answer: drift.Value(valueToSave),
      ));
      _db.saveSession(_sessionId!, step.id);
    }

    // Advance
    _currentStepIndex++;
    currentQuestion.value = null;
    _askNextQuestion();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // --- 3. ATTACHMENT LOGIC ---

  Future<void> pickFromGallery() async {
    final XFile? file = await _picker.pickMedia();
    if (file != null) {
      await _processAndAddAttachment(file, isVideo: file.path.toLowerCase().endsWith('.mp4'));
    }
  }

  Future<void> pickFromCamera(bool isVideo) async {
    final XFile? file = isVideo ? await _picker.pickVideo(source: ImageSource.camera) : await _picker.pickImage(source: ImageSource.camera);
    if (file != null) {
      await _processAndAddAttachment(file, isVideo: isVideo);
    }
  }

  Future<void> _processAndAddAttachment(XFile file, {required bool isVideo}) async {
    final directory = await getApplicationDocumentsDirectory();
    final String fileName = "${DateTime.now().millisecondsSinceEpoch}_${p.basename(file.path)}";
    final String localPath = p.join(directory.path, fileName);

    await File(file.path).copy(localPath);

    tempAttachments.add(localPath);

    // Show bubble immediately
    messages.add(ChatMessage(
      text: "",
      isBot: false,
      attachmentPath: localPath,
      attachmentType: isVideo ? 'video' : 'image',
      timestamp: DateTime.now(),
    ));
    _scrollToBottom();
  }

  Future<void> toggleRecording() async {
    if (isRecording.value) {
      final path = await _audioRecorder.stop();
      isRecording.value = false;
      if (path != null) {
        tempAttachments.add(path);
        messages.add(ChatMessage(
          text: "",
          isBot: false,
          attachmentPath: path,
          attachmentType: 'audio',
          timestamp: DateTime.now(),
        ));
        _scrollToBottom();
      }
    } else {
      if (await _audioRecorder.hasPermission()) {
        final directory = await getApplicationDocumentsDirectory();
        final String path = p.join(directory.path, 'audio_${DateTime.now().millisecondsSinceEpoch}.m4a');
        await _audioRecorder.start(const RecordConfig(), path: path);
        isRecording.value = true;
      }
    }
  }

  // --- 4. COMPLETION ---

  void _completeTicketCreation() async {
    if (_answers['confirmation'] == 'Yes') {
      isLoading.value = true;
      final ticketId = const Uuid().v4();

      // Create the Domain Entity
      final newTicket = Ticket(
        id: ticketId,
        title: _answers['title'] ?? 'No Title',
        description: _answers['description'] ?? 'No Description',
        category: _answers['category'] ?? 'Other',
        priority: _answers['priority'] ?? 'Low',
        location: _answers['location'] ?? 'Unknown',
        reportedBy: _answers['reportedBy'] ?? 'User',
        createdAt: DateTime.now(),
        status: 'Open',
        assetId: _answers['assetId'],
        contactNumber: _answers['contactNumber'],
        email: _answers['email'],
        preferredDate: _answers['preferredDate'],
        preferredTime: _answers['preferredTime'],
        accessRequired: _answers['accessRequired'],
        sla: _answers['sla'],

        // ---------------------------------------------------------
        // PASS ATTACHMENTS HERE
        // We create a copy of the list to ensure data integrity
        // ---------------------------------------------------------
        attachments: List<String>.from(tempAttachments),
      );

      try {
        // CALL USE CASE
        await _createTicketUseCase(newTicket);

        // CLEAN UP SESSION (DB)
        if (_sessionId != null) await _db.completeSession(_sessionId!);

        // SUCCESS UI
        CustomSnackbar.show(title: "Success", message: "Ticket created successfully!");
        Get.offAllNamed(Routes.TICKET_LIST);

      } catch (e) {
        isLoading.value = false;
        CustomSnackbar.show(
            title: "Error",
            message: "Failed to create ticket: $e",
            isError: true
        );
      }
    } else {
      // User said NO - Cancel Logic
      if (_sessionId != null) await _db.completeSession(_sessionId!);

      messages.clear();
      _answers.clear();
      tempAttachments.clear();
      _currentStepIndex = 0;

      CustomSnackbar.show(
          title: "Cancelled",
          message: "Ticket creation cancelled.",
          isError: true
      );
      _startChatSession(); // Restart
    }
  }
}
