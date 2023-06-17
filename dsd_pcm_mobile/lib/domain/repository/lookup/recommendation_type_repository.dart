import 'package:hive_flutter/adapters.dart';

import '../../../model/intake/recommendation_type_dto.dart';
import '../../db_model_hive/lookup/recommendation_type.model.dart';

const String recommendationTypeBox = 'recommendationTypeBox';

class RecommendationTypeRepository {
  RecommendationTypeRepository._constructor();

  static final RecommendationTypeRepository _instance =
      RecommendationTypeRepository._constructor();

  factory RecommendationTypeRepository() => _instance;

  late Box<RecommendationTypeModel> _recommendationTypesBox;

  Future<void> initialize() async {
    await Hive.initFlutter();
    Hive.registerAdapter<RecommendationTypeModel>(
        RecommendationTypeModelAdapter());
    _recommendationTypesBox =
        await Hive.openBox<RecommendationTypeModel>(recommendationTypeBox);
  }

  Future<void> saveRecommendationTypeItems(
      List<RecommendationTypeDto> recommendationTypesDto) async {
    for (var recommendationTypeDto in recommendationTypesDto) {
      await _recommendationTypesBox.put(
          recommendationTypeDto.recommendationTypeId,
          (RecommendationTypeModel(
              recommendationTypeId: recommendationTypeDto.recommendationTypeId,
              description: recommendationTypeDto.description)));
    }
  }

  Future<void> saveRecommendationType(
      RecommendationTypeDto recommendationTypeDto) async {
    await _recommendationTypesBox.put(
        recommendationTypeDto.recommendationTypeId,
        RecommendationTypeModel(
            recommendationTypeId: recommendationTypeDto.recommendationTypeId,
            description: recommendationTypeDto.description));
  }

  Future<void> deleteRecommendationType(int id) async {
    await _recommendationTypesBox.delete(id);
  }

  Future<void> deleteAllRecommendationTypes() async {
    await _recommendationTypesBox.clear();
  }

  List<RecommendationTypeDto> getAllRecommendationTypes() {
    return _recommendationTypesBox.values
        .map(_recommendationTypeFromDb)
        .toList();
  }

  RecommendationTypeDto? getRecommendationTypeById(int id) {
    final bookDb = _recommendationTypesBox.get(id);
    if (bookDb != null) {
      return _recommendationTypeFromDb(bookDb);
    }
    return null;
  }

  RecommendationTypeDto recommendationTypeFromDb(
          RecommendationTypeModel? recommendationTypeModel) =>
      RecommendationTypeDto(
        recommendationTypeId: recommendationTypeModel?.recommendationTypeId,
        description: recommendationTypeModel?.description,
      );

  RecommendationTypeModel recommendationTypeToDb(
          RecommendationTypeDto? recommendationTypeDto) =>
      RecommendationTypeModel(
        recommendationTypeId: recommendationTypeDto?.recommendationTypeId,
        description: recommendationTypeDto?.description,
      );

  RecommendationTypeDto _recommendationTypeFromDb(
          RecommendationTypeModel recommendationTypeModel) =>
      RecommendationTypeDto(
        recommendationTypeId: recommendationTypeModel.recommendationTypeId,
        description: recommendationTypeModel.description,
      );
}
