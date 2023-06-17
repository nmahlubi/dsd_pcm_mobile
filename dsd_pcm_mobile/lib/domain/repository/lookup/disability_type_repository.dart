import 'package:hive_flutter/adapters.dart';

import '../../../model/intake/disability_type_dto.dart';
import '../../db_model_hive/lookup/disability_type.model.dart';

const String disabilityTypeBox = 'disabilityTypeBox';

class DisabilityTypeRepository {
  DisabilityTypeRepository._constructor();

  static final DisabilityTypeRepository _instance =
      DisabilityTypeRepository._constructor();

  factory DisabilityTypeRepository() => _instance;

  late Box<DisabilityTypeModel> _disabilityTypesBox;

  Future<void> initialize() async {
    await Hive.initFlutter();
    Hive.registerAdapter<DisabilityTypeModel>(DisabilityTypeModelAdapter());
    _disabilityTypesBox =
        await Hive.openBox<DisabilityTypeModel>(disabilityTypeBox);
  }

  Future<void> saveDisabilityTypeItems(
      List<DisabilityTypeDto> disabilityTypesDto) async {
    for (var disabilityTypeDto in disabilityTypesDto) {
      await _disabilityTypesBox.put(
          disabilityTypeDto.disabilityTypeId,
          (DisabilityTypeModel(
              disabilityTypeId: disabilityTypeDto.disabilityTypeId,
              typeName: disabilityTypeDto.typeName)));
    }
  }

  Future<void> saveDisabilityType(DisabilityTypeDto disabilityTypeDto) async {
    await _disabilityTypesBox.put(
        disabilityTypeDto.disabilityTypeId,
        DisabilityTypeModel(
            disabilityTypeId: disabilityTypeDto.disabilityTypeId,
            typeName: disabilityTypeDto.typeName));
  }

  Future<void> deleteDisabilityType(int id) async {
    await _disabilityTypesBox.delete(id);
  }

  Future<void> deleteAllDisabilityTypes() async {
    await _disabilityTypesBox.clear();
  }

  List<DisabilityTypeDto> getAllDisabilityTypes() {
    return _disabilityTypesBox.values.map(disabilityTypeFromDb).toList();
  }

  DisabilityTypeDto? getDisabilityTypeById(int id) {
    final bookDb = _disabilityTypesBox.get(id);
    if (bookDb != null) {
      return disabilityTypeFromDb(bookDb);
    }
    return null;
  }

  DisabilityTypeDto disabilityTypeFromDb(
          DisabilityTypeModel disabilityTypeModel) =>
      DisabilityTypeDto(
        disabilityTypeId: disabilityTypeModel.disabilityTypeId,
        typeName: disabilityTypeModel.typeName,
      );

  DisabilityTypeModel disabilityTypeToDb(
          DisabilityTypeDto? disabilityTypeDto) =>
      DisabilityTypeModel(
          disabilityTypeId: disabilityTypeDto?.disabilityTypeId,
          typeName: disabilityTypeDto?.typeName);
}
