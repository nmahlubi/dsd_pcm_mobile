// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accepted_worklist.model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AcceptedWorklistModelAdapter extends TypeAdapter<AcceptedWorklistModel> {
  @override
  final int typeId = 4;

  @override
  AcceptedWorklistModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AcceptedWorklistModel(
      assessmentStatus: fields[0] as String?,
      assessmentRegisterId: fields[1] as int?,
      caseId: fields[2] as int?,
      worklistId: fields[3] as int?,
      intakeAssessmentId: fields[4] as int?,
      personId: fields[5] as int?,
      childName: fields[6] as String?,
      dateAccepted: fields[7] as String?,
      childNameAbbr: fields[8] as String?,
      clientId: fields[9] as int?,
      userId: fields[10] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, AcceptedWorklistModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.assessmentStatus)
      ..writeByte(1)
      ..write(obj.assessmentRegisterId)
      ..writeByte(2)
      ..write(obj.caseId)
      ..writeByte(3)
      ..write(obj.worklistId)
      ..writeByte(4)
      ..write(obj.intakeAssessmentId)
      ..writeByte(5)
      ..write(obj.personId)
      ..writeByte(6)
      ..write(obj.childName)
      ..writeByte(7)
      ..write(obj.dateAccepted)
      ..writeByte(8)
      ..write(obj.childNameAbbr)
      ..writeByte(9)
      ..write(obj.clientId)
      ..writeByte(10)
      ..write(obj.userId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AcceptedWorklistModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
