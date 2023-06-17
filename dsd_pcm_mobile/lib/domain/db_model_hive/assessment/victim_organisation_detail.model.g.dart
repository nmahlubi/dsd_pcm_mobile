// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'victim_organisation_detail.model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VictimOrganisationDetailModelAdapter
    extends TypeAdapter<VictimOrganisationDetailModel> {
  @override
  final int typeId = 35;

  @override
  VictimOrganisationDetailModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VictimOrganisationDetailModel(
      victimOrganisationId: fields[0] as int?,
      intakeAssessmentId: fields[1] as int?,
      organisationName: fields[2] as String?,
      contactPersonFirstName: fields[3] as String?,
      contactPersonLastName: fields[4] as String?,
      telephone: fields[5] as String?,
      cellNo: fields[6] as String?,
      interventionserviceReferrals: fields[7] as String?,
      otherContacts: fields[8] as String?,
      contactPersonOccupation: fields[9] as String?,
      addressLine1: fields[10] as String?,
      addressLine2: fields[11] as String?,
      townId: fields[12] as int?,
      postalCode: fields[13] as String?,
      createdBy: fields[14] as int?,
      dateCreated: fields[15] as String?,
      modifiedBy: fields[16] as int?,
      dateModified: fields[17] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, VictimOrganisationDetailModel obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.victimOrganisationId)
      ..writeByte(1)
      ..write(obj.intakeAssessmentId)
      ..writeByte(2)
      ..write(obj.organisationName)
      ..writeByte(3)
      ..write(obj.contactPersonFirstName)
      ..writeByte(4)
      ..write(obj.contactPersonLastName)
      ..writeByte(5)
      ..write(obj.telephone)
      ..writeByte(6)
      ..write(obj.cellNo)
      ..writeByte(7)
      ..write(obj.interventionserviceReferrals)
      ..writeByte(8)
      ..write(obj.otherContacts)
      ..writeByte(9)
      ..write(obj.contactPersonOccupation)
      ..writeByte(10)
      ..write(obj.addressLine1)
      ..writeByte(11)
      ..write(obj.addressLine2)
      ..writeByte(12)
      ..write(obj.townId)
      ..writeByte(13)
      ..write(obj.postalCode)
      ..writeByte(14)
      ..write(obj.createdBy)
      ..writeByte(15)
      ..write(obj.dateCreated)
      ..writeByte(16)
      ..write(obj.modifiedBy)
      ..writeByte(17)
      ..write(obj.dateModified);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VictimOrganisationDetailModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
