// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'victim_detail.model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VictimDetailModelAdapter extends TypeAdapter<VictimDetailModel> {
  @override
  final int typeId = 36;

  @override
  VictimDetailModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VictimDetailModel(
      victimId: fields[0] as int?,
      intakeAssessmentId: fields[1] as int?,
      isVictimIndividual: fields[2] as String?,
      personId: fields[3] as int?,
      victimOccupation: fields[4] as String?,
      victimCareGiverNames: fields[5] as String?,
      addressLine1: fields[6] as String?,
      addressLine2: fields[7] as String?,
      townId: fields[8] as int?,
      postalCode: fields[9] as String?,
      createdBy: fields[10] as int?,
      dateCreated: fields[11] as String?,
      modifiedBy: fields[12] as int?,
      dateModified: fields[13] as String?,
      personModel: fields[14] as PersonModel?,
    );
  }

  @override
  void write(BinaryWriter writer, VictimDetailModel obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.victimId)
      ..writeByte(1)
      ..write(obj.intakeAssessmentId)
      ..writeByte(2)
      ..write(obj.isVictimIndividual)
      ..writeByte(3)
      ..write(obj.personId)
      ..writeByte(4)
      ..write(obj.victimOccupation)
      ..writeByte(5)
      ..write(obj.victimCareGiverNames)
      ..writeByte(6)
      ..write(obj.addressLine1)
      ..writeByte(7)
      ..write(obj.addressLine2)
      ..writeByte(8)
      ..write(obj.townId)
      ..writeByte(9)
      ..write(obj.postalCode)
      ..writeByte(10)
      ..write(obj.createdBy)
      ..writeByte(11)
      ..write(obj.dateCreated)
      ..writeByte(12)
      ..write(obj.modifiedBy)
      ..writeByte(13)
      ..write(obj.dateModified)
      ..writeByte(14)
      ..write(obj.personModel);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VictimDetailModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
