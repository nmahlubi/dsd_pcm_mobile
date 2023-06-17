import 'package:hive_flutter/adapters.dart';

import '../../../model/intake/offence_schedule_dto.dart';
import '../../db_model_hive/intake/offence_schedule.model.dart';

const String offenceScheduleBox = 'offenceScheduleBox';

class OffenceScheduleRepository {
  OffenceScheduleRepository._constructor();

  static final OffenceScheduleRepository _instance =
      OffenceScheduleRepository._constructor();

  factory OffenceScheduleRepository() => _instance;

  late Box<OffenceScheduleModel> _offenceSchedulesBox;

  Future<void> initialize() async {
    await Hive.initFlutter();
    Hive.registerAdapter<OffenceScheduleModel>(OffenceScheduleModelAdapter());
    _offenceSchedulesBox =
        await Hive.openBox<OffenceScheduleModel>(offenceScheduleBox);
  }

  Future<void> saveOffenceScheduleItems(
      List<OffenceScheduleDto> offenceSchedulesDto) async {
    for (var offenceScheduleDto in offenceSchedulesDto) {
      await _offenceSchedulesBox.put(
          offenceScheduleDto.offenceScheduleId,
          (OffenceScheduleModel(
              offenceScheduleId: offenceScheduleDto.offenceScheduleId,
              description: offenceScheduleDto.description)));
    }
  }

  Future<void> saveOffenceSchedule(
      OffenceScheduleDto offenceScheduleDto) async {
    await _offenceSchedulesBox.put(
        offenceScheduleDto.offenceScheduleId,
        OffenceScheduleModel(
            offenceScheduleId: offenceScheduleDto.offenceScheduleId,
            description: offenceScheduleDto.description));
  }

  Future<void> deleteOffenceSchedule(int id) async {
    await _offenceSchedulesBox.delete(id);
  }

  Future<void> deleteAllOffenceSchedules() async {
    await _offenceSchedulesBox.clear();
  }

  List<OffenceScheduleDto> getAllOffenceSchedules() {
    return _offenceSchedulesBox.values.map(offenceScheduleFromDb).toList();
  }

  OffenceScheduleDto? getOffenceScheduleById(int id) {
    final bookDb = _offenceSchedulesBox.get(id);
    if (bookDb != null) {
      return offenceScheduleFromDb(bookDb);
    }
    return null;
  }

  OffenceScheduleDto offenceScheduleFromDb(
          OffenceScheduleModel? offenceScheduleModel) =>
      OffenceScheduleDto(
          offenceScheduleId: offenceScheduleModel?.offenceScheduleId,
          description: offenceScheduleModel?.description);

  OffenceScheduleModel offenceScheduleToDb(
          OffenceScheduleDto? offenceScheduleDto) =>
      OffenceScheduleModel(
          offenceScheduleId: offenceScheduleDto?.offenceScheduleId,
          description: offenceScheduleDto?.description);
}
