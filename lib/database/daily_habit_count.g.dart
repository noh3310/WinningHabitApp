// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_habit_count.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DailyHabitCountAdapter extends TypeAdapter<DailyHabitCount> {
  @override
  final int typeId = 1;

  @override
  DailyHabitCount read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailyHabitCount(
      id: fields[0] as String,
      habitTypeId: fields[1] as String,
      habitCountDate: fields[2] as DateTime,
      count: fields[3] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, DailyHabitCount obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.habitTypeId)
      ..writeByte(2)
      ..write(obj.habitCountDate)
      ..writeByte(3)
      ..write(obj.count);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyHabitCountAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
