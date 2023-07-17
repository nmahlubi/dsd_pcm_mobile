import 'package:hive_flutter/adapters.dart';

import '../../../model/intake/school_dto.dart';
import '../../db_model_hive/school/school.model.dart';
import 'school_type_repository.dart';

const String schoolBox = 'schoolBox';

class SchoolRepository {
  SchoolRepository._constructor();

  final _schoolTypeRepository = SchoolTypeRepository();

  static final SchoolRepository _instance = SchoolRepository._constructor();

  factory SchoolRepository() => _instance;

  late Box<SchoolModel> _schoolsBox;

  Future<void> initialize() async {
    await Hive.initFlutter();
    Hive.registerAdapter<SchoolModel>(SchoolModelAdapter());
    _schoolsBox = await Hive.openBox<SchoolModel>(schoolBox);
  }

  Future<void> saveSchoolItems(List<SchoolDto> schoolsDto) async {
    for (var schoolDto in schoolsDto) {
      await _schoolsBox.put(
          schoolDto.schoolId,
          (SchoolModel(
              schoolId: schoolDto.schoolId,
              schoolTypeId: schoolDto.schoolTypeId,
              schoolName: schoolDto.schoolName,
              contactPerson: schoolDto.contactPerson,
              telephoneNumber: schoolDto.telephoneNumber,
              cellphoneNumber: schoolDto.cellphoneNumber,
              faxNumber: schoolDto.faxNumber,
              emailAddress: schoolDto.emailAddress,
              dateCreated: schoolDto.dateCreated,
              createdBy: schoolDto.createdBy,
              dateLastModified: schoolDto.dateLastModified,
              modifiedBy: schoolDto.modifiedBy,
              isActive: schoolDto.isActive,
              isDeleted: schoolDto.isDeleted,
              natEmis: schoolDto.natEmis,
              schoolTypeModel: schoolDto.schoolTypeDto != null
                  ? _schoolTypeRepository
                      .schoolTypeToDb(schoolDto.schoolTypeDto)
                  : null)));
    }
  }

  List<SchoolDto> getAllSchools() {
    return _schoolsBox.values.map(schoolFromDb).toList();
  }

  List<SchoolDto> getSchoolsByType(int? schoolTypeId) {
    var schoolsDtoItems = _schoolsBox.values
        .where((school) => school.schoolTypeId == schoolTypeId)
        .toList();
    return schoolsDtoItems.map(schoolFromDb).toList();
  }

  SchoolDto? getSchoolById(int id) {
    final bookDb = _schoolsBox.get(id);
    if (bookDb != null) {
      return schoolFromDb(bookDb);
    }
    return null;
  }

  Future<void> deleteSchool(int id) async {
    await _schoolsBox.delete(id);
  }

  Future<void> deleteAllSchools() async {
    await _schoolsBox.clear();
  }

  Future<void> deleteSchoolByType(int? schoolTypeId) async {
    var schoolsDtoItems = _schoolsBox.values
        .where((school) => school.schoolTypeId == schoolTypeId)
        .toList();
    for (var schoolDto in schoolsDtoItems) {
      await _schoolsBox.delete(schoolDto.schoolId);
    }
  }

  SchoolDto schoolFromDb(SchoolModel schoolModel) => SchoolDto(
      schoolId: schoolModel.schoolId,
      schoolTypeId: schoolModel.schoolTypeId,
      schoolName: schoolModel.schoolName,
      contactPerson: schoolModel.contactPerson,
      telephoneNumber: schoolModel.telephoneNumber,
      cellphoneNumber: schoolModel.cellphoneNumber,
      faxNumber: schoolModel.faxNumber,
      emailAddress: schoolModel.emailAddress,
      dateCreated: schoolModel.dateCreated,
      createdBy: schoolModel.createdBy,
      dateLastModified: schoolModel.dateLastModified,
      modifiedBy: schoolModel.modifiedBy,
      isActive: schoolModel.isActive,
      isDeleted: schoolModel.isDeleted,
      natEmis: schoolModel.natEmis,
      schoolTypeDto: schoolModel.schoolTypeModel != null
          ? _schoolTypeRepository.schoolTypeFromDb(schoolModel.schoolTypeModel!)
          : null);

  SchoolModel schoolToDb(SchoolDto? schoolDto) => SchoolModel(
      schoolId: schoolDto!.schoolId,
      schoolTypeId: schoolDto.schoolTypeId,
      schoolName: schoolDto.schoolName,
      contactPerson: schoolDto.contactPerson,
      telephoneNumber: schoolDto.telephoneNumber,
      cellphoneNumber: schoolDto.cellphoneNumber,
      faxNumber: schoolDto.faxNumber,
      emailAddress: schoolDto.emailAddress,
      dateCreated: schoolDto.dateCreated,
      createdBy: schoolDto.createdBy,
      dateLastModified: schoolDto.dateLastModified,
      modifiedBy: schoolDto.modifiedBy,
      isActive: schoolDto.isActive,
      isDeleted: schoolDto.isDeleted,
      natEmis: schoolDto.natEmis,
      schoolTypeModel: schoolDto.schoolTypeDto != null
          ? _schoolTypeRepository.schoolTypeToDb(schoolDto.schoolTypeDto)
          : null);
}
