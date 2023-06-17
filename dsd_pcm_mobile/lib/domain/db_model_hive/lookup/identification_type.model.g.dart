// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'identification_type.model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class IdentificationTypeModelAdapter
    extends TypeAdapter<IdentificationTypeModel> {
  @override
  final int typeId = 11;

  @override
  IdentificationTypeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return IdentificationTypeModel(
      identificationTypeId: fields[0] as int?,
      description: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, IdentificationTypeModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.identificationTypeId)
      ..writeByte(1)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IdentificationTypeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
