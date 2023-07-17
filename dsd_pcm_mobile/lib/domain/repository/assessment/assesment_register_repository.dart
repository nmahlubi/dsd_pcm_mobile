import 'package:hive_flutter/adapters.dart';

import '../../../model/pcm/assesment_register_dto.dart';
import '../../db_model_hive/assessment/assesment_register.model.dart';
import '../lookup/form_of_notification_repository.dart';

const String assesmentRegisterBox = 'assesmentRegisterBox';

class AssesmentRegisterRepository {
  AssesmentRegisterRepository._constructor();

  static final AssesmentRegisterRepository _instance =
      AssesmentRegisterRepository._constructor();
  final _formOfNotificationRepository = FormOfNotificationRepository();
  factory AssesmentRegisterRepository() => _instance;

  late Box<AssesmentRegisterModel> _assesmentRegistersBox;

  Future<void> initialize() async {
    await Hive.initFlutter();
    Hive.registerAdapter<AssesmentRegisterModel>(
        AssesmentRegisterModelAdapter());
    _assesmentRegistersBox =
        await Hive.openBox<AssesmentRegisterModel>(assesmentRegisterBox);
  }

  Future<void> saveAssesmentRegisterAfterOnline(
      AssesmentRegisterDto assesmentRegisterDto,
      int assessmentRegisterId) async {
    await _assesmentRegistersBox.put(
        assesmentRegisterDto.intakeAssessmentId,
        AssesmentRegisterModel(
            assesmentRegisterId: assessmentRegisterId,
            pcmCaseId: assesmentRegisterDto.pcmCaseId,
            intakeAssessmentId: assesmentRegisterDto.intakeAssessmentId,
            probationOfficerId: assesmentRegisterDto.probationOfficerId,
            assessedBy: assesmentRegisterDto.assessedBy,
            assessmentDate: assesmentRegisterDto.assessmentDate,
            assessmentTime: assesmentRegisterDto.assessmentTime,
            formOfNotificationId: assesmentRegisterDto.formOfNotificationId,
            townId: assesmentRegisterDto.townId,
            createdBy: assesmentRegisterDto.createdBy,
            modifiedBy: assesmentRegisterDto.modifiedBy,
            dateCreated: assesmentRegisterDto.dateCreated,
            dateModified: assesmentRegisterDto.dateModified,
            formOfNotificationModel:
                assesmentRegisterDto.formOfNotificationDto != null
                    ? _formOfNotificationRepository.FormOfNotificationToDb(
                        assesmentRegisterDto.formOfNotificationDto)
                    : null));
  }

  Future<void> saveAssesmentRegister(
      AssesmentRegisterDto assesmentRegisterDto) async {
    await _assesmentRegistersBox.put(
        assesmentRegisterDto.intakeAssessmentId,
        AssesmentRegisterModel(
            assesmentRegisterId: assesmentRegisterDto.assesmentRegisterId,
            pcmCaseId: assesmentRegisterDto.pcmCaseId,
            intakeAssessmentId: assesmentRegisterDto.intakeAssessmentId,
            probationOfficerId: assesmentRegisterDto.probationOfficerId,
            assessedBy: assesmentRegisterDto.assessedBy,
            assessmentDate: assesmentRegisterDto.assessmentDate,
            assessmentTime: assesmentRegisterDto.assessmentTime,
            formOfNotificationId: assesmentRegisterDto.formOfNotificationId,
            townId: assesmentRegisterDto.townId,
            createdBy: assesmentRegisterDto.createdBy,
            modifiedBy: assesmentRegisterDto.modifiedBy,
            dateCreated: assesmentRegisterDto.dateCreated,
            dateModified: assesmentRegisterDto.dateModified,
            formOfNotificationModel:
                assesmentRegisterDto.formOfNotificationDto != null
                    ? _formOfNotificationRepository.FormOfNotificationToDb(
                        assesmentRegisterDto.formOfNotificationDto)
                    : null));
  }

  Future<void> deleteAssesmentRegister(int id) async {
    await _assesmentRegistersBox.delete(id);
  }

  AssesmentRegisterDto? getAssesmentRegisterByAssessmentId(int id) {
    final bookDb = _assesmentRegistersBox.get(id);
    if (bookDb != null) {
      return assesmentRegisterFromDb(bookDb);
    }
    return null;
  }

  AssesmentRegisterDto assesmentRegisterFromDb(
          AssesmentRegisterModel assesmentRegisterModel) =>
      AssesmentRegisterDto(
          assesmentRegisterId: assesmentRegisterModel.assesmentRegisterId,
          pcmCaseId: assesmentRegisterModel.pcmCaseId,
          intakeAssessmentId: assesmentRegisterModel.intakeAssessmentId,
          probationOfficerId: assesmentRegisterModel.probationOfficerId,
          assessedBy: assesmentRegisterModel.assessedBy,
          assessmentDate: assesmentRegisterModel.assessmentDate,
          assessmentTime: assesmentRegisterModel.assessmentTime,
          formOfNotificationId: assesmentRegisterModel.formOfNotificationId,
          townId: assesmentRegisterModel.townId,
          createdBy: assesmentRegisterModel.createdBy,
          modifiedBy: assesmentRegisterModel.modifiedBy,
          dateCreated: assesmentRegisterModel.dateCreated,
          dateModified: assesmentRegisterModel.dateModified,
          formOfNotificationDto:
              assesmentRegisterModel.formOfNotificationModel != null
                  ? _formOfNotificationRepository.formOfNotificationFromDb(
                      assesmentRegisterModel.formOfNotificationModel!)
                  : null);

  AssesmentRegisterModel assesmentRegisterToDb(
          AssesmentRegisterDto? assesmentRegisterDto) =>
      AssesmentRegisterModel(
          assesmentRegisterId: assesmentRegisterDto?.assesmentRegisterId,
          pcmCaseId: assesmentRegisterDto?.pcmCaseId,
          intakeAssessmentId: assesmentRegisterDto?.intakeAssessmentId,
          probationOfficerId: assesmentRegisterDto?.probationOfficerId,
          assessedBy: assesmentRegisterDto?.assessedBy,
          assessmentDate: assesmentRegisterDto?.assessmentDate,
          assessmentTime: assesmentRegisterDto?.assessmentTime,
          formOfNotificationId: assesmentRegisterDto?.formOfNotificationId,
          townId: assesmentRegisterDto?.townId,
          createdBy: assesmentRegisterDto?.createdBy,
          modifiedBy: assesmentRegisterDto?.modifiedBy,
          dateCreated: assesmentRegisterDto?.dateCreated,
          dateModified: assesmentRegisterDto?.dateModified,
          formOfNotificationModel:
              assesmentRegisterDto?.formOfNotificationDto != null
                  ? _formOfNotificationRepository.FormOfNotificationToDb(
                      assesmentRegisterDto?.formOfNotificationDto)
                  : null);
}
