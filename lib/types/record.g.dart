// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecordAdapter extends TypeAdapter<Record> {
  @override
  final int typeId = 0;

  @override
  Record read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Record(
      date: fields[0] as String,
      diary: fields[1] as String,
      accumulatedQuest: (fields[2] as List).cast<String>(),
      normalQuest: (fields[3] as List).cast<String>(),
      facialExpressionIndex: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Record obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.diary)
      ..writeByte(2)
      ..write(obj.accumulatedQuest)
      ..writeByte(3)
      ..write(obj.normalQuest)
      ..writeByte(4)
      ..write(obj.facialExpressionIndex);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
