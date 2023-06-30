// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'development_assessment.model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DevelopmentAssessmentModelAdapter
    extends TypeAdapter<DevelopmentAssessmentModel> {
  @override
  final int typeId = 38;

  @override
  DevelopmentAssessmentModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DevelopmentAssessmentModel(
      developmentId: fields[0] as int?,
      intakeAssessmentId: fields[1] as int?,
      belonging: fields[2] as String?,
      mastery: fields[3] as String?,
      independence: fields[4] as String?,
      generosity: fields[5] as String?,
      evaluation: fields[6] as String?,
      createdBy: fields[7] as int?,
      modifiedBy: fields[8] as int?,
      dateCreated: fields[9] as String?,
      dateModified: fields[10] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, DevelopmentAssessmentModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.developmentId)
      ..writeByte(1)
      ..write(obj.intakeAssessmentId)
      ..writeByte(2)
      ..write(obj.belonging)
      ..writeByte(3)
      ..write(obj.mastery)
      ..writeByte(4)
      ..write(obj.independence)
      ..writeByte(5)
      ..write(obj.generosity)
      ..writeByte(6)
      ..write(obj.evaluation)
      ..writeByte(7)
      ..write(obj.createdBy)
      ..writeByte(8)
      ..write(obj.modifiedBy)
      ..writeByte(9)
      ..write(obj.dateCreated)
      ..writeByte(10)
      ..write(obj.dateModified);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DevelopmentAssessmentModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
