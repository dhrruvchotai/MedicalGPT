// GENERATED CODE - DO NOT MODIFY BY HAND
// Manually written adapter (no build_runner needed)

import 'package:hive/hive.dart';
import 'chat_history_model.dart';

class ChatHistoryModelAdapter extends TypeAdapter<ChatHistoryModel> {
  @override
  final int typeId = 1;

  @override
  ChatHistoryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChatHistoryModel(
      id: fields[0] as String,
      title: fields[1] as String,
      messageIds: (fields[2] as List).cast<String>(),
      createdAt: fields[3] as DateTime,
      updatedAt: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ChatHistoryModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.messageIds)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.updatedAt);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatHistoryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;

  @override
  int get hashCode => typeId.hashCode;
}
