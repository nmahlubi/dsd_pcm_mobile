// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_token.model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AuthTokenModelAdapter extends TypeAdapter<AuthTokenModel> {
  @override
  final int typeId = 1;

  @override
  AuthTokenModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AuthTokenModel(
      userId: fields[0] as int?,
      username: fields[1] as String?,
      firstname: fields[2] as String?,
      password: fields[3] as String?,
      supervisor: fields[4] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, AuthTokenModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.username)
      ..writeByte(2)
      ..write(obj.firstname)
      ..writeByte(3)
      ..write(obj.password)
      ..writeByte(4)
      ..write(obj.supervisor);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthTokenModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
