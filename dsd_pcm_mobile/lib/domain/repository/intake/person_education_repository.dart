import 'package:hive_flutter/adapters.dart';

import '../../../model/intake/person_education_dto.dart';
import '../../db_model_hive/intake/person_education.model.dart';
import '../school/grade_repository.dart';
import '../school/school_repository.dart';

const String personEducationBox = 'personEducationDtoBox';

class PersonEducationRepository {
  PersonEducationRepository._constructor();

  final _schoolRepository = SchoolRepository();
  final _gradeRepository = GradeRepository();

  static final PersonEducationRepository _instance =
      PersonEducationRepository._constructor();

  factory PersonEducationRepository() => _instance;

  late Box<PersonEducationModel> _personEducationsBox;

  Future<void> initialize() async {
    await Hive.initFlutter();
    Hive.registerAdapter<PersonEducationModel>(PersonEducationModelAdapter());
    _personEducationsBox =
        await Hive.openBox<PersonEducationModel>(personEducationBox);
  }

  Future<void> savePersonEducationItems(
      List<PersonEducationDto> personEducationsDto) async {
    for (var personEducationDto in personEducationsDto) {
      await _personEducationsBox.put(
          personEducationDto.personEducationId,
          (PersonEducationModel(
              personEducationId: personEducationDto.personEducationId,
              personId: personEducationDto.personId,
              gradeId: personEducationDto.gradeId,
              schoolId: personEducationDto.schoolId,
              yearCompleted: personEducationDto.yearCompleted,
              dateLastAttended: personEducationDto.dateLastAttended,
              additionalInformation: personEducationDto.additionalInformation,
              dateCreated: personEducationDto.dateCreated,
              createdBy: personEducationDto.createdBy,
              dateLastModified: personEducationDto.dateLastModified,
              modifiedBy: personEducationDto.modifiedBy,
              isActive: personEducationDto.isActive,
              isDeleted: personEducationDto.isDeleted,
              schoolName: personEducationDto.schoolName,
              schoolModel: personEducationDto.schoolDto != null
                  ? _schoolRepository.schoolToDb(personEducationDto.schoolDto)
                  : null,
              gradeModel: personEducationDto.gradeDto != null
                  ? _gradeRepository.gradeToDb(personEducationDto.gradeDto)
                  : null)));
    }
  }

  Future<void> savePersonEducation(
      PersonEducationDto personEducationDto) async {
    await _personEducationsBox.put(
        personEducationDto.personEducationId,
        PersonEducationModel(
            personEducationId: personEducationDto.personEducationId,
            personId: personEducationDto.personId,
            gradeId: personEducationDto.gradeId,
            schoolId: personEducationDto.schoolId,
            yearCompleted: personEducationDto.yearCompleted,
            dateLastAttended: personEducationDto.dateLastAttended,
            additionalInformation: personEducationDto.additionalInformation,
            dateCreated: personEducationDto.dateCreated,
            createdBy: personEducationDto.createdBy,
            dateLastModified: personEducationDto.dateLastModified,
            modifiedBy: personEducationDto.modifiedBy,
            isActive: personEducationDto.isActive,
            isDeleted: personEducationDto.isDeleted,
            schoolName: personEducationDto.schoolName,
            schoolModel: personEducationDto.schoolDto != null
                ? _schoolRepository.schoolToDb(personEducationDto.schoolDto)
                : null,
            gradeModel: personEducationDto.gradeDto != null
                ? _gradeRepository.gradeToDb(personEducationDto.gradeDto)
                : null));
  }

