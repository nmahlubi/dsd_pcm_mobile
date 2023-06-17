// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_type.model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AddressTypeModelAdapter extends TypeAdapter<AddressTypeModel> {
  @override
  final int typeId = 17;

  @override
  AddressTypeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AddressTypeModel(
      addressTypeId: fields[0] as int?,
      description: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, AddressTypeModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.addressTypeId)
      ..writeByte(1)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddressTypeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
