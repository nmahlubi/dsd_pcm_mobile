import 'package:hive_flutter/adapters.dart';

import '../../../model/pcm/medical_health_detail_dto.dart';
import '../../db_model_hive/assessment/medical_health_detail.model.dart';
import '../lookup/health_status_repository.dart';

const String medicalHealthDetailBox = 'medicalHealthDetailBox';

class MedicalHealthDetailRepository {
  MedicalHealthDetailRepository._constructor();
  final _healthStatusRepository = HealthStatusRepository();
  static final MedicalHealthDetailRepository _instance =
      MedicalHealthDetailRepository._constructor();

  factory MedicalHealthDetailRepository() => _instance;

  late Box<MedicalHealthDetailModel> _medicalHealthDetailsBox;

  Future<void> initialize() async {
    await Hive.initFlutter();
    Hive.registerAdapter<MedicalHealthDetailModel>(
        MedicalHealthDetailModelAdapter());
    _medicalHealthDetailsBox =
        await Hive.openBox<MedicalHealthDetailModel>(medicalHealthDetailBox);
  }

  Future<void> saveMedicalHealthDetailItems(
      List<MedicalHealthDetailDto> medicalHealthDetailsDto) async {
    for (var medicalHealthDetailDto in medicalHealthDetailsDto) {
      await _medicalHealthDetailsBox.put(
          medicalHealthDetailDto.healthDetailsId,
          (MedicalHealthDetailModel(
              healthDetailsId: medicalHealthDetailDto.healthDetailsId,
              healthStatusId: medicalHealthDetailDto.healthStatusId,
              injuries: medicalHealthDetailDto.injuries,
              medication: medicalHealthDetailDto.medication,
              allergies: medicalHealthDetailDto.allergies,
              medicalAppointments: medicalHealthDetailDto.medicalAppointments,
              intakeAssessmentId: medicalHealthDetailDto.intakeAssessmentId,
              createdBy: medicalHealthDetailDto.createdBy,
              dateCreated: medicalHealthDetailDto.dateCreated,
              modifiedBy: medicalHealthDetailDto.modifiedBy,
              dateModified: medicalHealthDetailDto.dateModified,
              healthStatusModel: medicalHealthDetailDto.healthStatusDto != null
                  ? _healthStatusRepository
                      .healthStatusToDb(medicalHealthDetailDto.healthStatusDto)
                  : null)));
    }
  }

  Future<void> saveMedicalHealthDetail(
      MedicalHealthDetailDto medicalHealthDetailDto) async {
    await _medicalHealthDetailsBox.put(
        medicalHealthDetailDto.healthDetailsId,
        MedicalHealthDetailModel(
            healthDetailsId: medicalHealthDetailDto.healthDetailsId,
            healthStatusId: medicalHealthDetailDto.healthStatusId,
            injuries: medicalHealthDetailDto.injuries,
            medication: medicalHealthDetailDto.medication,
            allergies: medicalHealthDetailDto.allergies,
            medicalAppointments: medicalHealthDetailDto.medicalAppointments,
            intakeAssessmentId: medicalHealthDetailDto.intakeAssessmentId,
            createdBy: medicalHealthDetailDto.createdBy,
            dateCreated: medicalHealthDetailDto.dateCreated,
            modifiedBy: medicalHealthDetailDto.modifiedBy,
            dateModified: medicalHealthDetailDto.dateModified,
            healthStatusModel: medicalHealthDetailDto.healthStatusDto != null
                ? _healthStatusRepository
                    .healthStatusToDb(medicalHealthDetailDto.healthStatusDto)
                : null));
  }

  MedicalHealthDetailDto? getMedicalHealthDetailsById(int id) {
    final medicalHealthDetailDb = _medicalHealthDetailsBox.get(id);
    if (medicalHealthDetailDb != null) {
      return medicalHealthDetailFromDb(medicalHealthDetailDb);
    }
    return null;
  }

  List<MedicalHealthDetailDto> getAllMedicalHealthDetails() {
    return _medicalHealthDetailsBox.values
        .map(medicalHealthDetailFromDb)
        .toList();
  }

  List<MedicalHealthDetailDto> getAllAcceptedWorklistsByUserId(
      int? intakeAssessmentId) {
    var medicalHealthDetailDtoItems = _medicalHealthDetailsBox.values
        .where((medical) => medical.intakeAssessmentId == intakeAssessmentId)
        .toList();

    return medicalHealthDetailDtoItems.map(medicalHealthDetailFromDb).toList();
  }

  List<MedicalHealthDetailDto> getAllMedicalHealthDetailsByAssessmentId(
      int intakeAssessmentId) {
    return _medicalHealthDetailsBox.values
        .map(medicalHealthDetailFromDb)
        .toList();
  }

  Future<void> deleteMedicalHealthDetails(int id) async {
    await _medicalHealthDetailsBox.delete(id);
  }

  MedicalHealthDetailDto medicalHealthDetailFromDb(
          MedicalHealthDetailModel medicalHealthDetailModel) =>
      MedicalHealthDetailDto(
          healthDetailsId: medicalHealthDetailModel.healthDetailsId,
          healthStatusId: medicalHealthDetailModel.healthStatusId,
          injuries: medicalHealthDetailModel.injuries,
          medication: medicalHealthDetailModel.medication,
          allergies: medicalHealthDetailModel.allergies,
          medicalAppointments: medicalHealthDetailModel.medicalAppointments,
          intakeAssessmentId: medicalHealthDetailModel.intakeAssessmentId,
          createdBy: medicalHealthDetailModel.createdBy,
          dateCreated: medicalHealthDetailModel.dateCreated,
          modifiedBy: medicalHealthDetailModel.modifiedBy,
          dateModified: medicalHealthDetailModel.dateModified,
          healthStatusDto: medicalHealthDetailModel.healthStatusModel != null
              ? _healthStatusRepository.healthStatusFromDb(
                  medicalHealthDetailModel.healthStatusModel!)
              : null);
}
