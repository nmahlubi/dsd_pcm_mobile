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

  Future<void> saveDevelopmentAssessment(
      DevelopmentAssessmentDto developmentAssessmentDto) async {
    await _developmentAssessmentsBox.put(
        developmentAssessmentDto.intakeAssessmentId,
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

  Future<void> deleteDevelopmentAssessmentByAssessmentId(int id) async {
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
