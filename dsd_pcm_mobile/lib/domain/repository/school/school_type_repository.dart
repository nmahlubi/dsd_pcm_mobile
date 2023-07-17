import 'package:hive_flutter/adapters.dart';

import '../../../model/intake/school_type_dto.dart';
import '../../db_model_hive/school/school_type.model.dart';

const String schoolTypeBox = 'schoolTypeBox';

class SchoolTypeRepository {
  SchoolTypeRepository._constructor();

  static final SchoolTypeRepository _instance =
      SchoolTypeRepository._constructor();

  factory SchoolTypeRepository() => _instance;

  late Box<SchoolTypeModel> _schoolTypesBox;

  Future<void> initialize() async {
    await Hive.initFlutter();
    Hive.registerAdapter<SchoolTypeModel>(SchoolTypeModelAdapter());
    _schoolTypesBox = await Hive.openBox<SchoolTypeModel>(schoolTypeBox);
  }

  Future<void> saveSchoolTypeItems(List<SchoolTypeDto> schoolTypesDto) async {
    for (var schoolTypeDto in schoolTypesDto) {
      await _schoolTypesBox.put(
          schoolTypeDto.schoolTypeId,
          (SchoolTypeModel(
              schoolTypeId: schoolTypeDto.schoolTypeId,
              description: schoolTypeDto.description)));
    }
  }

  Future<void> saveSchoolType(SchoolTypeDto schoolTypeDto) async {
    await _schoolTypesBox.put(
        schoolTypeDto.schoolTypeId,
        SchoolTypeModel(
            schoolTypeId: schoolTypeDto.schoolTypeId,
            description: schoolTypeDto.description));
  }

  Future<void> deleteSchoolType(int id) async {
    await _schoolTypesBox.delete(id);
  }

  Future<void> deleteAllSchoolTypes() async {
    await _schoolTypesBox.clear();
  }

  List<SchoolTypeDto> getAllSchoolTypes() {
    return _schoolTypesBox.values.map(schoolTypeFromDb).toList();
  }

  SchoolTypeDto? getSchoolTypeById(int id) {
    final bookDb = _schoolTypesBox.get(id);
    if (bookDb != null) {
      return schoolTypeFromDb(bookDb);
    }
    return null;
  }

  SchoolTypeDto schoolTypeFromDb(SchoolTypeModel schoolTypeModel) =>
      SchoolTypeDto(
        schoolTypeId: schoolTypeModel.schoolTypeId,
        description: schoolTypeModel.description,
      );

  SchoolTypeModel schoolTypeToDb(SchoolTypeDto? schoolTypeDto) =>
      SchoolTypeModel(
          schoolTypeId: schoolTypeDto?.schoolTypeId,
          description: schoolTypeDto?.description);
}
