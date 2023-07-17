// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assesment_register.model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AssesmentRegisterModelAdapter
    extends TypeAdapter<AssesmentRegisterModel> {
  @override
  final int typeId = 44;

  @override
  AssesmentRegisterModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AssesmentRegisterModel(
      assesmentRegisterId: fields[0] as int?,
      pcmCaseId: fields[1] as int?,
      intakeAssessmentId: fields[2] as int?,
      probationOfficerId: fields[3] as int?,
      assessedBy: fields[4] as int?,
      assessmentDate: fields[5] as String?,
      assessmentTime: fields[6] as String?,
      formOfNotificationId: fields[7] as int?,
      townId: fields[8] as int?,
      createdBy: fields[9] as int?,
      modifiedBy: fields[10] as int?,
      dateCreated: fields[11] as String?,
      dateModified: fields[12] as String?,
      formOfNotificationModel: fields[13] as FormOfNotificationModel?,
    );
  }

  @override
  void write(BinaryWriter writer, AssesmentRegisterModel obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.assesmentRegisterId)
      ..writeByte(1)
      ..write(obj.pcmCaseId)
      ..writeByte(2)
      ..write(obj.intakeAssessmentId)
      ..writeByte(3)
      ..write(obj.probationOfficerId)
      ..writeByte(4)
      ..write(obj.assessedBy)
      ..writeByte(5)
      ..write(obj.assessmentDate)
      ..writeByte(6)
      ..write(obj.assessmentTime)
      ..writeByte(7)
      ..write(obj.formOfNotificationId)
      ..writeByte(8)
      ..write(obj.townId)
      ..writeByte(9)
      ..write(obj.createdBy)
      ..writeByte(10)
      ..write(obj.modifiedBy)
      ..writeByte(11)
      ..write(obj.dateCreated)
      ..writeByte(12)
      ..write(obj.dateModified)
      ..writeByte(13)
      ..write(obj.formOfNotificationModel);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AssesmentRegisterModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
