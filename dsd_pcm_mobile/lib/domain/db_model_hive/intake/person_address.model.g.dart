// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person_address.model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PersonAddressModelAdapter extends TypeAdapter<PersonAddressModel> {
  @override
  final int typeId = 32;

  @override
  PersonAddressModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PersonAddressModel(
      personId: fields[0] as int?,
      addressId: fields[1] as int?,
      addressModel: fields[2] as AddressModel?,
    );
  }

  @override
  void write(BinaryWriter writer, PersonAddressModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.personId)
      ..writeByte(1)
      ..write(obj.addressId)
      ..writeByte(2)
      ..write(obj.addressModel);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PersonAddressModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
