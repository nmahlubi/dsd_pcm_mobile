import 'package:hive_flutter/adapters.dart';

import '../../../model/pcm/offence_detail_dto.dart';
import '../../db_model_hive/assessment/offence_detail.model.dart';
import '../intake/offence_category_repository.dart';
import '../intake/offence_schedule_repository.dart';
import '../intake/offence_type_repository.dart';

const String offenceDetailBox = 'offenceDetailBox';

class OffenceDetailRepository {
  OffenceDetailRepository._constructor();

  static final OffenceDetailRepository _instance =
      OffenceDetailRepository._constructor();
  final _offenceTypeRepository = OffenceTypeRepository();
  final _offenceCategoryRepository = OffenceCategoryRepository();
  final _offenceScheduleRepository = OffenceScheduleRepository();
  factory OffenceDetailRepository() => _instance;

  late Box<OffenceDetailModel> _offenceDetailsBox;

  Future<void> initialize() async {
    await Hive.initFlutter();
    Hive.registerAdapter<OffenceDetailModel>(OffenceDetailModelAdapter());
    _offenceDetailsBox =
        await Hive.openBox<OffenceDetailModel>(offenceDetailBox);
  }

  Future<void> saveOffenceDetailItems(
      List<OffenceDetailDto> offenceDetailsDto) async {
    for (var offenceDetailDto in offenceDetailsDto) {
      await _offenceDetailsBox.put(
          offenceDetailDto.pcmOffenceId,
          (OffenceDetailModel(
              pcmOffenceId: offenceDetailDto.pcmOffenceId,
              pcmCaseId: offenceDetailDto.pcmCaseId,
              intakeAssessmentId: offenceDetailDto.intakeAssessmentId,
              offenceTypeId: offenceDetailDto.offenceTypeId,
              offenceCategoryId: offenceDetailDto.offenceCategoryId,
              offenceScheduleId: offenceDetailDto.offenceScheduleId,
              offenceCircumstance: offenceDetailDto.offenceCircumstance,
              valueOfGoods: offenceDetailDto.valueOfGoods,
              valueRecovered: offenceDetailDto.valueRecovered,
              isChildResponsible: offenceDetailDto.isChildResponsible,
              responsibilityDetails: offenceDetailDto.responsibilityDetails,
              createdBy: offenceDetailDto.createdBy,
              dateCreated: offenceDetailDto.dateCreated,
              modifiedBy: offenceDetailDto.modifiedBy,
              dateModified: offenceDetailDto.dateModified,
              offenceTypeModel: offenceDetailDto.offenceTypeDto != null
                  ? _offenceTypeRepository
                      .offenceTypeToDb(offenceDetailDto.offenceTypeDto)
                  : null,
              offenceScheduleModel: offenceDetailDto.offenceScheduleDto != null
                  ? _offenceScheduleRepository
                      .offenceScheduleToDb(offenceDetailDto.offenceScheduleDto)
                  : null,
              offenceCategoryModel: offenceDetailDto.offenceCategoryDto != null
                  ? _offenceCategoryRepository
                      .offenceCategoryToDb(offenceDetailDto.offenceCategoryDto)
                  : null)));
    }
  }

  Future<void> saveOffenceDetailNewRecord(
      OffenceDetailDto offenceDetailDto, int? pcmOffenceId) async {
    await _offenceDetailsBox.put(
        pcmOffenceId,
        OffenceDetailModel(
            pcmOffenceId: pcmOffenceId,
            pcmCaseId: offenceDetailDto.pcmCaseId,
            intakeAssessmentId: offenceDetailDto.intakeAssessmentId,
            offenceTypeId: offenceDetailDto.offenceTypeId,
            offenceCategoryId: offenceDetailDto.offenceCategoryId,
            offenceScheduleId: offenceDetailDto.offenceScheduleId,
            offenceCircumstance: offenceDetailDto.offenceCircumstance,
            valueOfGoods: offenceDetailDto.valueOfGoods,
            valueRecovered: offenceDetailDto.valueRecovered,
            isChildResponsible: offenceDetailDto.isChildResponsible,
            responsibilityDetails: offenceDetailDto.responsibilityDetails,
            createdBy: offenceDetailDto.createdBy,
            dateCreated: offenceDetailDto.dateCreated,
            modifiedBy: offenceDetailDto.modifiedBy,
            dateModified: offenceDetailDto.dateModified,
            offenceTypeModel: offenceDetailDto.offenceTypeDto != null
                ? _offenceTypeRepository
                    .offenceTypeToDb(offenceDetailDto.offenceTypeDto)
                : null,
            offenceScheduleModel: offenceDetailDto.offenceScheduleDto != null
                ? _offenceScheduleRepository
                    .offenceScheduleToDb(offenceDetailDto.offenceScheduleDto)
                : null,
            offenceCategoryModel: offenceDetailDto.offenceCategoryDto != null
                ? _offenceCategoryRepository
                    .offenceCategoryToDb(offenceDetailDto.offenceCategoryDto)
                : null));
  }

