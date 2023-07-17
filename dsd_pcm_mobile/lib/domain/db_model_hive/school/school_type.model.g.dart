// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'school_type.model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SchoolTypeModelAdapter extends TypeAdapter<SchoolTypeModel> {
  @override
  final int typeId = 40;

  @override
  SchoolTypeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SchoolTypeModel(
      schoolTypeId: fields[0] as int?,
      description: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SchoolTypeModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.schoolTypeId)
      ..writeByte(1)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SchoolTypeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
