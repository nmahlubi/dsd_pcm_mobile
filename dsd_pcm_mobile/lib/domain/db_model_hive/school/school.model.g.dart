// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'school.model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SchoolModelAdapter extends TypeAdapter<SchoolModel> {
  @override
  final int typeId = 41;

  @override
  SchoolModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SchoolModel(
      schoolId: fields[0] as int?,
      schoolTypeId: fields[1] as int?,
      schoolName: fields[2] as String?,
      contactPerson: fields[3] as String?,
      telephoneNumber: fields[4] as String?,
      cellphoneNumber: fields[5] as String?,
      faxNumber: fields[6] as String?,
      emailAddress: fields[7] as String?,
      dateCreated: fields[8] as String?,
      createdBy: fields[9] as String?,
      dateLastModified: fields[10] as String?,
      modifiedBy: fields[11] as String?,
      isActive: fields[12] as bool?,
      isDeleted: fields[13] as bool?,
      natEmis: fields[14] as String?,
      schoolTypeModel: fields[15] as SchoolTypeModel?,
    );
  }

  @override
  void write(BinaryWriter writer, SchoolModel obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.schoolId)
      ..writeByte(1)
      ..write(obj.schoolTypeId)
      ..writeByte(2)
      ..write(obj.schoolName)
      ..writeByte(3)
      ..write(obj.contactPerson)
      ..writeByte(4)
      ..write(obj.telephoneNumber)
      ..writeByte(5)
      ..write(obj.cellphoneNumber)
      ..writeByte(6)
      ..write(obj.faxNumber)
      ..writeByte(7)
      ..write(obj.emailAddress)
      ..writeByte(8)
      ..write(obj.dateCreated)
      ..writeByte(9)
      ..write(obj.createdBy)
      ..writeByte(10)
      ..write(obj.dateLastModified)
      ..writeByte(11)
      ..write(obj.modifiedBy)
      ..writeByte(12)
      ..write(obj.isActive)
      ..writeByte(13)
      ..write(obj.isDeleted)
      ..writeByte(14)
      ..write(obj.natEmis)
      ..writeByte(15)
      ..write(obj.schoolTypeModel);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SchoolModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
