// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommendation_type.model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecommendationTypeModelAdapter
    extends TypeAdapter<RecommendationTypeModel> {
  @override
  final int typeId = 14;

  @override
  RecommendationTypeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecommendationTypeModel(
      recommendationTypeId: fields[0] as int?,
      description: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, RecommendationTypeModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.recommendationTypeId)
      ..writeByte(1)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecommendationTypeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
