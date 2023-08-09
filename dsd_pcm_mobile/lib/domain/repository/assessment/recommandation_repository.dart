import 'package:hive_flutter/adapters.dart';

import '../../../model/pcm/recommendations_dto.dart';
import '../../db_model_hive/assessment/recommendation.model.dart';
import '../lookup/placement_type_repository.dart';
import '../lookup/recommendation_type_repository.dart';

const String recommendationBox = 'recommendationBox';

class RecommendationRepository {
  RecommendationRepository._constructor();
  final _recommendationTypeRepository = RecommendationTypeRepository();
  final _placementTypeRepository = PlacementTypeRepository();
  static final RecommendationRepository _instance =
      RecommendationRepository._constructor();

  factory RecommendationRepository() => _instance;

  late Box<RecommendationModel> _recommendationsBox;

  Future<void> initialize() async {
    await Hive.initFlutter();
    Hive.registerAdapter<RecommendationModel>(RecommendationModelAdapter());
    _recommendationsBox =
        await Hive.openBox<RecommendationModel>(recommendationBox);
  }

  Future<void> saveRecommendationItems(
      List<RecommendationDto> recommendationsDto) async {
    for (var recommendationDto in recommendationsDto) {
      await _recommendationsBox.put(
          recommendationDto.recommendationId,
          (RecommendationModel(
            recommendationId: recommendationDto.recommendationId,
            recommendationTypeId: recommendationDto.recommendationTypeId,
            placementTypeId: recommendationDto.placementTypeId,
            commentsForRecommendation:
                recommendationDto.commentsForRecommendation,
            createdBy: recommendationDto.createdBy,
            dateCreated: recommendationDto.dateCreated,
            modifiedBy: recommendationDto.modifiedBy,
            dateModified: recommendationDto.dateModified,
            intakeAssessmentId: recommendationDto.intakeAssessmentId,
            recommendationType:
                _recommendationTypeRepository.recommendationTypeToDb(
                    recommendationDto.recommendationTypeDto),
            placementTypeModel: _placementTypeRepository
                .placementTypeToDb(recommendationDto.placementTypeDto),
          )));
    }
  }

  Future<void> saveRecommendation(RecommendationDto recommendationDto) async {
    await _recommendationsBox.put(
        recommendationDto.intakeAssessmentId,
        RecommendationModel(
            recommendationId: recommendationDto.recommendationId,
            recommendationTypeId: recommendationDto.recommendationTypeId,
            placementTypeId: recommendationDto.placementTypeId,
            commentsForRecommendation:
                recommendationDto.commentsForRecommendation,
            createdBy: recommendationDto.createdBy,
            dateCreated: recommendationDto.dateCreated,
            modifiedBy: recommendationDto.modifiedBy,
            dateModified: recommendationDto.dateModified,
            intakeAssessmentId: recommendationDto.intakeAssessmentId,
            recommendationType:
                _recommendationTypeRepository.recommendationTypeToDb(
                    recommendationDto.recommendationTypeDto),
            placementTypeModel: _placementTypeRepository
                .placementTypeToDb(recommendationDto.placementTypeDto)));
  }

  Future<void> saveRecommendationFromEndpoint(
      RecommendationDto recommendationDto, int recommendationId) async {
    await _recommendationsBox.put(
        recommendationDto.intakeAssessmentId,
        RecommendationModel(
            recommendationId: recommendationId,
            recommendationTypeId: recommendationDto.recommendationTypeId,
            placementTypeId: recommendationDto.placementTypeId,
            commentsForRecommendation:
                recommendationDto.commentsForRecommendation,
            createdBy: recommendationDto.createdBy,
            dateCreated: recommendationDto.dateCreated,
            modifiedBy: recommendationDto.modifiedBy,
            dateModified: recommendationDto.dateModified,
            intakeAssessmentId: recommendationDto.intakeAssessmentId,
            recommendationType:
                _recommendationTypeRepository.recommendationTypeToDb(
                    recommendationDto.recommendationTypeDto),
            placementTypeModel: _placementTypeRepository
                .placementTypeToDb(recommendationDto.placementTypeDto)));
  }

  List<RecommendationDto> getAllRecommendations() {
    return _recommendationsBox.values.map(recommendationFromDb).toList();
  }

  RecommendationDto? getRecommendationById(int id) {
    final medicalHealthDetailDb = _recommendationsBox.get(id);
    if (medicalHealthDetailDb != null) {
      return recommendationFromDb(medicalHealthDetailDb);
    }
    return null;
  }

  List<RecommendationDto> getRecommendationByIntakeAssessment(
      int? intakeAssessmentId) {
    var recommandationDtoItems = _recommendationsBox.values
        .where((medical) => medical.intakeAssessmentId == intakeAssessmentId)
        .toList();

    return recommandationDtoItems.map(recommendationFromDb).toList();
  }

  Future<void> deleteRecommendationByAssessmentId(int id) async {
    await _recommendationsBox.delete(id);
  }

/*
  Future<void> deleteRecommendation(int id) async {
    await _recommendationsBox.delete(id);
  }

  Future<void> deleteAllRecommendations() async {
    await _recommendationsBox.clear();
  }

  

  RecommendationDto? getRecommendationById(int id) {
    final bookDb = _recommendationsBox.get(id);
    if (bookDb != null) {
      return _RecommendationFromDb(bookDb);
    }
    return null;
  }
  */
/*
  RecommendationTypeModel _recommendationTypeToDb(
          RecommendationTypeDto? recommendationTypeDto) =>
      RecommendationTypeModel(
        recommendationTypeId: recommendationTypeDto?.recommendationTypeId,
        description: recommendationTypeDto?.description,
      );
      */
/*
 
      */

  RecommendationDto recommendationFromDb(
          RecommendationModel recommendationModel) =>
      RecommendationDto(
          recommendationId: recommendationModel.recommendationId,
          recommendationTypeId: recommendationModel.recommendationTypeId,
          placementTypeId: recommendationModel.placementTypeId,
          commentsForRecommendation:
              recommendationModel.commentsForRecommendation,
          createdBy: recommendationModel.createdBy,
          dateCreated: recommendationModel.dateCreated,
          modifiedBy: recommendationModel.modifiedBy,
          dateModified: recommendationModel.dateModified,
          intakeAssessmentId: recommendationModel.intakeAssessmentId,
          recommendationTypeDto:
              _recommendationTypeRepository.recommendationTypeFromDb(
                  recommendationModel.recommendationType!),
          placementTypeDto: _placementTypeRepository
              .placementTypeFromDb(recommendationModel.placementTypeModel!));
}
