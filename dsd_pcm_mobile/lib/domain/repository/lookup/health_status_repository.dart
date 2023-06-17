import 'package:hive_flutter/adapters.dart';

import '../../../model/intake/health_status_dto.dart';
import '../../db_model_hive/lookup/health_status.model.dart';

const String healthStatusBox = 'healthStatusBox';

class HealthStatusRepository {
  HealthStatusRepository._constructor();

  static final HealthStatusRepository _instance =
      HealthStatusRepository._constructor();

  factory HealthStatusRepository() => _instance;

  late Box<HealthStatusModel> _healthStatusesBox;

  Future<void> initialize() async {
    await Hive.initFlutter();
    Hive.registerAdapter<HealthStatusModel>(HealthStatusModelAdapter());
    _healthStatusesBox = await Hive.openBox<HealthStatusModel>(healthStatusBox);
  }

  Future<void> saveHealthStatusItems(
      List<HealthStatusDto> healthStatusesDto) async {
    for (var healthStatusDto in healthStatusesDto) {
      await _healthStatusesBox.put(
          healthStatusDto.healthStatusId,
          (HealthStatusModel(
              healthStatusId: healthStatusDto.healthStatusId,
              description: healthStatusDto.description)));
    }
  }

  Future<void> saveHealthStatus(HealthStatusDto healthStatusDto) async {
    await _healthStatusesBox.put(
        healthStatusDto.healthStatusId,
        HealthStatusModel(
            healthStatusId: healthStatusDto.healthStatusId,
            description: healthStatusDto.description));
  }

  Future<void> deleteHealthStatus(int id) async {
    await _healthStatusesBox.delete(id);
  }

  Future<void> deleteAllHealthStatuses() async {
    await _healthStatusesBox.clear();
  }

  List<HealthStatusDto> getAllHealthStatuses() {
    return _healthStatusesBox.values.map(healthStatusFromDb).toList();
  }

  HealthStatusDto? getHealthStatusById(int id) {
    final bookDb = _healthStatusesBox.get(id);
    if (bookDb != null) {
      return healthStatusFromDb(bookDb);
    }
    return null;
  }

  HealthStatusDto healthStatusFromDb(HealthStatusModel healthStatusModel) =>
      HealthStatusDto(
        healthStatusId: healthStatusModel.healthStatusId,
        description: healthStatusModel.description,
      );

  HealthStatusModel healthStatusToDb(HealthStatusDto? healthStatusDto) =>
      HealthStatusModel(
          healthStatusId: healthStatusDto?.healthStatusId,
          description: healthStatusDto?.description);
}
