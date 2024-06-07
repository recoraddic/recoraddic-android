// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DailyRecordAdapter extends TypeAdapter<DailyRecord> {
  @override
  final int typeId = 1;

  @override
  DailyRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailyRecord(
      date: fields[0] as DateTime,
      diary: fields[1] as String,
      dailyQuestList_accumulated: (fields[2] as List).cast<DailyQuest>(),
      dailyQuestList_normal: (fields[3] as List).cast<DailyQuest>(),
      facialExpressionIndex: fields[4] as int,
      isSaved: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, DailyRecord obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.diary)
      ..writeByte(2)
      ..write(obj.dailyQuestList_accumulated)
      ..writeByte(3)
      ..write(obj.dailyQuestList_normal)
      ..writeByte(4)
      ..write(obj.facialExpressionIndex)
      ..writeByte(5)
      ..write(obj.isSaved);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
