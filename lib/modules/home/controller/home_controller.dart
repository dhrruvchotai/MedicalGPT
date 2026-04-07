import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/models/chat_message_model.dart';
import '../../../data/services/chat_service.dart';

class HomeController extends GetxController {
  final ChatService _chatService = Get.find<ChatService>();
  final ImagePicker _picker = ImagePicker();
  final textController = TextEditingController();
  final scrollController = ScrollController();
  final focusNode = FocusNode();

  final RxList<ChatMessageModel> messages = <ChatMessageModel>[].obs;
  final RxBool isTyping = false.obs;
  final RxBool isLoading = false.obs;
  final RxBool isAttachmentOpen = false.obs;
  final RxBool isSending = false.obs;
  final RxBool canSend = false.obs;

  @override
  void onInit() {
    super.onInit();
    _chatService.startNewChat();
  }

  @override
  void onClose() {
    textController.dispose();
    scrollController.dispose();
    focusNode.dispose();
    super.onClose();
  }

  void toggleAttachmentMenu() {
    isAttachmentOpen.value = !isAttachmentOpen.value;
  }

  void closeAttachmentMenu() {
    if (isAttachmentOpen.value) isAttachmentOpen.value = false;
  }

  void startNewChat() {
    messages.clear();
    _chatService.startNewChat();
    textController.clear();
    canSend.value = false;
    isAttachmentOpen.value = false;
  }

  /// Load a previously saved chat by its ID
  void loadChat(String chatId) {
    messages.clear();
    _chatService.resumeChat(chatId);
    final loadedMessages = _chatService.getMessagesForChat(chatId);
    messages.addAll(loadedMessages);
    textController.clear();
    canSend.value = false;
    isAttachmentOpen.value = false;
    _scrollToBottom();
  }

  Future<void> sendMessage() async {
    final text = textController.text.trim();
    if (text.isEmpty || isSending.value) return;

    textController.clear();
    canSend.value = false;
    isSending.value = true;
    isTyping.value = true;
    closeAttachmentMenu();

    // Optimistically add user message
    final userMsg = ChatMessageModel.user(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: text,
    );
    messages.add(userMsg);
    _scrollToBottom();

    try {
      final result = await _chatService.sendTextMessage(text);
      // Replace optimistic user msg with real one and add AI response
      final idx = messages.indexWhere((m) => m.id == userMsg.id);
      if (idx >= 0) messages[idx] = result.first;
      if (result.length > 1) messages.add(result.last);
    } catch (e) {
      messages.add(ChatMessageModel.ai(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: 'Sorry, I encountered an error. Please try again.',
      ));
    } finally {
      isTyping.value = false;
      isSending.value = false;
      _scrollToBottom();
    }
  }

  // ─── Image picking helper ────────────────────────────────────────────────

  Future<File?> _pickImage({ImageSource source = ImageSource.gallery}) async {
    final picked = await _picker.pickImage(source: source);
    if (picked == null) return null;
    return File(picked.path);
  }

  // ─── Skin Lesion Analysis ────────────────────────────────────────────────

  Future<void> analyzeSkinLesion() async {
    closeAttachmentMenu();
    final imageFile = await _pickImage();
    if (imageFile == null) return;

    isLoading.value = true;
    isTyping.value = true;

    final userMsg = ChatMessageModel.user(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: 'Analyze this skin lesion image',
      type: 'image',
      imageUrl: imageFile.path,
    );
    messages.add(userMsg);
    _scrollToBottom();

    try {
      final result = await _chatService.analyzeSkinLesionImage(imageFile);
      final idx = messages.indexWhere((m) => m.id == userMsg.id);
      if (idx >= 0) messages[idx] = result.first;
      if (result.length > 1) messages.add(result.last);
    } catch (e) {
      messages.add(ChatMessageModel.ai(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: _formatUserError(e, 'skin lesion'),
      ));
    } finally {
      isLoading.value = false;
      isTyping.value = false;
      _scrollToBottom();
    }
  }

  // ─── Chest X-Ray Analysis ───────────────────────────────────────────────

  Future<void> analyzeChestXRay() async {
    closeAttachmentMenu();
    final imageFile = await _pickImage();
    if (imageFile == null) return;

    isLoading.value = true;
    isTyping.value = true;

    final userMsg = ChatMessageModel.user(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: 'Analyze this chest X-ray image',
      type: 'image',
      imageUrl: imageFile.path,
    );
    messages.add(userMsg);
    _scrollToBottom();

    try {
      final result = await _chatService.analyzeChestXRayImage(imageFile);
      final idx = messages.indexWhere((m) => m.id == userMsg.id);
      if (idx >= 0) messages[idx] = result.first;
      if (result.length > 1) messages.add(result.last);
    } catch (e) {
      messages.add(ChatMessageModel.ai(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: _formatUserError(e, 'chest X-ray'),
      ));
    } finally {
      isLoading.value = false;
      isTyping.value = false;
      _scrollToBottom();
    }
  }

  // ─── Legacy methods (kept for backward compat) ──────────────────────────

  Future<void> analyzeFromCamera() async {
    closeAttachmentMenu();
    final imageFile = await _pickImage(source: ImageSource.camera);
    if (imageFile == null) return;
    // Default to skin lesion for camera
    isLoading.value = true;
    isTyping.value = true;

    final userMsg = ChatMessageModel.user(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: 'Analyze this skin lesion image',
      type: 'image',
      imageUrl: imageFile.path,
    );
    messages.add(userMsg);
    _scrollToBottom();

    try {
      final result = await _chatService.analyzeSkinLesionImage(imageFile);
      final idx = messages.indexWhere((m) => m.id == userMsg.id);
      if (idx >= 0) messages[idx] = result.first;
      if (result.length > 1) messages.add(result.last);
    } catch (e) {
      messages.add(ChatMessageModel.ai(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: _formatUserError(e, 'skin lesion'),
      ));
    } finally {
      isLoading.value = false;
      isTyping.value = false;
      _scrollToBottom();
    }
  }

  Future<void> pickAndAnalyzeImage() async {
    await analyzeSkinLesion();
  }

  // ─── Utilities ──────────────────────────────────────────────────────────

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

  void onTextChanged(String text) {
    canSend.value = text.trim().isNotEmpty;
  }

  void handleSuggestionTap(String suggestion) {
    textController.text = suggestion.replaceAll(RegExp(r'[🔬💬📄]'), '').trim();
    sendMessage();
  }

  /// Clean up raw error into a user-friendly message
  String _formatUserError(Object error, String analysisType) {
    String raw = error.toString();
    raw = raw.replaceAll(RegExp(r'^Exception:\s*', caseSensitive: false), '');
    raw = raw.replaceAll(
        RegExp(r'^Unexpected error:\s*', caseSensitive: false), '');
    raw = raw.trim();

    if (raw.isNotEmpty) {
      raw = raw[0].toUpperCase() + raw.substring(1);
    }
    if (raw.isNotEmpty && !raw.endsWith('.') && !raw.endsWith('!')) {
      raw = '$raw.';
    }

    return 'Unable to complete $analysisType analysis.\n\n'
        'Reason: $raw\n\n'
        'Please make sure you\'re uploading the correct type of medical image and try again.';
  }
}
