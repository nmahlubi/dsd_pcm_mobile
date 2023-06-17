// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommendation.model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecommendationModelAdapter extends TypeAdapter<RecommendationModel> {
  @override
  final int typeId = 15;

  @override
  RecommendationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecommendationModel(
      recommendationId: fields[0] as int?,
      recommendationTypeId: fields[1] as int?,
      placementTypeId: fields[2] as int?,
      commentsForRecommendation: fields[3] as String?,
      createdBy: fields[4] as int?,
      dateCreated: fields[5] as String?,
      modifiedBy: fields[6] as int?,
      dateModified: fields[7] as String?,
      intakeAssessmentId: fields[8] as int?,
      recommendationType: fields[9] as RecommendationTypeModel?,
      placementTypeModel: fields[10] as PlacementTypeModel?,
    );
  }

  @override
  void write(BinaryWriter writer, RecommendationModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.recommendationId)
      ..writeByte(1)
      ..write(obj.recommendationTypeId)
      ..writeByte(2)
      ..write(obj.placementTypeId)
      ..writeByte(3)
      ..write(obj.commentsForRecommendation)
      ..writeByte(4)
      ..write(obj.createdBy)
      ..writeByte(5)
      ..write(obj.dateCreated)
      ..writeByte(6)
      ..write(obj.modifiedBy)
      ..writeByte(7)
      ..write(obj.dateModified)
      ..writeByte(8)
      ..write(obj.intakeAssessmentId)
      ..writeByte(9)
      ..write(obj.recommendationType)
      ..writeByte(10)
      ..write(obj.placementTypeModel);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecommendationModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
