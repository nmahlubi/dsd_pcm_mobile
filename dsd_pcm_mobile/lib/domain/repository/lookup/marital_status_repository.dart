import 'package:hive_flutter/adapters.dart';

import '../../../model/intake/marital_status_dto.dart';
import '../../db_model_hive/lookup/marital_status.model.dart';

const String maritalStatusBox = 'maritalStatusBox';

class MaritalStatusRepository {
  MaritalStatusRepository._constructor();

  static final MaritalStatusRepository _instance =
      MaritalStatusRepository._constructor();

  factory MaritalStatusRepository() => _instance;

  late Box<MaritalStatusModel> _maritalStatusBox;

  Future<void> initialize() async {
    await Hive.initFlutter();
    Hive.registerAdapter<MaritalStatusModel>(MaritalStatusModelAdapter());
    _maritalStatusBox =
        await Hive.openBox<MaritalStatusModel>(maritalStatusBox);
  }

  Future<void> saveMaritalStatusItems(
      List<MaritalStatusDto> maritalStatusesDto) async {
    for (var maritalStatusDto in maritalStatusesDto) {
      await _maritalStatusBox.put(
          maritalStatusDto.maritalStatusId,
          (MaritalStatusModel(
              maritalStatusId: maritalStatusDto.maritalStatusId,
              description: maritalStatusDto.description)));
    }
  }

  Future<void> saveMaritalStatus(MaritalStatusDto maritalStatusDto) async {
    await _maritalStatusBox.put(
        maritalStatusDto.maritalStatusId,
        MaritalStatusModel(
            maritalStatusId: maritalStatusDto.maritalStatusId,
            description: maritalStatusDto.description));
  }

  Future<void> deleteMaritalStatus(int id) async {
    await _maritalStatusBox.delete(id);
  }

  Future<void> deleteAllMaritalStatuses() async {
    await _maritalStatusBox.clear();
  }

  List<MaritalStatusDto> getAllMaritalStatuses() {
    return _maritalStatusBox.values.map(maritalStatusFromDb).toList();
  }

  MaritalStatusDto? getMaritalStatusById(int id) {
    final bookDb = _maritalStatusBox.get(id);
    if (bookDb != null) {
      return maritalStatusFromDb(bookDb);
    }
    return null;
  }

  MaritalStatusDto maritalStatusFromDb(MaritalStatusModel maritalStatusModel) =>
      MaritalStatusDto(
          maritalStatusId: maritalStatusModel.maritalStatusId,
          description: maritalStatusModel.description);

  MaritalStatusModel maritalStatusToDb(MaritalStatusDto? maritalStatusDto) =>
      MaritalStatusModel(
          maritalStatusId: maritalStatusDto?.maritalStatusId,
          description: maritalStatusDto?.description);
}
