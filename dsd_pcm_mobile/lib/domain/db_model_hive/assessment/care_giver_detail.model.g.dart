// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'care_giver_detail.model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CareGiverDetailModelAdapter extends TypeAdapter<CareGiverDetailModel> {
  @override
  final int typeId = 25;

  @override
  CareGiverDetailModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CareGiverDetailModel(
      clientCaregiverId: fields[0] as int?,
      clientId: fields[1] as int?,
      relationshipTypeId: fields[2] as int?,
      personId: fields[3] as int?,
      createdBy: fields[4] as String?,
      dateCreated: fields[5] as String?,
      modifiedBy: fields[6] as String?,
      dateModified: fields[7] as String?,
      relationshipTypeModel: fields[8] as RelationshipTypeModel?,
      personModel: fields[9] as PersonModel?,
    );
  }

  @override
  void write(BinaryWriter writer, CareGiverDetailModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.clientCaregiverId)
      ..writeByte(1)
      ..write(obj.clientId)
      ..writeByte(2)
      ..write(obj.relationshipTypeId)
      ..writeByte(3)
      ..write(obj.personId)
      ..writeByte(4)
      ..write(obj.createdBy)
      ..writeByte(5)
      ..write(obj.dateCreated)
      ..writeByte(6)
      ..write(obj.modifiedBy)
      ..writeByte(7)
      ..write(obj.dateModified)
      ..writeByte(8)
      ..write(obj.relationshipTypeModel)
      ..writeByte(9)
      ..write(obj.personModel);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CareGiverDetailModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
