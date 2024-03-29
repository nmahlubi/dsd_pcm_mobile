// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'marital_status.model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MaritalStatusModelAdapter extends TypeAdapter<MaritalStatusModel> {
  @override
  final int typeId = 10;

  @override
  MaritalStatusModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MaritalStatusModel(
      maritalStatusId: fields[0] as int?,
      description: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MaritalStatusModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.maritalStatusId)
      ..writeByte(1)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MaritalStatusModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
