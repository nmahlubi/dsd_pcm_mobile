import 'package:hive/hive.dart';

import '../lookup/placement_type.model.dart';
import '../lookup/recommendation_type.model.dart';

part 'recommendation.model.g.dart';

@HiveType(typeId: 15)
class RecommendationModel {
  @HiveField(0)
  final int? recommendationId;
  @HiveField(1)
  final int? recommendationTypeId;
  @HiveField(2)
  final int? placementTypeId;
  @HiveField(3)
  final String? commentsForRecommendation;
  @HiveField(4)
  final int? createdBy;
  @HiveField(5)
  final String? dateCreated;
  @HiveField(6)
  final int? modifiedBy;
  @HiveField(7)
  final String? dateModified;
  @HiveField(8)
  final int? intakeAssessmentId;
  @HiveField(9)
  final RecommendationTypeModel? recommendationType;
  @HiveField(10)
  final PlacementTypeModel? placementTypeModel;

  RecommendationModel(
      {this.recommendationId,
      this.recommendationTypeId,
      this.placementTypeId,
      this.commentsForRecommendation,
      this.createdBy,
      this.dateCreated,
      this.modifiedBy,
      this.dateModified,
      this.intakeAssessmentId,
      this.recommendationType,
      this.placementTypeModel});
}
