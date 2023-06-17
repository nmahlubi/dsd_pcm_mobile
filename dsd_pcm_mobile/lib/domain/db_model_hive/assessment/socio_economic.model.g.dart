// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'socio_economic.model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SocioEconomicModelAdapter extends TypeAdapter<SocioEconomicModel> {
  @override
  final int typeId = 21;

  @override
  SocioEconomicModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SocioEconomicModel(
      socioEconomyid: fields[0] as int?,
      intakeAssessmentId: fields[1] as int?,
      familyBackgroundComment: fields[2] as String?,
      financeWorkRecord: fields[3] as String?,
      housing: fields[4] as String?,
      socialCircumsances: fields[5] as String?,
      previousIntervention: fields[6] as String?,
      interPersonalRelationship: fields[7] as String?,
      peerPresure: fields[8] as String?,
      substanceAbuse: fields[9] as String?,
      religiousInvolve: fields[10] as String?,
      childBehavior: fields[11] as String?,
      other: fields[12] as String?,
      createdBy: fields[13] as int?,
      dateCreated: fields[14] as String?,
      modifiedBy: fields[15] as int?,
      dateModified: fields[16] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SocioEconomicModel obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.socioEconomyid)
      ..writeByte(1)
      ..write(obj.intakeAssessmentId)
      ..writeByte(2)
      ..write(obj.familyBackgroundComment)
      ..writeByte(3)
      ..write(obj.financeWorkRecord)
      ..writeByte(4)
      ..write(obj.housing)
      ..writeByte(5)
      ..write(obj.socialCircumsances)
      ..writeByte(6)
      ..write(obj.previousIntervention)
      ..writeByte(7)
      ..write(obj.interPersonalRelationship)
      ..writeByte(8)
      ..write(obj.peerPresure)
      ..writeByte(9)
      ..write(obj.substanceAbuse)
      ..writeByte(10)
      ..write(obj.religiousInvolve)
      ..writeByte(11)
      ..write(obj.childBehavior)
      ..writeByte(12)
      ..write(obj.other)
      ..writeByte(13)
      ..write(obj.createdBy)
      ..writeByte(14)
      ..write(obj.dateCreated)
      ..writeByte(15)
      ..write(obj.modifiedBy)
      ..writeByte(16)
      ..write(obj.dateModified);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SocioEconomicModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
