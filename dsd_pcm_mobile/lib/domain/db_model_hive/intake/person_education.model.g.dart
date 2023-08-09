// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person_education.model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PersonEducationModelAdapter extends TypeAdapter<PersonEducationModel> {
  @override
  final int typeId = 45;

  @override
  PersonEducationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PersonEducationModel(
      personEducationId: fields[0] as int?,
      personId: fields[1] as int?,
      gradeId: fields[2] as int?,
      schoolId: fields[3] as int?,
      yearCompleted: fields[4] as String?,
      dateLastAttended: fields[5] as String?,
      additionalInformation: fields[6] as String?,
      dateCreated: fields[7] as String?,
      createdBy: fields[8] as String?,
      dateLastModified: fields[9] as String?,
      modifiedBy: fields[10] as String?,
      isActive: fields[11] as bool?,
      isDeleted: fields[12] as bool?,
      personModel: fields[13] as PersonModel?,
      schoolModel: fields[14] as SchoolModel?,
      gradeModel: fields[15] as GradeModel?,
      schoolName: fields[16] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PersonEducationModel obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.personEducationId)
      ..writeByte(1)
      ..write(obj.personId)
      ..writeByte(2)
      ..write(obj.gradeId)
      ..writeByte(3)
      ..write(obj.schoolId)
      ..writeByte(4)
      ..write(obj.yearCompleted)
      ..writeByte(5)
      ..write(obj.dateLastAttended)
      ..writeByte(6)
      ..write(obj.additionalInformation)
      ..writeByte(7)
      ..write(obj.dateCreated)
      ..writeByte(8)
      ..write(obj.createdBy)
      ..writeByte(9)
      ..write(obj.dateLastModified)
      ..writeByte(10)
      ..write(obj.modifiedBy)
      ..writeByte(11)
      ..write(obj.isActive)
      ..writeByte(12)
      ..write(obj.isDeleted)
      ..writeByte(13)
      ..write(obj.personModel)
      ..writeByte(14)
      ..write(obj.schoolModel)
      ..writeByte(15)
      ..write(obj.gradeModel)
      ..writeByte(16)
      ..write(obj.schoolName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PersonEducationModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
