// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preferred_contact_type.model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PreferredContactTypeModelAdapter
    extends TypeAdapter<PreferredContactTypeModel> {
  @override
  final int typeId = 12;

  @override
  PreferredContactTypeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PreferredContactTypeModel(
      preferredContactTypeId: fields[0] as int?,
      description: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PreferredContactTypeModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.preferredContactTypeId)
      ..writeByte(1)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PreferredContactTypeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
