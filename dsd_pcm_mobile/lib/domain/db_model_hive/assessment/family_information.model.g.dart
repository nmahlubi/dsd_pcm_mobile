// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'family_information.model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FamilyInformationModelAdapter
    extends TypeAdapter<FamilyInformationModel> {
  @override
  final int typeId = 18;

  @override
  FamilyInformationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FamilyInformationModel(
      familyInformationId: fields[0] as int?,
      intakeAssessmentId: fields[1] as int?,
      familyBackground: fields[2] as String?,
      createdBy: fields[3] as int?,
      dateCreated: fields[4] as String?,
      modifiedBy: fields[5] as int?,
      dateModified: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, FamilyInformationModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.familyInformationId)
      ..writeByte(1)
      ..write(obj.intakeAssessmentId)
      ..writeByte(2)
      ..write(obj.familyBackground)
      ..writeByte(3)
      ..write(obj.createdBy)
      ..writeByte(4)
      ..write(obj.dateCreated)
      ..writeByte(5)
      ..write(obj.modifiedBy)
      ..writeByte(6)
      ..write(obj.dateModified);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FamilyInformationModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
