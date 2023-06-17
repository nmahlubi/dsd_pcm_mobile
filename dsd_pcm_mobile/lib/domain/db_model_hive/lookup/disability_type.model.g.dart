// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'disability_type.model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DisabilityTypeModelAdapter extends TypeAdapter<DisabilityTypeModel> {
  @override
  final int typeId = 7;

  @override
  DisabilityTypeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DisabilityTypeModel(
      disabilityTypeId: fields[0] as int?,
      typeName: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, DisabilityTypeModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.disabilityTypeId)
      ..writeByte(1)
      ..write(obj.typeName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DisabilityTypeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
