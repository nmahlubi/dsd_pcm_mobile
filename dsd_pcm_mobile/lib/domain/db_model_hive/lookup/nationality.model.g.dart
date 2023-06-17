// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nationality.model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NationalityModelAdapter extends TypeAdapter<NationalityModel> {
  @override
  final int typeId = 9;

  @override
  NationalityModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NationalityModel(
      nationalityId: fields[0] as int?,
      description: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, NationalityModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.nationalityId)
      ..writeByte(1)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NationalityModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
