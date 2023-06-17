// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'family_member.model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FamilyMemberModelAdapter extends TypeAdapter<FamilyMemberModel> {
  @override
  final int typeId = 19;

  @override
  FamilyMemberModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FamilyMemberModel(
      familyMemberId: fields[0] as int?,
      intakeAssessmentId: fields[1] as int?,
      personId: fields[2] as int?,
      relationshipTypeId: fields[3] as int?,
      createdBy: fields[4] as int?,
      relationshipTypeModel: fields[5] as RelationshipTypeModel?,
      personModel: fields[6] as PersonModel?,
    );
  }

  @override
  void write(BinaryWriter writer, FamilyMemberModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.familyMemberId)
      ..writeByte(1)
      ..write(obj.intakeAssessmentId)
      ..writeByte(2)
      ..write(obj.personId)
      ..writeByte(3)
      ..write(obj.relationshipTypeId)
      ..writeByte(4)
      ..write(obj.createdBy)
      ..writeByte(5)
      ..write(obj.relationshipTypeModel)
      ..writeByte(6)
      ..write(obj.personModel);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FamilyMemberModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
