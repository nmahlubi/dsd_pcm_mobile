import 'package:hive_flutter/adapters.dart';

import '../../../model/pcm/victim_detail_dto.dart';
import '../../db_model_hive/assessment/victim_detail.model.dart';
import '../intake/person_repository.dart';

const String victimDetailBox = 'victimDetailBox';

class VictimDetailRepository {
  VictimDetailRepository._constructor();

  static final VictimDetailRepository _instance =
      VictimDetailRepository._constructor();
  final _personRepository = PersonRepository();
  factory VictimDetailRepository() => _instance;

  late Box<VictimDetailModel> _victimDetailsBox;

  Future<void> initialize() async {
    await Hive.initFlutter();
    Hive.registerAdapter<VictimDetailModel>(VictimDetailModelAdapter());
    _victimDetailsBox = await Hive.openBox<VictimDetailModel>(victimDetailBox);
  }

  Future<void> saveVictimDetailItems(
      List<VictimDetailDto> victimDetailsDto) async {
    for (var victimDetailDto in victimDetailsDto) {
      await _victimDetailsBox.put(
          victimDetailDto.victimId,
          (VictimDetailModel(
              victimId: victimDetailDto.victimId,
              intakeAssessmentId: victimDetailDto.intakeAssessmentId,
              isVictimIndividual: victimDetailDto.isVictimIndividual,
              personId: victimDetailDto.personId,
              victimOccupation: victimDetailDto.victimOccupation,
              victimCareGiverNames: victimDetailDto.victimCareGiverNames,
              addressLine1: victimDetailDto.addressLine1,
              addressLine2: victimDetailDto.addressLine2,
              townId: victimDetailDto.townId,
              postalCode: victimDetailDto.postalCode,
              createdBy: victimDetailDto.createdBy,
              dateCreated: victimDetailDto.dateCreated,
              modifiedBy: victimDetailDto.modifiedBy,
              dateModified: victimDetailDto.dateModified,
              personModel: victimDetailDto.personDto != null
                  ? _personRepository.personToDb(victimDetailDto.personDto)
                  : null)));
    }
  }

  Future<void> saveVictimDetailAfterOnline(
      VictimDetailDto victimDetailDto, int personId, int victimDetailId) async {
    await _victimDetailsBox.put(
        victimDetailId,
        VictimDetailModel(
            victimId: victimDetailId,
            intakeAssessmentId: victimDetailDto.intakeAssessmentId,
            isVictimIndividual: victimDetailDto.isVictimIndividual,
            personId: personId,
            victimOccupation: victimDetailDto.victimOccupation,
            victimCareGiverNames: victimDetailDto.victimCareGiverNames,
            addressLine1: victimDetailDto.addressLine1,
            addressLine2: victimDetailDto.addressLine2,
            townId: victimDetailDto.townId,
            postalCode: victimDetailDto.postalCode,
            createdBy: victimDetailDto.createdBy,
            dateCreated: victimDetailDto.dateCreated,
            modifiedBy: victimDetailDto.modifiedBy,
            dateModified: victimDetailDto.dateModified,
            personModel: victimDetailDto.personDto != null
                ? _personRepository.personToDb(victimDetailDto.personDto)
                : null));
  }

  Future<void> saveVictimDetail(VictimDetailDto victimDetailDto) async {
    await _victimDetailsBox.put(
        victimDetailDto.victimId,
        VictimDetailModel(
            victimId: victimDetailDto.victimId,
            intakeAssessmentId: victimDetailDto.intakeAssessmentId,
            isVictimIndividual: victimDetailDto.isVictimIndividual,
            personId: victimDetailDto.personId,
            victimOccupation: victimDetailDto.victimOccupation,
            victimCareGiverNames: victimDetailDto.victimCareGiverNames,
            addressLine1: victimDetailDto.addressLine1,
            addressLine2: victimDetailDto.addressLine2,
            townId: victimDetailDto.townId,
            postalCode: victimDetailDto.postalCode,
            createdBy: victimDetailDto.createdBy,
            dateCreated: victimDetailDto.dateCreated,
            modifiedBy: victimDetailDto.modifiedBy,
            dateModified: victimDetailDto.dateModified,
            personModel: victimDetailDto.personDto != null
                ? _personRepository.personToDb(victimDetailDto.personDto)
                : null));
  }

  Future<void> deleteVictimDetail(int id) async {
    await _victimDetailsBox.delete(id);
  }

  Future<void> deleteAllVictimDetails() async {
    await _victimDetailsBox.clear();
  }

  List<VictimDetailDto> getAllVictimDetails() {
    return _victimDetailsBox.values.map(victimDetailFromDb).toList();
  }

  List<VictimDetailDto> getAllVictimDetailsByAssessmentId(
      int? intakeAssessmentId) {
    var victimDetailDtoItems = _victimDetailsBox.values
        .where((medical) => medical.intakeAssessmentId == intakeAssessmentId)
        .toList();
    return victimDetailDtoItems.map(victimDetailFromDb).toList();
  }

  VictimDetailDto? getVictimDetailById(int id) {
    final bookDb = _victimDetailsBox.get(id);
    if (bookDb != null) {
      return victimDetailFromDb(bookDb);
    }
    return null;
  }

  VictimDetailDto victimDetailFromDb(VictimDetailModel victimDetailModel) =>
      VictimDetailDto(
          victimId: victimDetailModel.victimId,
          intakeAssessmentId: victimDetailModel.intakeAssessmentId,
          isVictimIndividual: victimDetailModel.isVictimIndividual,
          personId: victimDetailModel.personId,
          victimOccupation: victimDetailModel.victimOccupation,
          victimCareGiverNames: victimDetailModel.victimCareGiverNames,
          addressLine1: victimDetailModel.addressLine1,
          addressLine2: victimDetailModel.addressLine2,
          townId: victimDetailModel.townId,
          postalCode: victimDetailModel.postalCode,
          createdBy: victimDetailModel.createdBy,
          dateCreated: victimDetailModel.dateCreated,
          modifiedBy: victimDetailModel.modifiedBy,
          dateModified: victimDetailModel.dateModified,
          personDto: victimDetailModel.personModel != null
              ? _personRepository.personFromDb(victimDetailModel.personModel!)
              : null);

  VictimDetailModel victimDetailToDb(VictimDetailDto? victimDetailDto) =>
      VictimDetailModel(
          victimId: victimDetailDto!.victimId,
          intakeAssessmentId: victimDetailDto.intakeAssessmentId,
          isVictimIndividual: victimDetailDto.isVictimIndividual,
          personId: victimDetailDto.personId,
          victimOccupation: victimDetailDto.victimOccupation,
          victimCareGiverNames: victimDetailDto.victimCareGiverNames,
          addressLine1: victimDetailDto.addressLine1,
          addressLine2: victimDetailDto.addressLine2,
          townId: victimDetailDto.townId,
          postalCode: victimDetailDto.postalCode,
          createdBy: victimDetailDto.createdBy,
          dateCreated: victimDetailDto.dateCreated,
          modifiedBy: victimDetailDto.modifiedBy,
          dateModified: victimDetailDto.dateModified,
          personModel: victimDetailDto.personDto != null
              ? _personRepository.personToDb(victimDetailDto.personDto)
              : null);
}
