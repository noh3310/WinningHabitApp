// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HabitDataAdapter extends TypeAdapter<HabitData> {
  @override
  final int typeId = 0;

  @override
  HabitData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HabitData(
      id: fields[0] as String?,
      name: fields[1] as String,
      generateDate: fields[2] as DateTime,
      targetCount: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, HabitData obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.generateDate)
      ..writeByte(3)
      ..write(obj.targetCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HabitDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