  Future<void> saveOffenceDetail(OffenceDetailDto offenceDetailDto) async {
    await _offenceDetailsBox.put(
        offenceDetailDto.pcmOffenceId,
        OffenceDetailModel(
            pcmOffenceId: offenceDetailDto.pcmOffenceId,
            pcmCaseId: offenceDetailDto.pcmCaseId,
            intakeAssessmentId: offenceDetailDto.intakeAssessmentId,
            offenceTypeId: offenceDetailDto.offenceTypeId,
            offenceCategoryId: offenceDetailDto.offenceCategoryId,
            offenceScheduleId: offenceDetailDto.offenceScheduleId,
            offenceCircumstance: offenceDetailDto.offenceCircumstance,
            valueOfGoods: offenceDetailDto.valueOfGoods,
            valueRecovered: offenceDetailDto.valueRecovered,
            isChildResponsible: offenceDetailDto.isChildResponsible,
            responsibilityDetails: offenceDetailDto.responsibilityDetails,
            createdBy: offenceDetailDto.createdBy,
            dateCreated: offenceDetailDto.dateCreated,
            modifiedBy: offenceDetailDto.modifiedBy,
            dateModified: offenceDetailDto.dateModified,
            offenceTypeModel: offenceDetailDto.offenceTypeDto != null
                ? _offenceTypeRepository
                    .offenceTypeToDb(offenceDetailDto.offenceTypeDto)
                : null,
            offenceScheduleModel: offenceDetailDto.offenceScheduleDto != null
                ? _offenceScheduleRepository
                    .offenceScheduleToDb(offenceDetailDto.offenceScheduleDto)
                : null,
            offenceCategoryModel: offenceDetailDto.offenceCategoryDto != null
                ? _offenceCategoryRepository
                    .offenceCategoryToDb(offenceDetailDto.offenceCategoryDto)
                : null));
  }

  Future<void> deleteOffenceDetail(int id) async {
    await _offenceDetailsBox.delete(id);
  }

  Future<void> deleteAllOffenceDetails() async {
    await _offenceDetailsBox.clear();
  }

  List<OffenceDetailDto> getAllOffenceDetails() {
    return _offenceDetailsBox.values.map(offenceDetailFromDb).toList();
  }

  List<OffenceDetailDto> getAllOffenceDetailsByAssessmentId(
      int? intakeAssessmentId) {
    var offenceDetailDtoItems = _offenceDetailsBox.values
        .where((medical) => medical.intakeAssessmentId == intakeAssessmentId)
        .toList();
    return offenceDetailDtoItems.map(offenceDetailFromDb).toList();
  }

  OffenceDetailDto? getOffenceDetailById(int id) {
    final bookDb = _offenceDetailsBox.get(id);
    if (bookDb != null) {
      return offenceDetailFromDb(bookDb);
    }
    return null;
  }

  OffenceDetailDto offenceDetailFromDb(OffenceDetailModel offenceDetailModel) =>
      OffenceDetailDto(
          pcmOffenceId: offenceDetailModel.pcmOffenceId,
          pcmCaseId: offenceDetailModel.pcmCaseId,
          intakeAssessmentId: offenceDetailModel.intakeAssessmentId,
          offenceTypeId: offenceDetailModel.offenceTypeId,
          offenceCategoryId: offenceDetailModel.offenceCategoryId,
          offenceScheduleId: offenceDetailModel.offenceScheduleId,
          offenceCircumstance: offenceDetailModel.offenceCircumstance,
          valueOfGoods: offenceDetailModel.valueOfGoods,
          valueRecovered: offenceDetailModel.valueRecovered,
          isChildResponsible: offenceDetailModel.isChildResponsible,
          responsibilityDetails: offenceDetailModel.responsibilityDetails,
          createdBy: offenceDetailModel.createdBy,
          dateCreated: offenceDetailModel.dateCreated,
          modifiedBy: offenceDetailModel.modifiedBy,
          dateModified: offenceDetailModel.dateModified,
          offenceTypeDto: offenceDetailModel.offenceTypeModel != null
              ? _offenceTypeRepository
                  .offenceTypeFromDb(offenceDetailModel.offenceTypeModel)
              : null,
          offenceScheduleDto: offenceDetailModel.offenceScheduleModel != null
              ? _offenceScheduleRepository.offenceScheduleFromDb(
                  offenceDetailModel.offenceScheduleModel)
              : null,
          offenceCategoryDto: offenceDetailModel.offenceCategoryModel != null
              ? _offenceCategoryRepository.offenceCategoryFromDb(
                  offenceDetailModel.offenceCategoryModel)
              : null);

  OffenceDetailModel offenceDetailToDb(OffenceDetailDto? offenceDetailDto) =>
      OffenceDetailModel(
          pcmOffenceId: offenceDetailDto!.pcmOffenceId,
          pcmCaseId: offenceDetailDto.pcmCaseId,
          intakeAssessmentId: offenceDetailDto.intakeAssessmentId,
          offenceTypeId: offenceDetailDto.offenceTypeId,
          offenceCategoryId: offenceDetailDto.offenceCategoryId,
          offenceScheduleId: offenceDetailDto.offenceScheduleId,
          offenceCircumstance: offenceDetailDto.offenceCircumstance,
          valueOfGoods: offenceDetailDto.valueOfGoods,
          valueRecovered: offenceDetailDto.valueRecovered,
          isChildResponsible: offenceDetailDto.isChildResponsible,
          responsibilityDetails: offenceDetailDto.responsibilityDetails,
          createdBy: offenceDetailDto.createdBy,
          dateCreated: offenceDetailDto.dateCreated,
          modifiedBy: offenceDetailDto.modifiedBy,
          dateModified: offenceDetailDto.dateModified,
          offenceTypeModel: offenceDetailDto.offenceTypeDto != null
              ? _offenceTypeRepository
                  .offenceTypeToDb(offenceDetailDto.offenceTypeDto)
              : null,
          offenceScheduleModel: offenceDetailDto.offenceScheduleDto != null
              ? _offenceScheduleRepository
                  .offenceScheduleToDb(offenceDetailDto.offenceScheduleDto)
              : null,
          offenceCategoryModel: offenceDetailDto.offenceCategoryDto != null
              ? _offenceCategoryRepository
                  .offenceCategoryToDb(offenceDetailDto.offenceCategoryDto)
              : null);
}
