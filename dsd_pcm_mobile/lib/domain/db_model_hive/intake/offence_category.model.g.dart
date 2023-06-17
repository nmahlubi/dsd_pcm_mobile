// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offence_category.model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OffenceCategoryModelAdapter extends TypeAdapter<OffenceCategoryModel> {
  @override
  final int typeId = 23;

  @override
  OffenceCategoryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OffenceCategoryModel(
      offenceCategoryId: fields[0] as int?,
      description: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, OffenceCategoryModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.offenceCategoryId)
      ..writeByte(1)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OffenceCategoryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
