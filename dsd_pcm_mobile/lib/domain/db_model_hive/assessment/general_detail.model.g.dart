// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'general_detail.model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GeneralDetailModelAdapter extends TypeAdapter<GeneralDetailModel> {
  @override
  final int typeId = 34;

  @override
  GeneralDetailModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GeneralDetailModel(
      generalDetailsId: fields[0] as int?,
      intakeAssessmentId: fields[1] as int?,
      consultedSources: fields[2] as String?,
      traceEfforts: fields[3] as String?,
      assessmentDate: fields[4] as String?,
      additionalInfo: fields[5] as String?,
      isVerifiedBySupervisor: fields[6] as int?,
      commentsBySupervisor: fields[7] as String?,
      createdBy: fields[8] as int?,
      modifiedBy: fields[9] as int?,
      dateCreated: fields[10] as String?,
      dateModified: fields[11] as String?,
      assessmentTime: fields[12] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, GeneralDetailModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.generalDetailsId)
      ..writeByte(1)
      ..write(obj.intakeAssessmentId)
      ..writeByte(2)
      ..write(obj.consultedSources)
      ..writeByte(3)
      ..write(obj.traceEfforts)
      ..writeByte(4)
      ..write(obj.assessmentDate)
      ..writeByte(5)
      ..write(obj.additionalInfo)
      ..writeByte(6)
      ..write(obj.isVerifiedBySupervisor)
      ..writeByte(7)
      ..write(obj.commentsBySupervisor)
      ..writeByte(8)
      ..write(obj.createdBy)
      ..writeByte(9)
      ..write(obj.modifiedBy)
      ..writeByte(10)
      ..write(obj.dateCreated)
      ..writeByte(11)
      ..write(obj.dateModified)
      ..writeByte(12)
      ..write(obj.assessmentTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GeneralDetailModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
