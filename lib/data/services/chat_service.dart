import 'dart:io';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../models/chat_message_model.dart';
import '../models/chat_history_model.dart';
import '../providers/hive_provider.dart';
import '../services/api_service.dart';
import '../services/biomistral_service.dart';
import '../../core/utils/formatters.dart';

class ChatService extends GetxService {
  final ApiService _apiService = Get.find<ApiService>();
  final BioMistralService _bioMistralService = Get.find<BioMistralService>();
  final _uuid = const Uuid();

  String? _currentChatId;

  /// Start or continue a chat session
  void startNewChat() {
    _currentChatId = _uuid.v4();
  }

  /// Resume an existing chat session by its ID
  void resumeChat(String chatId) {
    _currentChatId = chatId;
  }

  String get currentChatId {
    _currentChatId ??= _uuid.v4();
    return _currentChatId!;
  }

  /// Send a text message and get AI response from BioMistral-7B
  Future<List<ChatMessageModel>> sendTextMessage(String text) async {
    final userMsg = ChatMessageModel.user(
      id: _uuid.v4(),
      content: text,
    );
    await HiveProvider.saveMessage(userMsg);

    // Call BioMistral-7B via HuggingFace Inference API
    String aiResponse;
    try {
      aiResponse = await _bioMistralService.askMedicalQuery(text);
    } catch (e) {
      aiResponse = 'Sorry, I encountered an error while processing your '
          'request. Please try again later.';
    }

    final aiMsg = ChatMessageModel.ai(
      id: _uuid.v4(),
      content: aiResponse,
    );
    await HiveProvider.saveMessage(aiMsg);

    await _updateOrCreateHistory(userMsg.id, aiMsg.id, text);
    return [userMsg, aiMsg];
  }

  /// Analyze a skin lesion image
  Future<List<ChatMessageModel>> analyzeSkinLesionImage(File imageFile) async {
    final userMsg = ChatMessageModel.user(
      id: _uuid.v4(),
      content: 'Analyze this skin lesion image',
      type: 'image',
      imageUrl: imageFile.path,
    );
    await HiveProvider.saveMessage(userMsg);

    ChatMessageModel aiMsg;
    try {
      final result = await _apiService.predictSkinLesion(imageFile);
      if (result != null) {
        final content = '''Skin Lesion Analysis Result

Prediction: ${result.prediction}
Confidence: ${result.confidencePercent}

Top Probabilities:
${_formatDiseaseEntries(result.allClasses, topN: 3)}

Note: This is an AI-assisted analysis and should NOT replace professional dermatological examination. Please consult a licensed dermatologist for a proper diagnosis.''';

        aiMsg = ChatMessageModel.ai(id: _uuid.v4(), content: content);
      } else {
        aiMsg = ChatMessageModel.ai(
          id: _uuid.v4(),
          content:
              'I was unable to analyze the image. Please try again with a clearer photo.',
        );
      }
    } catch (e) {
      aiMsg = ChatMessageModel.ai(
        id: _uuid.v4(),
        content: _formatErrorMessage(e, 'skin lesion'),
      );
    }

    await HiveProvider.saveMessage(aiMsg);
    await _updateOrCreateHistory(
      userMsg.id,
      aiMsg.id,
      'Skin lesion image analysis',
    );
    return [userMsg, aiMsg];
  }

  /// Analyze a chest X-ray image
  Future<List<ChatMessageModel>> analyzeChestXRayImage(File imageFile) async {
    final userMsg = ChatMessageModel.user(
      id: _uuid.v4(),
      content: 'Analyze this chest X-ray image',
      type: 'image',
      imageUrl: imageFile.path,
    );
    await HiveProvider.saveMessage(userMsg);

    ChatMessageModel aiMsg;
    try {
      final result = await _apiService.predictChestXRay(imageFile);
      if (result != null) {
        final detectedSection = result.detectedDiseases.isNotEmpty
            ? 'Detected Diseases:\n${_formatDiseaseEntries(result.detectedDiseases)}'
            : 'No significant diseases detected above threshold.';

        final content = '''Chest X-Ray Analysis Result

$detectedSection

All Class Probabilities:
${_formatDiseaseEntries(result.allClasses)}

Note: This is an AI-assisted analysis and should NOT replace professional radiological examination. Please consult a licensed physician for a proper diagnosis.''';

        aiMsg = ChatMessageModel.ai(id: _uuid.v4(), content: content);
      } else {
        aiMsg = ChatMessageModel.ai(
          id: _uuid.v4(),
          content:
              'I was unable to analyze the X-ray image. Please try again with a clearer photo.',
        );
      }
    } catch (e) {
      aiMsg = ChatMessageModel.ai(
        id: _uuid.v4(),
        content: _formatErrorMessage(e, 'chest X-ray'),
      );
    }

    await HiveProvider.saveMessage(aiMsg);
    await _updateOrCreateHistory(
      userMsg.id,
      aiMsg.id,
      'Chest X-ray image analysis',
    );
    return [userMsg, aiMsg];
  }

  /// Format a list of DiseaseEntry items for display
  String _formatDiseaseEntries(List<DiseaseEntry> entries, {int? topN}) {
    final sorted = List<DiseaseEntry>.from(entries)
      ..sort((a, b) => b.confidence.compareTo(a.confidence));
    final items = topN != null ? sorted.take(topN) : sorted;
    return items
        .map((e) => '• ${e.label}: ${e.confidencePercent}')
        .join('\n');
  }

  /// Clean up raw error into a user-friendly message
  String _formatErrorMessage(Object error, String analysisType) {
    String raw = error.toString();

    // Strip common technical prefixes
    raw = raw.replaceAll(RegExp(r'^Exception:\s*', caseSensitive: false), '');
    raw = raw.replaceAll(
        RegExp(r'^Unexpected error:\s*', caseSensitive: false), '');
    raw = raw.trim();

    // Capitalize first letter
    if (raw.isNotEmpty) {
      raw = raw[0].toUpperCase() + raw.substring(1);
    }

    // Add period at end if missing
    if (raw.isNotEmpty && !raw.endsWith('.') && !raw.endsWith('!')) {
      raw = '$raw.';
    }

    return 'Unable to complete $analysisType analysis.\n\n'
        'Reason: $raw\n\n'
        'Please make sure you\'re uploading the correct type of medical image and try again.';
  }

  Future<void> _updateOrCreateHistory(
    String userMsgId,
    String aiMsgId,
    String firstMessage,
  ) async {
    final id = currentChatId;
    final existing = HiveProvider.historyBox.get(id);
    if (existing != null) {
      existing.messageIds.addAll([userMsgId, aiMsgId]);
      existing.updatedAt = DateTime.now();
      await HiveProvider.saveHistory(existing);
    } else {
      await HiveProvider.saveHistory(
        ChatHistoryModel(
          id: id,
          title: Formatters.formatChatTitle(firstMessage),
          messageIds: [userMsgId, aiMsgId],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );
    }
  }

  List<ChatHistoryModel> getChatHistory() => HiveProvider.getAllHistory();

  List<ChatMessageModel> getMessagesForChat(String chatId) {
    final history = HiveProvider.historyBox.get(chatId);
    if (history == null) return [];
    return HiveProvider.getMessages(history.messageIds);
  }

  Future<void> deleteChat(String chatId) async {
    await HiveProvider.deleteHistory(chatId);
  }
}
