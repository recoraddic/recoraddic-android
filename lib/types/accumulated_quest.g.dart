// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accumulated_quest.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AccumulatedQuestAdapter extends TypeAdapter<AccumulatedQuest> {
  @override
  final int typeId = 2;

  @override
  AccumulatedQuest read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AccumulatedQuest(
      quest: fields[0] as Quest,
      count: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, AccumulatedQuest obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.quest)
      ..writeByte(1)
      ..write(obj.count);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AccumulatedQuestAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
