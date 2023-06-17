// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medical_health_detail.model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MedicalHealthDetailModelAdapter
    extends TypeAdapter<MedicalHealthDetailModel> {
  @override
  final int typeId = 20;

  @override
  MedicalHealthDetailModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MedicalHealthDetailModel(
      healthDetailsId: fields[0] as int?,
      healthStatusId: fields[1] as int?,
      injuries: fields[2] as String?,
      medication: fields[3] as String?,
      allergies: fields[4] as String?,
      medicalAppointments: fields[5] as String?,
      intakeAssessmentId: fields[6] as int?,
      createdBy: fields[7] as int?,
      dateCreated: fields[8] as String?,
      modifiedBy: fields[9] as int?,
      dateModified: fields[10] as String?,
      healthStatusModel: fields[11] as HealthStatusModel?,
    );
  }

  @override
  void write(BinaryWriter writer, MedicalHealthDetailModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.healthDetailsId)
      ..writeByte(1)
      ..write(obj.healthStatusId)
      ..writeByte(2)
      ..write(obj.injuries)
      ..writeByte(3)
      ..write(obj.medication)
      ..writeByte(4)
      ..write(obj.allergies)
      ..writeByte(5)
      ..write(obj.medicalAppointments)
      ..writeByte(6)
      ..write(obj.intakeAssessmentId)
      ..writeByte(7)
      ..write(obj.createdBy)
      ..writeByte(8)
      ..write(obj.dateCreated)
      ..writeByte(9)
      ..write(obj.modifiedBy)
      ..writeByte(10)
      ..write(obj.dateModified)
      ..writeByte(11)
      ..write(obj.healthStatusModel);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MedicalHealthDetailModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
