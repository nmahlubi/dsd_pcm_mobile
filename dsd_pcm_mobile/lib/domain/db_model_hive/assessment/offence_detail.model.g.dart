// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offence_detail.model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OffenceDetailModelAdapter extends TypeAdapter<OffenceDetailModel> {
  @override
  final int typeId = 33;

  @override
  OffenceDetailModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OffenceDetailModel(
      pcmOffenceId: fields[0] as int?,
      pcmCaseId: fields[1] as int?,
      intakeAssessmentId: fields[2] as int?,
      offenceTypeId: fields[3] as int?,
      offenceCategoryId: fields[4] as int?,
      offenceScheduleId: fields[5] as int?,
      offenceCircumstance: fields[6] as String?,
      valueOfGoods: fields[7] as String?,
      valueRecovered: fields[8] as String?,
      isChildResponsible: fields[9] as String?,
      responsibilityDetails: fields[10] as String?,
      createdBy: fields[11] as int?,
      dateCreated: fields[12] as String?,
      modifiedBy: fields[13] as int?,
      dateModified: fields[14] as String?,
      offenceTypeModel: fields[15] as OffenceTypeModel?,
      offenceCategoryModel: fields[16] as OffenceCategoryModel?,
      offenceScheduleModel: fields[17] as OffenceScheduleModel?,
    );
  }

  @override
  void write(BinaryWriter writer, OffenceDetailModel obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.pcmOffenceId)
      ..writeByte(1)
      ..write(obj.pcmCaseId)
      ..writeByte(2)
      ..write(obj.intakeAssessmentId)
      ..writeByte(3)
      ..write(obj.offenceTypeId)
      ..writeByte(4)
      ..write(obj.offenceCategoryId)
      ..writeByte(5)
      ..write(obj.offenceScheduleId)
      ..writeByte(6)
      ..write(obj.offenceCircumstance)
      ..writeByte(7)
      ..write(obj.valueOfGoods)
      ..writeByte(8)
      ..write(obj.valueRecovered)
      ..writeByte(9)
      ..write(obj.isChildResponsible)
      ..writeByte(10)
      ..write(obj.responsibilityDetails)
      ..writeByte(11)
      ..write(obj.createdBy)
      ..writeByte(12)
      ..write(obj.dateCreated)
      ..writeByte(13)
      ..write(obj.modifiedBy)
      ..writeByte(14)
      ..write(obj.dateModified)
      ..writeByte(15)
      ..write(obj.offenceTypeModel)
      ..writeByte(16)
      ..write(obj.offenceCategoryModel)
      ..writeByte(17)
      ..write(obj.offenceScheduleModel);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OffenceDetailModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
