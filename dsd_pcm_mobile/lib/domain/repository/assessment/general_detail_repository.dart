import 'package:hive_flutter/adapters.dart';

import '../../../model/pcm/general_detail_dto.dart';
import '../../db_model_hive/assessment/general_detail.model.dart';

const String generalDetailBox = 'generalDetailBox';

class GeneralDetailRepository {
  GeneralDetailRepository._constructor();

  static final GeneralDetailRepository _instance =
      GeneralDetailRepository._constructor();
  factory GeneralDetailRepository() => _instance;

  late Box<GeneralDetailModel> _generalDetailsBox;

  Future<void> initialize() async {
    await Hive.initFlutter();
    Hive.registerAdapter<GeneralDetailModel>(GeneralDetailModelAdapter());
    _generalDetailsBox =
        await Hive.openBox<GeneralDetailModel>(generalDetailBox);
  }

  Future<void> saveGeneralDetailItems(
      List<GeneralDetailDto> generalDetailsDto) async {
    for (var generalDetailDto in generalDetailsDto) {
      await _generalDetailsBox.put(
          generalDetailDto.generalDetailsId,
          (GeneralDetailModel(
              generalDetailsId: generalDetailDto.generalDetailsId,
              intakeAssessmentId: generalDetailDto.intakeAssessmentId,
              consultedSources: generalDetailDto.consultedSources,
              traceEfforts: generalDetailDto.traceEfforts,
              assessmentDate: generalDetailDto.assessmentDate,
              assessmentTime: generalDetailDto.assessmentTime,
              additionalInfo: generalDetailDto.additionalInfo,
              isVerifiedBySupervisor: generalDetailDto.isVerifiedBySupervisor,
              commentsBySupervisor: generalDetailDto.commentsBySupervisor,
              createdBy: generalDetailDto.createdBy,
              modifiedBy: generalDetailDto.modifiedBy,
              dateCreated: generalDetailDto.dateCreated,
              dateModified: generalDetailDto.dateModified)));
    }
  }

  Future<void> saveGeneralDetailNewRecord(
      GeneralDetailDto generalDetailDto, int? generalDetailsId) async {
    await _generalDetailsBox.put(
        generalDetailsId,
        GeneralDetailModel(
            generalDetailsId: generalDetailDto.generalDetailsId,
            intakeAssessmentId: generalDetailDto.intakeAssessmentId,
            consultedSources: generalDetailDto.consultedSources,
            traceEfforts: generalDetailDto.traceEfforts,
            assessmentDate: generalDetailDto.assessmentDate,
            assessmentTime: generalDetailDto.assessmentTime,
            additionalInfo: generalDetailDto.additionalInfo,
            isVerifiedBySupervisor: generalDetailDto.isVerifiedBySupervisor,
            commentsBySupervisor: generalDetailDto.commentsBySupervisor,
            createdBy: generalDetailDto.createdBy,
            modifiedBy: generalDetailDto.modifiedBy,
            dateCreated: generalDetailDto.dateCreated,
            dateModified: generalDetailDto.dateModified));
  }

  Future<void> saveGeneralDetail(GeneralDetailDto generalDetailDto) async {
    await _generalDetailsBox.put(
        generalDetailDto.generalDetailsId,
        GeneralDetailModel(
            generalDetailsId: generalDetailDto.generalDetailsId,
            intakeAssessmentId: generalDetailDto.intakeAssessmentId,
            consultedSources: generalDetailDto.consultedSources,
            traceEfforts: generalDetailDto.traceEfforts,
            assessmentDate: generalDetailDto.assessmentDate,
            assessmentTime: generalDetailDto.assessmentTime,
            additionalInfo: generalDetailDto.additionalInfo,
            isVerifiedBySupervisor: generalDetailDto.isVerifiedBySupervisor,
            commentsBySupervisor: generalDetailDto.commentsBySupervisor,
            createdBy: generalDetailDto.createdBy,
            modifiedBy: generalDetailDto.modifiedBy,
            dateCreated: generalDetailDto.dateCreated,
            dateModified: generalDetailDto.dateModified));
  }

  Future<void> deleteGeneralDetail(int id) async {
    await _generalDetailsBox.delete(id);
  }

  Future<void> deleteAllGeneralDetails() async {
    await _generalDetailsBox.clear();
  }

  List<GeneralDetailDto> getAllGeneralDetails() {
    return _generalDetailsBox.values.map(generalDetailFromDb).toList();
  }

  List<GeneralDetailDto> getAllGeneralDetailsByAssessmentId(
      int? intakeAssessmentId) {
    var generalDetailDtoItems = _generalDetailsBox.values
        .where((medical) => medical.intakeAssessmentId == intakeAssessmentId)
        .toList();
    return generalDetailDtoItems.map(generalDetailFromDb).toList();
  }

  GeneralDetailDto? getGeneralDetailById(int id) {
    final bookDb = _generalDetailsBox.get(id);
    if (bookDb != null) {
      return generalDetailFromDb(bookDb);
    }
    return null;
  }

  GeneralDetailDto generalDetailFromDb(GeneralDetailModel generalDetailModel) =>
      GeneralDetailDto(
          generalDetailsId: generalDetailModel.generalDetailsId,
          intakeAssessmentId: generalDetailModel.intakeAssessmentId,
          consultedSources: generalDetailModel.consultedSources,
          traceEfforts: generalDetailModel.traceEfforts,
          assessmentDate: generalDetailModel.assessmentDate,
          assessmentTime: generalDetailModel.assessmentTime,
          additionalInfo: generalDetailModel.additionalInfo,
          isVerifiedBySupervisor: generalDetailModel.isVerifiedBySupervisor,
          commentsBySupervisor: generalDetailModel.commentsBySupervisor,
          createdBy: generalDetailModel.createdBy,
          modifiedBy: generalDetailModel.modifiedBy,
          dateCreated: generalDetailModel.dateCreated,
          dateModified: generalDetailModel.dateModified);

  GeneralDetailModel generalDetailToDb(GeneralDetailDto? generalDetailDto) =>
      GeneralDetailModel(
          generalDetailsId: generalDetailDto!.generalDetailsId,
          intakeAssessmentId: generalDetailDto.intakeAssessmentId,
          consultedSources: generalDetailDto.consultedSources,
          traceEfforts: generalDetailDto.traceEfforts,
          assessmentDate: generalDetailDto.assessmentDate,
          assessmentTime: generalDetailDto.assessmentTime,
          additionalInfo: generalDetailDto.additionalInfo,
          isVerifiedBySupervisor: generalDetailDto.isVerifiedBySupervisor,
          commentsBySupervisor: generalDetailDto.commentsBySupervisor,
          createdBy: generalDetailDto.createdBy,
          modifiedBy: generalDetailDto.modifiedBy,
          dateCreated: generalDetailDto.dateCreated,
          dateModified: generalDetailDto.dateModified);
}
