// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offence_schedule.model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OffenceScheduleModelAdapter extends TypeAdapter<OffenceScheduleModel> {
  @override
  final int typeId = 24;

  @override
  OffenceScheduleModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OffenceScheduleModel(
      offenceScheduleId: fields[0] as int?,
      description: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, OffenceScheduleModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.offenceScheduleId)
      ..writeByte(1)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OffenceScheduleModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
