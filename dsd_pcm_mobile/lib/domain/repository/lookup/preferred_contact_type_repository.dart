import 'package:hive_flutter/adapters.dart';

import '../../../model/intake/preferred_contact_type_dto.dart';
import '../../db_model_hive/lookup/preferred_contact_type.model.dart';

const String preferredContactTypeBox = 'preferredContactTypeBox';

class PreferredContactTypeRepository {
  PreferredContactTypeRepository._constructor();

  static final PreferredContactTypeRepository _instance =
      PreferredContactTypeRepository._constructor();

  factory PreferredContactTypeRepository() => _instance;

  late Box<PreferredContactTypeModel> _preferredContactTypesBox;

  Future<void> initialize() async {
    await Hive.initFlutter();
    Hive.registerAdapter<PreferredContactTypeModel>(
        PreferredContactTypeModelAdapter());
    _preferredContactTypesBox =
        await Hive.openBox<PreferredContactTypeModel>(preferredContactTypeBox);
  }

  Future<void> savePreferredContactTypeItems(
      List<PreferredContactTypeDto> preferredContactTypesDto) async {
    for (var preferredContactTypeDto in preferredContactTypesDto) {
      await _preferredContactTypesBox.put(
          preferredContactTypeDto.preferredContactTypeId,
          (PreferredContactTypeModel(
              preferredContactTypeId:
                  preferredContactTypeDto.preferredContactTypeId,
              description: preferredContactTypeDto.description)));
    }
  }

  Future<void> savePreferredContactType(
      PreferredContactTypeDto preferredContactTypeDto) async {
    await _preferredContactTypesBox.put(
        preferredContactTypeDto.preferredContactTypeId,
        PreferredContactTypeModel(
            preferredContactTypeId:
                preferredContactTypeDto.preferredContactTypeId,
            description: preferredContactTypeDto.description));
  }

  Future<void> deletePreferredContactType(int id) async {
    await _preferredContactTypesBox.delete(id);
  }

  Future<void> deleteAllPreferredContactTypes() async {
    await _preferredContactTypesBox.clear();
  }

  List<PreferredContactTypeDto> getAllPreferredContactTypes() {
    return _preferredContactTypesBox.values
        .map(preferredContactTypeFromDb)
        .toList();
  }

  PreferredContactTypeDto? getPreferredContactTypeById(int id) {
    final bookDb = _preferredContactTypesBox.get(id);
    if (bookDb != null) {
      return preferredContactTypeFromDb(bookDb);
    }
    return null;
  }

  PreferredContactTypeDto preferredContactTypeFromDb(
          PreferredContactTypeModel preferredContactTypeModel) =>
      PreferredContactTypeDto(
          preferredContactTypeId:
              preferredContactTypeModel.preferredContactTypeId,
          description: preferredContactTypeModel.description);

  PreferredContactTypeModel preferredContactTypeToDb(
          PreferredContactTypeDto? preferredContactTypeDto) =>
      PreferredContactTypeModel(
          preferredContactTypeId:
              preferredContactTypeDto?.preferredContactTypeId,
          description: preferredContactTypeDto?.description);
}
