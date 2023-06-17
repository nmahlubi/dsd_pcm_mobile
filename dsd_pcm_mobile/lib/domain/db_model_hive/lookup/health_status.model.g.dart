// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_status.model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HealthStatusModelAdapter extends TypeAdapter<HealthStatusModel> {
  @override
  final int typeId = 6;

  @override
  HealthStatusModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HealthStatusModel(
      healthStatusId: fields[0] as int?,
      description: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, HealthStatusModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.healthStatusId)
      ..writeByte(1)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HealthStatusModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
