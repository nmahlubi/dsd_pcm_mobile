// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_detail.model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrderDetailModelAdapter extends TypeAdapter<OrderDetailModel> {
  @override
  final int typeId = 46;

  @override
  OrderDetailModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OrderDetailModel(
      orderId: fields[0] as int?,
      recommendationId: fields[1] as int?,
      recomendationOrderId: fields[2] as int?,
      createdBy: fields[4] as int?,
      orderReason: fields[3] as String?,
      dateCreated: fields[5] as String?,
      modifiedBy: fields[6] as int?,
      dateModified: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, OrderDetailModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.orderId)
      ..writeByte(1)
      ..write(obj.recommendationId)
      ..writeByte(2)
      ..write(obj.recomendationOrderId)
      ..writeByte(3)
      ..write(obj.orderReason)
      ..writeByte(4)
      ..write(obj.createdBy)
      ..writeByte(5)
      ..write(obj.dateCreated)
      ..writeByte(6)
      ..write(obj.modifiedBy)
      ..writeByte(7)
      ..write(obj.dateModified);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderDetailModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
