import 'package:hive_flutter/adapters.dart';

import '../../../model/pcm/development_assessment_dto.dart';
import '../../db_model_hive/assessment/development_assessment.model.dart';

const String developmentAssessmentBox = 'developmentAssessmentBox';

class DevelopmentAssessmentRepository {
  DevelopmentAssessmentRepository._constructor();

  static final DevelopmentAssessmentRepository _instance =
      DevelopmentAssessmentRepository._constructor();
  factory DevelopmentAssessmentRepository() => _instance;

  late Box<DevelopmentAssessmentModel> _developmentAssessmentsBox;

  Future<void> initialize() async {
    await Hive.initFlutter();
    Hive.registerAdapter<DevelopmentAssessmentModel>(
        DevelopmentAssessmentModelAdapter());
    _developmentAssessmentsBox = await Hive.openBox<DevelopmentAssessmentModel>(
        developmentAssessmentBox);
  }

  Future<void> saveDevelopmentAssessmentItems(
      List<DevelopmentAssessmentDto> developmentAssessmentsDto) async {
    for (var developmentAssessmentDto in developmentAssessmentsDto) {
      await _developmentAssessmentsBox.put(
          developmentAssessmentDto.developmentId,
          (DevelopmentAssessmentModel(
              developmentId: developmentAssessmentDto.developmentId,
              intakeAssessmentId: developmentAssessmentDto.intakeAssessmentId,
              belonging: developmentAssessmentDto.belonging,
              mastery: developmentAssessmentDto.mastery,
              independence: developmentAssessmentDto.independence,
              generosity: developmentAssessmentDto.generosity,
              evaluation: developmentAssessmentDto.evaluation,
              createdBy: developmentAssessmentDto.createdBy,
              modifiedBy: developmentAssessmentDto.modifiedBy,
              dateCreated: developmentAssessmentDto.dateCreated,
              dateModified: developmentAssessmentDto.dateModified)));
    }
  }

  Future<void> saveDevelopmentAssessmentNewRecord(
      DevelopmentAssessmentDto developmentAssessmentDto,
      int? developmentId) async {
    await _developmentAssessmentsBox.put(
        developmentId,
        DevelopmentAssessmentModel(
            developmentId: developmentId,
            intakeAssessmentId: developmentAssessmentDto.intakeAssessmentId,
            belonging: developmentAssessmentDto.belonging,
            mastery: developmentAssessmentDto.mastery,
            independence: developmentAssessmentDto.independence,
            generosity: developmentAssessmentDto.generosity,
            evaluation: developmentAssessmentDto.evaluation,
            createdBy: developmentAssessmentDto.createdBy,
            modifiedBy: developmentAssessmentDto.modifiedBy,
            dateCreated: developmentAssessmentDto.dateCreated,
            dateModified: developmentAssessmentDto.dateModified));
  }

  Future<void> saveDevelopmentAssessment(
      DevelopmentAssessmentDto developmentAssessmentDto) async {
    await _developmentAssessmentsBox.put(
        developmentAssessmentDto.developmentId,
        DevelopmentAssessmentModel(
            developmentId: developmentAssessmentDto.developmentId,
            intakeAssessmentId: developmentAssessmentDto.intakeAssessmentId,
            belonging: developmentAssessmentDto.belonging,
            mastery: developmentAssessmentDto.mastery,
            independence: developmentAssessmentDto.independence,
            generosity: developmentAssessmentDto.generosity,
            evaluation: developmentAssessmentDto.evaluation,
            createdBy: developmentAssessmentDto.createdBy,
            modifiedBy: developmentAssessmentDto.modifiedBy,
            dateCreated: developmentAssessmentDto.dateCreated,
            dateModified: developmentAssessmentDto.dateModified));
  }

  Future<void> deleteDevelopmentAssessment(int id) async {
    await _developmentAssessmentsBox.delete(id);
  }

  Future<void> deleteAllDevelopmentAssessments() async {
    await _developmentAssessmentsBox.clear();
  }

  List<DevelopmentAssessmentDto> getAllDevelopmentAssessments() {
    return _developmentAssessmentsBox.values
        .map(developmentAssessmentFromDb)
        .toList();
  }

  List<DevelopmentAssessmentDto> getAllDevelopmentAssessmentsByAssessmentId(
      int? intakeAssessmentId) {
    var developmentAssessmentDtoItems = _developmentAssessmentsBox.values
        .where((medical) => medical.intakeAssessmentId == intakeAssessmentId)
        .toList();
    return developmentAssessmentDtoItems
        .map(developmentAssessmentFromDb)
        .toList();
  }

  DevelopmentAssessmentDto? getDevelopmentAssessmentById(int id) {
    final bookDb = _developmentAssessmentsBox.get(id);
    if (bookDb != null) {
      return developmentAssessmentFromDb(bookDb);
    }
    return null;
  }

  DevelopmentAssessmentDto developmentAssessmentFromDb(
          DevelopmentAssessmentModel developmentAssessmentModel) =>
      DevelopmentAssessmentDto(
          developmentId: developmentAssessmentModel.developmentId,
          intakeAssessmentId: developmentAssessmentModel.intakeAssessmentId,
          belonging: developmentAssessmentModel.belonging,
          mastery: developmentAssessmentModel.mastery,
          independence: developmentAssessmentModel.independence,
          generosity: developmentAssessmentModel.generosity,
          evaluation: developmentAssessmentModel.evaluation,
          createdBy: developmentAssessmentModel.createdBy,
          modifiedBy: developmentAssessmentModel.modifiedBy,
          dateCreated: developmentAssessmentModel.dateCreated,
          dateModified: developmentAssessmentModel.dateModified);

  DevelopmentAssessmentModel developmentAssessmentToDb(
          DevelopmentAssessmentDto? developmentAssessmentDto) =>
      DevelopmentAssessmentModel(
          developmentId: developmentAssessmentDto!.developmentId,
          intakeAssessmentId: developmentAssessmentDto.intakeAssessmentId,
          belonging: developmentAssessmentDto.belonging,
          mastery: developmentAssessmentDto.mastery,
          independence: developmentAssessmentDto.independence,
          generosity: developmentAssessmentDto.generosity,
          evaluation: developmentAssessmentDto.evaluation,
          createdBy: developmentAssessmentDto.createdBy,
          modifiedBy: developmentAssessmentDto.modifiedBy,
          dateCreated: developmentAssessmentDto.dateCreated,
          dateModified: developmentAssessmentDto.dateModified);
}
