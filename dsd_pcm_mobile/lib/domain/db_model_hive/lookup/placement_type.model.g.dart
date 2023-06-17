// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'placement_type.model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlacementTypeModelAdapter extends TypeAdapter<PlacementTypeModel> {
  @override
  final int typeId = 13;

  @override
  PlacementTypeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlacementTypeModel(
      placementTypeId: fields[0] as int?,
      description: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PlacementTypeModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.placementTypeId)
      ..writeByte(1)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlacementTypeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
