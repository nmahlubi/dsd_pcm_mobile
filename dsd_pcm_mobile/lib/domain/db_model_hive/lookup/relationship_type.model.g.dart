// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'relationship_type.model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RelationshipTypeModelAdapter extends TypeAdapter<RelationshipTypeModel> {
  @override
  final int typeId = 5;

  @override
  RelationshipTypeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RelationshipTypeModel(
      relationshipTypeId: fields[0] as int?,
      description: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, RelationshipTypeModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.relationshipTypeId)
      ..writeByte(1)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RelationshipTypeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
