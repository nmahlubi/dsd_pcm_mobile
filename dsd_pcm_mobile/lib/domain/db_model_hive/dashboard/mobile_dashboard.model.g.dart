// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mobile_dashboard.model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MobileDashboardModelAdapter extends TypeAdapter<MobileDashboardModel> {
  @override
  final int typeId = 2;

  @override
  MobileDashboardModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MobileDashboardModel(
      newPropationOfficerInbox: fields[0] as int?,
      newWorklist: fields[1] as int?,
      reAssignedCases: fields[2] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, MobileDashboardModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.newPropationOfficerInbox)
      ..writeByte(1)
      ..write(obj.newWorklist)
      ..writeByte(2)
      ..write(obj.reAssignedCases);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MobileDashboardModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
