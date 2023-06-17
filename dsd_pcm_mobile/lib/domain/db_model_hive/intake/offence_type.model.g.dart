// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offence_type.model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OffenceTypeModelAdapter extends TypeAdapter<OffenceTypeModel> {
  @override
  final int typeId = 22;

  @override
  OffenceTypeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OffenceTypeModel(
      offenceTypeId: fields[0] as int?,
      description: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, OffenceTypeModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.offenceTypeId)
      ..writeByte(1)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OffenceTypeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
