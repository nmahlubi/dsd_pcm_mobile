// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address.model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AddressModelAdapter extends TypeAdapter<AddressModel> {
  @override
  final int typeId = 31;

  @override
  AddressModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AddressModel(
      addressId: fields[0] as int?,
      addressTypeId: fields[1] as int?,
      addressLine1: fields[2] as String?,
      addressLine2: fields[3] as String?,
      townId: fields[4] as int?,
      postalCode: fields[5] as String?,
      addressType: fields[6] as String?,
      addressTypeModel: fields[7] as AddressTypeModel?,
    );
  }

  @override
  void write(BinaryWriter writer, AddressModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.addressId)
      ..writeByte(1)
      ..write(obj.addressTypeId)
      ..writeByte(2)
      ..write(obj.addressLine1)
      ..writeByte(3)
      ..write(obj.addressLine2)
      ..writeByte(4)
      ..write(obj.townId)
      ..writeByte(5)
      ..write(obj.postalCode)
      ..writeByte(6)
      ..write(obj.addressType)
      ..writeByte(7)
      ..write(obj.addressTypeModel);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddressModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
