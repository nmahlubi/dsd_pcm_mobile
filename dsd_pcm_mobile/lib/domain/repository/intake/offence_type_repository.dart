import 'package:hive_flutter/adapters.dart';

import '../../../model/intake/offence_type_dto.dart';
import '../../db_model_hive/intake/offence_type.model.dart';

const String offenceTypeBox = 'offenceTypeBox';

class OffenceTypeRepository {
  OffenceTypeRepository._constructor();

  static final OffenceTypeRepository _instance =
      OffenceTypeRepository._constructor();

  factory OffenceTypeRepository() => _instance;

  late Box<OffenceTypeModel> _offenceTypesBox;

  Future<void> initialize() async {
    await Hive.initFlutter();
    Hive.registerAdapter<OffenceTypeModel>(OffenceTypeModelAdapter());
    _offenceTypesBox = await Hive.openBox<OffenceTypeModel>(offenceTypeBox);
  }

  Future<void> saveOffenceTypeItems(
      List<OffenceTypeDto> offenceTypesDto) async {
    for (var offenceTypeDto in offenceTypesDto) {
      await _offenceTypesBox.put(
          offenceTypeDto.offenceTypeId,
          (OffenceTypeModel(
              offenceTypeId: offenceTypeDto.offenceTypeId,
              description: offenceTypeDto.description)));
    }
  }

  Future<void> saveOffenceType(OffenceTypeDto offenceTypeDto) async {
    await _offenceTypesBox.put(
        offenceTypeDto.offenceTypeId,
        OffenceTypeModel(
            offenceTypeId: offenceTypeDto.offenceTypeId,
            description: offenceTypeDto.description));
  }

  Future<void> deleteOffenceType(int id) async {
    await _offenceTypesBox.delete(id);
  }

  Future<void> deleteAllOffenceTypes() async {
    await _offenceTypesBox.clear();
  }

  List<OffenceTypeDto> getAllOffenceTypes() {
    return _offenceTypesBox.values.map(offenceTypeFromDb).toList();
  }

  OffenceTypeDto? getOffenceTypeById(int id) {
    final bookDb = _offenceTypesBox.get(id);
    if (bookDb != null) {
      return offenceTypeFromDb(bookDb);
    }
    return null;
  }

  OffenceTypeDto offenceTypeFromDb(OffenceTypeModel? offenceTypeModel) =>
      OffenceTypeDto(
          offenceTypeId: offenceTypeModel?.offenceTypeId,
          description: offenceTypeModel?.description);

  OffenceTypeModel offenceTypeToDb(OffenceTypeDto? offenceTypeDto) =>
      OffenceTypeModel(
          offenceTypeId: offenceTypeDto?.offenceTypeId,
          description: offenceTypeDto?.description);
}
