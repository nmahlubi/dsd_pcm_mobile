import 'package:hive_flutter/adapters.dart';

import '../../../model/intake/identification_type_dto.dart';
import '../../db_model_hive/lookup/identification_type.model.dart';

const String identificationTypeBox = 'identificationTypeBox';

class IdentificationTypeRepository {
  IdentificationTypeRepository._constructor();

  static final IdentificationTypeRepository _instance =
      IdentificationTypeRepository._constructor();

  factory IdentificationTypeRepository() => _instance;

  late Box<IdentificationTypeModel> _identificationTypesBox;

  Future<void> initialize() async {
    await Hive.initFlutter();
    Hive.registerAdapter<IdentificationTypeModel>(
        IdentificationTypeModelAdapter());
    _identificationTypesBox =
        await Hive.openBox<IdentificationTypeModel>(identificationTypeBox);
  }

  Future<void> saveIdentificationTypeItems(
      List<IdentificationTypeDto> identificationTypesDto) async {
    for (var identificationTypeDto in identificationTypesDto) {
      await _identificationTypesBox.put(
          identificationTypeDto.identificationTypeId,
          (IdentificationTypeModel(
              identificationTypeId: identificationTypeDto.identificationTypeId,
              description: identificationTypeDto.description)));
    }
  }

  Future<void> saveIdentificationType(
      IdentificationTypeDto identificationTypeDto) async {
    await _identificationTypesBox.put(
        identificationTypeDto.identificationTypeId,
        IdentificationTypeModel(
            identificationTypeId: identificationTypeDto.identificationTypeId,
            description: identificationTypeDto.description));
  }

  Future<void> deleteIdentificationType(int id) async {
    await _identificationTypesBox.delete(id);
  }

  Future<void> deleteAllIdentificationTypes() async {
    await _identificationTypesBox.clear();
  }

  List<IdentificationTypeDto> getAllIdentificationTypes() {
    return _identificationTypesBox.values
        .map(identificationTypeFromDb)
        .toList();
  }

  IdentificationTypeDto? getIdentificationTypeById(int id) {
    final bookDb = _identificationTypesBox.get(id);
    if (bookDb != null) {
      return identificationTypeFromDb(bookDb);
    }
    return null;
  }

  IdentificationTypeDto identificationTypeFromDb(
          IdentificationTypeModel identificationTypeModel) =>
      IdentificationTypeDto(
          identificationTypeId: identificationTypeModel.identificationTypeId,
          description: identificationTypeModel.description);

  IdentificationTypeModel identificationTypeToDb(
          IdentificationTypeDto? identificationTypeDto) =>
      IdentificationTypeModel(
          identificationTypeId: identificationTypeDto?.identificationTypeId,
          description: identificationTypeDto?.description);
}