  Future<void> savePersonEducationNewDbRecord(
      PersonEducationDto personEducationDto,
      int? responsePersonEducationId) async {
    await _personEducationsBox.put(
        responsePersonEducationId,
        PersonEducationModel(
            personEducationId: responsePersonEducationId,
            personId: personEducationDto.personId,
            gradeId: personEducationDto.gradeId,
            schoolId: personEducationDto.schoolId,
            yearCompleted: personEducationDto.yearCompleted,
            dateLastAttended: personEducationDto.dateLastAttended,
            additionalInformation: personEducationDto.additionalInformation,
            dateCreated: personEducationDto.dateCreated,
            createdBy: personEducationDto.createdBy,
            dateLastModified: personEducationDto.dateLastModified,
            modifiedBy: personEducationDto.modifiedBy,
            isActive: personEducationDto.isActive,
            isDeleted: personEducationDto.isDeleted,
            schoolName: personEducationDto.schoolName,
            schoolModel: personEducationDto.schoolDto != null
                ? _schoolRepository.schoolToDb(personEducationDto.schoolDto)
                : null,
            gradeModel: personEducationDto.gradeDto != null
                ? _gradeRepository.gradeToDb(personEducationDto.gradeDto)
                : null));
  }

  List<PersonEducationDto> getAllPersonEducationByPersonId(int? personId) {
    var personEducationDtoItems = _personEducationsBox.values
        .where((medical) => medical.personId == personId)
        .toList();
    return personEducationDtoItems.map(personEducationFromDb).toList();
  }

  List<PersonEducationDto> getAllPersonEducations() {
    return _personEducationsBox.values.map(personEducationFromDb).toList();
  }

  PersonEducationDto? getPersonEducationById(int id) {
    final bookDb = _personEducationsBox.get(id);
    if (bookDb != null) {
      return personEducationFromDb(bookDb);
    }
    return null;
  }

  Future<void> deletePersonEducationById(int id) async {
    await _personEducationsBox.delete(id);
  }

  Future<void> deleteAllPersonEducations() async {
    await _personEducationsBox.clear();
  }

  PersonEducationDto personEducationFromDb(
          PersonEducationModel personEducationModel) =>
      PersonEducationDto(
          personEducationId: personEducationModel.personEducationId,
          personId: personEducationModel.personId,
          gradeId: personEducationModel.gradeId,
          schoolId: personEducationModel.schoolId,
          yearCompleted: personEducationModel.yearCompleted,
          dateLastAttended: personEducationModel.dateLastAttended,
          additionalInformation: personEducationModel.additionalInformation,
          dateCreated: personEducationModel.dateCreated,
          createdBy: personEducationModel.createdBy,
          dateLastModified: personEducationModel.dateLastModified,
          modifiedBy: personEducationModel.modifiedBy,
          isActive: personEducationModel.isActive,
          isDeleted: personEducationModel.isDeleted,
          schoolName: personEducationModel.schoolName,
          schoolDto: personEducationModel.schoolModel != null
              ? _schoolRepository
                  .schoolFromDb(personEducationModel.schoolModel!)
              : null,
          gradeDto: personEducationModel.gradeModel != null
              ? _gradeRepository.gradeFromDb(personEducationModel.gradeModel!)
              : null);

  PersonEducationModel personEducationToDb(
          PersonEducationDto? personEducationDto) =>
      PersonEducationModel(
          personEducationId: personEducationDto?.personEducationId,
          personId: personEducationDto?.personId,
          gradeId: personEducationDto?.gradeId,
          schoolId: personEducationDto?.schoolId,
          yearCompleted: personEducationDto?.yearCompleted,
          dateLastAttended: personEducationDto?.dateLastAttended,
          additionalInformation: personEducationDto?.additionalInformation,
          dateCreated: personEducationDto?.dateCreated,
          createdBy: personEducationDto?.createdBy,
          dateLastModified: personEducationDto?.dateLastModified,
          modifiedBy: personEducationDto?.modifiedBy,
          isActive: personEducationDto?.isActive,
          isDeleted: personEducationDto?.isDeleted,
          schoolName: personEducationDto?.schoolName,
          schoolModel: personEducationDto?.schoolDto != null
              ? _schoolRepository.schoolToDb(personEducationDto!.schoolDto)
              : null,
          gradeModel: personEducationDto?.gradeDto != null
              ? _gradeRepository.gradeToDb(personEducationDto!.gradeDto)
              : null);
}
