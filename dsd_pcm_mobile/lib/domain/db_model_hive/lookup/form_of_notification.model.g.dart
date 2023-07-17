// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_of_notification.model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FormOfNotificationModelAdapter
    extends TypeAdapter<FormOfNotificationModel> {
  @override
  final int typeId = 43;

  @override
  FormOfNotificationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FormOfNotificationModel(
      formOfNotificationId: fields[0] as int?,
      description: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, FormOfNotificationModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.formOfNotificationId)
      ..writeByte(1)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FormOfNotificationModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
