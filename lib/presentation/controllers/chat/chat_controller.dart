import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:record/record.dart';
import 'package:drift/drift.dart' as drift;

import '../../../core/utils/json_parser.dart';
import '../../../data/models/form_field_model.dart';
import '../../../data/datasources/local/app_database.dart';

class ChatMessage {
  final String text;
  final bool isBot;
  final String? attachmentPath;
  final String? attachmentType; // 'image', 'video', 'audio'
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

  // -- UI State --
  final messages = <ChatMessage>[].obs;
  final isLoading = true.obs;
  final isTyping = false.obs;
  final ScrollController scrollController = ScrollController();

  // -- Form State --
  List<FormFieldModel> _formSteps = [];
  int _currentStepIndex = 0;
  final Map<String, dynamic> _answers = {};
  Rx<FormFieldModel?> currentQuestion = Rx<FormFieldModel?>(null);
  String? _sessionId; // For Resume Capability

  // -- Attachment State --
  final ImagePicker _picker = ImagePicker();
  final AudioRecorder _audioRecorder = AudioRecorder();
  final isRecording = false.obs;
  List<String> tempAttachments = [];

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

  // --- 1. SESSION MANAGEMENT (RESUME LOGIC) ---

  void _startChatSession() async {
    _formSteps = await JsonParser.loadForm('assets/json/form_template.json');
    if (_formSteps.isEmpty) return;

    // Check for existing incomplete session
    final session = await _db.getLastIncompleteSession();
    final directory = await getApplicationDocumentsDirectory();

    if (session != null) {
      // --- RESUME MODE ---
      _sessionId = session.sessionId;
      final savedAnswers = await _db.getAnswersForSession(_sessionId!);

      // Replay History
      for (int i = 0; i < _formSteps.length; i++) {
        final step = _formSteps[i];

        // Find saved answer
        final answerRow = savedAnswers.firstWhereOrNull((a) => a.questionId == step.id);

        if (answerRow != null) {
          _answers[step.id] = answerRow.answer;

          // Add Bot Question
          messages.add(ChatMessage(text: step.question, isBot: true, timestamp: DateTime.now()));

          // --- ROBUST PATH RECONSTRUCTION ---
          String? attachmentPath;
          String? type;

          // If answer looks like a file path (contains slash)
          if (answerRow.answer.contains('/')) {
            final String fileName = p.basename(answerRow.answer);
            final String freshPath = p.join(directory.path, fileName);

            // We assume it's an attachment if it looks like a path.
            // We pass 'freshPath' to the UI to handle sandbox changes on iOS/Android.
            attachmentPath = freshPath;

            if (fileName.toLowerCase().endsWith('.m4a')) {
              type = 'audio';
            } else if (fileName.toLowerCase().endsWith('.mp4') || fileName.toLowerCase().endsWith('.mov')) {
              type = 'video';
            } else {
              type = 'image';
            }

            // Only add to temp list if it actually exists (prevents crashes during ticket creation)
            if (File(freshPath).existsSync()) {
              tempAttachments.add(freshPath);
            }
          }

          // --- PREVENT EMPTY BUBBLES ---
          // Only add message if there is text OR an attachment
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
          // Stopped here
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

    // Ask Next Question
    if (_currentStepIndex < _formSteps.length) {
      // Small delay if we are resuming to make it feel natural
      Future.delayed(const Duration(milliseconds: 300), () => _askNextQuestion());
    } else {
      _completeTicketCreation();
    }

    Future.delayed(const Duration(milliseconds: 500), () => _scrollToBottom());
  }

  // --- 2. CHAT FLOW ---

  void _askNextQuestion() async {
    if (_currentStepIndex < _formSteps.length) {
      final step = _formSteps[_currentStepIndex];
      currentQuestion.value = step;

      isTyping.value = true;
      _scrollToBottom();

      await Future.delayed(const Duration(milliseconds: 800));

      isTyping.value = false;
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

  void handleUserResponse(String response, {String? attachmentPath, String? type}) {
    final step = _formSteps[_currentStepIndex];
    bool isAttachmentStep = step.id == 'attachments';

    // Validation
    if (step.required && response.isEmpty && !isAttachmentStep) {
      Get.snackbar("Required", "Please answer the question to proceed.");
      return;
    }

    if (step.validation != null && !isAttachmentStep) {
      final regex = RegExp(step.validation!.pattern);
      if (!regex.hasMatch(response)) {
        Get.snackbar("Invalid Input", step.validation!.message);
        return;
      }
    }

    // --- HANDLE UI MESSAGE BUBBLES ---

    // A. Only add user bubble if they actually typed something or attached a file
    if (response.isNotEmpty || attachmentPath != null) {
      messages.add(ChatMessage(
        text: response,
        isBot: false,
        attachmentPath: attachmentPath,
        attachmentType: type,
        timestamp: DateTime.now(),
      ));
      _scrollToBottom();
    }
    // B. Handle the "Done" confirmation for attachments
    else if (isAttachmentStep) {
      // Only say "Uploads complete" if they actually uploaded something
      if (tempAttachments.isNotEmpty) {
        messages.add(ChatMessage(text: "✅ Uploads complete", isBot: false, timestamp: DateTime.now()));
        _scrollToBottom();
      }
      // If tempAttachments is empty, we say nothing (User skipped optional step silently)
    }

    // Determine value to save (Text or File Path)
    String valueToSave = response;
    if (attachmentPath != null) valueToSave = attachmentPath;

    // Update Memory
    _answers[step.id] = valueToSave;

    // SAVE TO SQL (Resume Feature)
    if (_sessionId != null) {
      _db.saveAnswer(FormAnswersCompanion(
        sessionId: drift.Value(_sessionId!),
        questionId: drift.Value(step.id),
        answer: drift.Value(valueToSave),
      ));
      _db.saveSession(_sessionId!, step.id);
    }

    // Advance
    currentQuestion.value = null;
    _currentStepIndex++;

    Future.delayed(const Duration(milliseconds: 200), () => _askNextQuestion());
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
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

  // Gallery (Images & Videos)
  Future<void> pickFromGallery() async {
    try {
      final XFile? file = await _picker.pickMedia();
      if (file != null) {
        await _processAndAddAttachment(file, isVideo: file.path.endsWith('.mp4') || file.path.endsWith('.MOV'));
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to pick file: $e");
    }
  }

  // Camera
  Future<void> pickFromCamera(bool isVideo) async {
    try {
      final XFile? file = isVideo ? await _picker.pickVideo(source: ImageSource.camera) : await _picker.pickImage(source: ImageSource.camera);
      if (file != null) {
        await _processAndAddAttachment(file, isVideo: isVideo);
      }
    } catch (e) {
      Get.snackbar("Error", "Camera error: $e");
    }
  }

  Future<void> _processAndAddAttachment(XFile file, {required bool isVideo}) async {
    final directory = await getApplicationDocumentsDirectory();
    final String fileName = p.basename(file.path);
    final String localPath = p.join(directory.path, fileName);

    // Copy to persistent storage
    await File(file.path).copy(localPath);

    // 1. Add to temp list (for DB later)
    tempAttachments.add(localPath);

    // 2. Show in Chat UI immediately
    messages.add(ChatMessage(
      text: "",
      isBot: false,
      attachmentPath: localPath,
      attachmentType: isVideo ? 'video' : 'image',
      timestamp: DateTime.now(),
    ));
    _scrollToBottom();

    // ⚠️ CRITICAL FIX: Do NOT call handleUserResponse() here.
    // We want the user to be able to add more files.
    // The "Done" button in the ChatInputArea will handle the advance.
  }
  // Audio
  Future<void> toggleRecording() async {
    if (isRecording.value) {
      await _stopRecording();
    } else {
      await _startRecording();
    }
  }

  Future<void> _startRecording() async {
    if (await _audioRecorder.hasPermission()) {
      final directory = await getApplicationDocumentsDirectory();
      final String path = p.join(directory.path, 'audio_${DateTime.now().millisecondsSinceEpoch}.m4a');
      await _audioRecorder.start(const RecordConfig(), path: path);
      isRecording.value = true;
    }
  }

  Future<void> _stopRecording() async {
    final path = await _audioRecorder.stop();
    isRecording.value = false;
    if (path != null) {
      tempAttachments.add(path);
      handleUserResponse("", attachmentPath: path, type: 'audio');
    }
  }

  // --- 4. COMPLETION ---

  void _completeTicketCreation() async {
    if (_answers['confirmation'] == 'Yes') {
      final ticketId = const Uuid().v4();

      final ticket = TicketsCompanion.insert(
        id: ticketId,
        title: _answers['title'] ?? 'No Title',
        description: _answers['description'] ?? 'No Description',
        category: _answers['category'] ?? 'Other',
        priority: _answers['priority'] ?? 'Low',
        location: _answers['location'] ?? 'Unknown',
        reportedBy: _answers['reportedBy'] ?? 'User',
        createdAt: DateTime.now(),
        status: const drift.Value('Open'),
        assetId: drift.Value(_answers['assetId']),
        contactNumber: drift.Value(_answers['contactNumber']),
        email: drift.Value(_answers['email']),
        preferredDate: drift.Value(_answers['preferredDate']),
        preferredTime: drift.Value(_answers['preferredTime']),
        accessRequired: drift.Value(_answers['accessRequired']),
        sla: drift.Value(_answers['sla']),
      );

      await _db.insertTicket(ticket);

      // Link Attachments in DB
      for (String path in tempAttachments) {
        String type = 'image';
        if (path.endsWith('.m4a')) type = 'audio';
        if (path.endsWith('.mp4') || path.endsWith('.MOV')) type = 'video';

        await _db.insertAttachment(TicketAttachmentsCompanion.insert(ticketId: ticketId, filePath: path, fileType: type));
      }

      // Close Session
      if (_sessionId != null) await _db.completeSession(_sessionId!);

      Get.offAllNamed('/ticket_list');
      Get.snackbar("Success", "Ticket Created Successfully");
    } else {

      if (_sessionId != null) {
        await _db.completeSession(_sessionId!);
      }
      messages.clear();
      _answers.clear();
      tempAttachments.clear();
      _currentStepIndex = 0;
      currentQuestion.value = null;
      _startChatSession();
      Get.snackbar("Cancelled", "Ticket creation cancelled. Starting fresh.");
    }
  }
}