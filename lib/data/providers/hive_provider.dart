import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import '../models/chat_message_model.dart';
import '../models/chat_message_model.g.dart';
import '../models/chat_history_model.dart';
import '../models/chat_history_model.g.dart';

class HiveProvider {
  static const String _messagesBox = 'messages';
  static const String _historyBox = 'chat_history';

  static Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(dir.path);

    // Register adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ChatMessageModelAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(ChatHistoryModelAdapter());
    }

    // Open boxes
    await Hive.openBox<ChatMessageModel>(_messagesBox);
    await Hive.openBox<ChatHistoryModel>(_historyBox);
  }

  static Box<ChatMessageModel> get messagesBox =>
      Hive.box<ChatMessageModel>(_messagesBox);

  static Box<ChatHistoryModel> get historyBox =>
      Hive.box<ChatHistoryModel>(_historyBox);

  // Messages CRUD
  static Future<void> saveMessage(ChatMessageModel message) async {
    await messagesBox.put(message.id, message);
  }

  static ChatMessageModel? getMessage(String id) => messagesBox.get(id);

  static List<ChatMessageModel> getMessages(List<String> ids) {
    return ids
        .map((id) => messagesBox.get(id))
        .whereType<ChatMessageModel>()
        .toList();
  }

  // History CRUD
  static Future<void> saveHistory(ChatHistoryModel history) async {
    await historyBox.put(history.id, history);
  }

  static List<ChatHistoryModel> getAllHistory() {
    final list = historyBox.values.toList();
    list.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return list.take(10).toList();
  }

  static Future<void> deleteHistory(String id) async {
    await historyBox.delete(id);
  }

  static Future<void> clearAll() async {
    await messagesBox.clear();
    await historyBox.clear();
  }
}
