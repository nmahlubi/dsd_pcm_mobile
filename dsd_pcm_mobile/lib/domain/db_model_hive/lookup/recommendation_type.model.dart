import 'package:hive/hive.dart';

part 'recommendation_type.model.g.dart';

@HiveType(typeId: 14)
class RecommendationTypeModel {
  @HiveField(0)
  final int? recommendationTypeId;
  @HiveField(1)
  final String? description;

  RecommendationTypeModel({this.recommendationTypeId, this.description});
}
