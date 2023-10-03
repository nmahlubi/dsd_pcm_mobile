// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pcm_order_detail.model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PcmOrderDetailModelAdapter extends TypeAdapter<PcmOrderDetailModel> {
  @override
  final int typeId = 47;

  @override
  PcmOrderDetailModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PcmOrderDetailModel(
      recomendationOrderId: fields[0] as int?,
      description: fields[1] as String?,
      definition: fields[2] as String?,
      source: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PcmOrderDetailModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.recomendationOrderId)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.definition)
      ..writeByte(3)
      ..write(obj.source);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PcmOrderDetailModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
