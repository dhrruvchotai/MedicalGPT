import 'package:hive/hive.dart';

enum MessageRole { user, ai }

enum MessageType { text, image }

@HiveType(typeId: 0)
class ChatMessageModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String role; // 'user' | 'ai'

  @HiveField(2)
  String content;

  @HiveField(3)
  DateTime timestamp;

  @HiveField(4)
  String type; // 'text' | 'image'

  @HiveField(5)
  String? imageUrl;

  ChatMessageModel({
    required this.id,
    required this.role,
    required this.content,
    required this.timestamp,
    this.type = 'text',
    this.imageUrl,
  });

  MessageRole get messageRole =>
      role == 'user' ? MessageRole.user : MessageRole.ai;

  MessageType get messageType =>
      type == 'image' ? MessageType.image : MessageType.text;

  bool get isUser => role == 'user';

  factory ChatMessageModel.user({
    required String id,
    required String content,
    String type = 'text',
    String? imageUrl,
  }) {
    return ChatMessageModel(
      id: id,
      role: 'user',
      content: content,
      timestamp: DateTime.now(),
      type: type,
      imageUrl: imageUrl,
    );
  }

  factory ChatMessageModel.ai({
    required String id,
    required String content,
  }) {
    return ChatMessageModel(
      id: id,
      role: 'ai',
      content: content,
      timestamp: DateTime.now(),
      type: 'text',
    );
  }
}
