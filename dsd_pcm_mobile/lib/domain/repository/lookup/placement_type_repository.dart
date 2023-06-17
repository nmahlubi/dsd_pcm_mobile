import 'package:hive_flutter/adapters.dart';

import '../../../model/intake/placement_type_dto.dart';
import '../../db_model_hive/lookup/placement_type.model.dart';

const String placementTypeBox = 'placementTypeBox';

class PlacementTypeRepository {
  PlacementTypeRepository._constructor();

  static final PlacementTypeRepository _instance =
      PlacementTypeRepository._constructor();

  factory PlacementTypeRepository() => _instance;

  late Box<PlacementTypeModel> _placementTypesBox;

  Future<void> initialize() async {
    await Hive.initFlutter();
    Hive.registerAdapter<PlacementTypeModel>(PlacementTypeModelAdapter());
    _placementTypesBox =
        await Hive.openBox<PlacementTypeModel>(placementTypeBox);
  }

  Future<void> savePlacementTypeItems(
      List<PlacementTypeDto> placementTypesDto) async {
    for (var placementTypeDto in placementTypesDto) {
      await _placementTypesBox.put(
          placementTypeDto.placementTypeId,
          (PlacementTypeModel(
              placementTypeId: placementTypeDto.placementTypeId,
              description: placementTypeDto.description)));
    }
  }

  Future<void> savePlacementType(PlacementTypeDto placementTypeDto) async {
    await _placementTypesBox.put(
        placementTypeDto.placementTypeId,
        PlacementTypeModel(
            placementTypeId: placementTypeDto.placementTypeId,
            description: placementTypeDto.description));
  }

  Future<void> deletePlacementType(int id) async {
    await _placementTypesBox.delete(id);
  }

  Future<void> deleteAllPlacementTypes() async {
    await _placementTypesBox.clear();
  }

  List<PlacementTypeDto> getAllPlacementTypes() {
    return _placementTypesBox.values.map(placementTypeFromDb).toList();
  }

  PlacementTypeDto? getPlacementTypeById(int id) {
    final bookDb = _placementTypesBox.get(id);
    if (bookDb != null) {
      return placementTypeFromDb(bookDb);
    }
    return null;
  }

  PlacementTypeDto placementTypeFromDb(PlacementTypeModel placementTypeModel) =>
      PlacementTypeDto(
        placementTypeId: placementTypeModel.placementTypeId,
        description: placementTypeModel.description,
      );

  PlacementTypeModel placementTypeToDb(PlacementTypeDto? placementTypeDto) =>
      PlacementTypeModel(
        placementTypeId: placementTypeDto?.placementTypeId,
        description: placementTypeDto?.description,
      );
}
