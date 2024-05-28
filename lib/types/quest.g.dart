// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quest.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QuestAdapter extends TypeAdapter<Quest> {
  @override
  final int typeId = 0;

  @override
  Quest read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Quest(
      quest: fields[0] as String,
      isDone: fields[1] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Quest obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.quest)
      ..writeByte(1)
      ..write(obj.isDone);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuestAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
