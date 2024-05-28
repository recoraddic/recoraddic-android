// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'third_page_content.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ThirdPageContentAdapter extends TypeAdapter<ThirdPageContent> {
  @override
  final int typeId = 2;

  @override
  ThirdPageContent read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ThirdPageContent(
      recordList: (fields[0] as List).cast<Record>(),
      goalList: (fields[1] as List).cast<Goal>(),
      blockColor: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ThirdPageContent obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.recordList)
      ..writeByte(1)
      ..write(obj.goalList)
      ..writeByte(2)
      ..write(obj.blockColor);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ThirdPageContentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
