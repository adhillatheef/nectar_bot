import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
import '../../../../domain/entities/ticket.dart';
import '../../../../domain/usecases/create_ticket_usecase.dart';
import '../../../routes/app_routes.dart';

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

  // -- INPUT CONTROLLER (Required for ChatInputArea) --
  final TextEditingController textController = TextEditingController();

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
  var tempAttachments = <String>[].obs;
  final List<String> _allSessionAttachments = [];

  @override
  void onInit() {
    super.onInit();
    _startChatSession();
  }

  @override
  void onClose() {
    _audioRecorder.dispose();
    scrollController.dispose();
    textController.dispose(); // Dispose text controller
    super.onClose();
  }

  // --- UI HELPER METHODS (Matches ChatInputArea) ---

  void sendMessage() {
    final text = textController.text.trim();
    if (text.isEmpty) return;
    handleUserResponse(text);
    textController.clear();
  }

  void pickMedia({required bool isCamera}) {
    if (isCamera) {
      pickFromCamera(false);
    } else {
      pickFromGallery();
    }
  }

  // --- 0. NAVIGATION & CONFIRMATION ---

  Future<bool> handleBackPress() async {
    if (_currentStepIndex >= _formSteps.length || _formSteps.isEmpty) {
      return true;
    }

    bool? shouldExit = await Get.dialog<bool>(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: const Color(0xFF1E2224),
        title: const Text("TERMINATE SEQUENCE?", style: TextStyle(color: Colors.white, fontSize: 16)),
        content: const Text("Current draft data will be archived. Resume capability enabled.", style: TextStyle(color: Colors.grey)),
        actions: [
          TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text("CANCEL", style: TextStyle(color: Colors.grey))
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF4C4C)),
            onPressed: () => Get.back(result: true),
            child: const Text("TERMINATE", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    return shouldExit ?? false;
  }

  void resetChat() async {
    bool? confirm = await Get.dialog<bool>(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: const Color(0xFF1E2224),
        title: const Text("REBOOT SYSTEM?", style: TextStyle(color: Colors.white, fontSize: 16)),
        content: const Text("This will purge current session data and restart initialization.", style: TextStyle(color: Colors.grey)),
        actions: [
          TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text("CANCEL", style: TextStyle(color: Colors.grey))
          ),
          TextButton(
              onPressed: () => Get.back(result: true),
              child: const Text("REBOOT", style: TextStyle(color: Color(0xFF00F0FF), fontWeight: FontWeight.bold))
          ),
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

    if (session != null) {
      _sessionId = session.sessionId;
      final savedAnswers = await _db.getAnswersForSession(_sessionId!);

      CustomSnackbar.show(title: "SYSTEM RESTORE", message: "Restoring previous session protocols...");

      for (int i = 0; i < _formSteps.length; i++) {
        final step = _formSteps[i];
        final answerRow = savedAnswers.firstWhereOrNull((a) => a.questionId == step.id);

        if (answerRow != null) {
          _answers[step.id] = answerRow.answer;

          messages.add(ChatMessage(text: step.question, isBot: true, timestamp: DateTime.now()));

          String? attachmentPath;
          String? type;

          if (answerRow.answer.contains('/') && File(answerRow.answer).existsSync()) {
            attachmentPath = answerRow.answer;
            if (attachmentPath.endsWith('.mp4')) type = 'video';
            else if (attachmentPath.endsWith('.m4a')) type = 'audio';
            else type = 'image';
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
      _sessionId = const Uuid().v4();
      await _db.saveSession(_sessionId!, "start");

      messages.add(ChatMessage(
        text: "System initialized. Identity verified.\nHow can I assist with your support ticket today?",
        isBot: true,
        timestamp: DateTime.now(),
      ));
    }

    isLoading.value = false;
    _askNextQuestion();
  }

  // --- 2. CHAT FLOW ---

  void _askNextQuestion() async {
    if (_currentStepIndex < _formSteps.length) {
      final step = _formSteps[_currentStepIndex];
      currentQuestion.value = step;

      isTyping.value = true;
      isInputDisabled.value = true;
      _scrollToBottom();

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
    if (tempAttachments.isNotEmpty) {
      _allSessionAttachments.addAll(tempAttachments);
    }

    if (step.required && response.isEmpty && tempAttachments.isEmpty) {
      CustomSnackbar.show(title: "INPUT REQUIRED", message: "Data field cannot be null.", isError: true);
      return;
    }

    if (step.validation != null && response.isNotEmpty) {
      final regex = RegExp(step.validation!.pattern);
      if (!regex.hasMatch(response)) {
        CustomSnackbar.show(title: "INVALID FORMAT", message: step.validation!.message, isError: true);
        return;
      }
    }

    if (response.isNotEmpty) {
      messages.add(ChatMessage(text: response, isBot: false, timestamp: DateTime.now()));
    }

    _scrollToBottom();

    String valueToSave = response;
    if (valueToSave.isEmpty && tempAttachments.isNotEmpty) {
      valueToSave = tempAttachments.first;
    }

    _answers[step.id] = valueToSave;

    if (_sessionId != null) {
      _db.saveAnswer(FormAnswersCompanion(
        sessionId: drift.Value(_sessionId!),
        questionId: drift.Value(step.id),
        answer: drift.Value(valueToSave),
      ));
      _db.saveSession(_sessionId!, step.id);
    }

    tempAttachments.clear();
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

  Future<void> pickVideo() async {
    final XFile? file = await _picker.pickVideo(source: ImageSource.gallery);
    if (file != null) {
      await _processAndAddAttachment(file, isVideo: true);
    }
  }

  Future<void> _processAndAddAttachment(XFile file, {required bool isVideo}) async {
    final directory = await getApplicationDocumentsDirectory();
    final String fileName = "${DateTime.now().millisecondsSinceEpoch}_${p.basename(file.path)}";
    final String localPath = p.join(directory.path, fileName);

    await File(file.path).copy(localPath);

    tempAttachments.add(localPath);

    messages.add(ChatMessage(
      text: "",
      isBot: false,
      attachmentPath: localPath,
      attachmentType: isVideo ? 'video' : 'image',
      timestamp: DateTime.now(),
    ));
    _scrollToBottom();
  }

  // RENAME: startRecording -> toggleRecording
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
        attachments: List<String>.from(_allSessionAttachments),
      );

      try {
        await _createTicketUseCase(newTicket);
        if (_sessionId != null) await _db.completeSession(_sessionId!);

        CustomSnackbar.show(title: "SUCCESS", message: "Ticket uploaded to nexus protocol.");
        Get.offAllNamed(Routes.TICKET_LIST);

      } catch (e) {
        debugPrint(e.toString());
        isLoading.value = false;
        CustomSnackbar.show(
            title: "SYSTEM ERROR",
            message: "Upload failed: $e",
            isError: true
        );
      }
    } else {
      if (_sessionId != null) await _db.completeSession(_sessionId!);

      messages.clear();
      _answers.clear();
      _allSessionAttachments.clear();
      tempAttachments.clear();
      _currentStepIndex = 0;

      CustomSnackbar.show(
          title: "ABORTED",
          message: "Creation sequence cancelled.",
          isError: true
      );
      _startChatSession();
    }
  }
}