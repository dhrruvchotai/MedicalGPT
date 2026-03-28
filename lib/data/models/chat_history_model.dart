import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class ChatHistoryModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  List<String> messageIds; // Store message IDs, messages in separate box

  @HiveField(3)
  DateTime createdAt;

  @HiveField(4)
  DateTime updatedAt;

  ChatHistoryModel({
    required this.id,
    required this.title,
    required this.messageIds,
    required this.createdAt,
    required this.updatedAt,
  });
}
