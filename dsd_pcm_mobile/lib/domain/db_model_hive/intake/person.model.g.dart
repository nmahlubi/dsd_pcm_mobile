// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person.model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PersonModelAdapter extends TypeAdapter<PersonModel> {
  @override
  final int typeId = 16;

  @override
  PersonModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PersonModel(
      personId: fields[0] as int?,
      firstName: fields[1] as String?,
      lastName: fields[2] as String?,
      knownAs: fields[3] as String?,
      identificationTypeId: fields[4] as int?,
      identificationNumber: fields[5] as String?,
      isPivaValidated: fields[6] as bool?,
      pivaTransactionId: fields[7] as String?,
      dateOfBirth: fields[8] as String?,
      age: fields[9] as int?,
      isEstimatedAge: fields[10] as bool?,
      sexualOrientationId: fields[11] as int?,
      languageId: fields[12] as int?,
      genderId: fields[13] as int?,
      maritalStatusId: fields[14] as int?,
      preferredContactTypeId: fields[15] as int?,
      religionId: fields[16] as int?,
      phoneNumber: fields[17] as String?,
      mobilePhoneNumber: fields[18] as String?,
      emailAddress: fields[19] as String?,
      populationGroupId: fields[20] as int?,
      nationalityId: fields[22] as int?,
      disabilityTypeId: fields[23] as int?,
      citizenshipId: fields[24] as int?,
      dateLastModified: fields[25] as String?,
      modifiedBy: fields[26] as String?,
      createdBy: fields[27] as String?,
      userId: fields[28] as int?,
      disabilityTypeModel: fields[29] as DisabilityTypeModel?,
      genderModel: fields[30] as GenderModel?,
      languageModel: fields[31] as LanguageModel?,
      maritalStatusModel: fields[32] as MaritalStatusModel?,
      identificationTypeModel: fields[33] as IdentificationTypeModel?,
      placementTypeModel: fields[34] as PlacementTypeModel?,
    );
  }

  @override
  void write(BinaryWriter writer, PersonModel obj) {
    writer
      ..writeByte(34)
      ..writeByte(0)
      ..write(obj.personId)
      ..writeByte(1)
      ..write(obj.firstName)
      ..writeByte(2)
      ..write(obj.lastName)
      ..writeByte(3)
      ..write(obj.knownAs)
      ..writeByte(4)
      ..write(obj.identificationTypeId)
      ..writeByte(5)
      ..write(obj.identificationNumber)
      ..writeByte(6)
      ..write(obj.isPivaValidated)
      ..writeByte(7)
      ..write(obj.pivaTransactionId)
      ..writeByte(8)
      ..write(obj.dateOfBirth)
      ..writeByte(9)
      ..write(obj.age)
      ..writeByte(10)
      ..write(obj.isEstimatedAge)
      ..writeByte(11)
      ..write(obj.sexualOrientationId)
      ..writeByte(12)
      ..write(obj.languageId)
      ..writeByte(13)
      ..write(obj.genderId)
      ..writeByte(14)
      ..write(obj.maritalStatusId)
      ..writeByte(15)
      ..write(obj.preferredContactTypeId)
      ..writeByte(16)
      ..write(obj.religionId)
      ..writeByte(17)
      ..write(obj.phoneNumber)
      ..writeByte(18)
      ..write(obj.mobilePhoneNumber)
      ..writeByte(19)
      ..write(obj.emailAddress)
      ..writeByte(20)
      ..write(obj.populationGroupId)
      ..writeByte(22)
      ..write(obj.nationalityId)
      ..writeByte(23)
      ..write(obj.disabilityTypeId)
      ..writeByte(24)
      ..write(obj.citizenshipId)
      ..writeByte(25)
      ..write(obj.dateLastModified)
      ..writeByte(26)
      ..write(obj.modifiedBy)
      ..writeByte(27)
      ..write(obj.createdBy)
      ..writeByte(28)
      ..write(obj.userId)
      ..writeByte(29)
      ..write(obj.disabilityTypeModel)
      ..writeByte(30)
      ..write(obj.genderModel)
      ..writeByte(31)
      ..write(obj.languageModel)
      ..writeByte(32)
      ..write(obj.maritalStatusModel)
      ..writeByte(33)
      ..write(obj.identificationTypeModel)
      ..writeByte(34)
      ..write(obj.placementTypeModel);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PersonModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
