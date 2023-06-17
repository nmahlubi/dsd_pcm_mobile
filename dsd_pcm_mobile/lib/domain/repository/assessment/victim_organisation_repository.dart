import 'package:hive_flutter/adapters.dart';

import '../../../model/pcm/victim_organisation_detail_dto.dart';
import '../../db_model_hive/assessment/victim_organisation_detail.model.dart';

const String victimOrganisationDetailBox = 'victimOrganisationDetailBox';

class VictimOrganisationDetailRepository {
  VictimOrganisationDetailRepository._constructor();

  static final VictimOrganisationDetailRepository _instance =
      VictimOrganisationDetailRepository._constructor();
  factory VictimOrganisationDetailRepository() => _instance;

  late Box<VictimOrganisationDetailModel> _victimOrganisationDetailsBox;

  Future<void> initialize() async {
    await Hive.initFlutter();
    Hive.registerAdapter<VictimOrganisationDetailModel>(
        VictimOrganisationDetailModelAdapter());
    _victimOrganisationDetailsBox =
        await Hive.openBox<VictimOrganisationDetailModel>(
            victimOrganisationDetailBox);
  }

  Future<void> saveVictimOrganisationDetailItems(
      List<VictimOrganisationDetailDto> victimOrganisationDetailsDto) async {
    for (var victimOrganisationDetailDto in victimOrganisationDetailsDto) {
      await _victimOrganisationDetailsBox.put(
          victimOrganisationDetailDto.victimOrganisationId,
          (VictimOrganisationDetailModel(
              victimOrganisationId:
                  victimOrganisationDetailDto.victimOrganisationId,
              intakeAssessmentId:
                  victimOrganisationDetailDto.intakeAssessmentId,
              organisationName: victimOrganisationDetailDto.organisationName,
              contactPersonFirstName:
                  victimOrganisationDetailDto.contactPersonFirstName,
              contactPersonLastName:
                  victimOrganisationDetailDto.contactPersonLastName,
              telephone: victimOrganisationDetailDto.telephone,
              cellNo: victimOrganisationDetailDto.cellNo,
              interventionserviceReferrals:
                  victimOrganisationDetailDto.interventionserviceReferrals,
              otherContacts: victimOrganisationDetailDto.otherContacts,
              contactPersonOccupation:
                  victimOrganisationDetailDto.contactPersonOccupation,
              addressLine1: victimOrganisationDetailDto.addressLine1,
              addressLine2: victimOrganisationDetailDto.addressLine2,
              townId: victimOrganisationDetailDto.townId,
              postalCode: victimOrganisationDetailDto.postalCode,
              createdBy: victimOrganisationDetailDto.createdBy,
              dateCreated: victimOrganisationDetailDto.dateCreated,
              modifiedBy: victimOrganisationDetailDto.modifiedBy,
              dateModified: victimOrganisationDetailDto.dateModified)));
    }
  }

  Future<void> saveVictimOrganisationDetailNewRecord(
      VictimOrganisationDetailDto victimOrganisationDetailDto,
      int? victimOrganisationDetailsId) async {
    await _victimOrganisationDetailsBox.put(
        victimOrganisationDetailsId,
        VictimOrganisationDetailModel(
            victimOrganisationId:
                victimOrganisationDetailDto.victimOrganisationId,
            intakeAssessmentId: victimOrganisationDetailDto.intakeAssessmentId,
            organisationName: victimOrganisationDetailDto.organisationName,
            contactPersonFirstName:
                victimOrganisationDetailDto.contactPersonFirstName,
            contactPersonLastName:
                victimOrganisationDetailDto.contactPersonLastName,
            telephone: victimOrganisationDetailDto.telephone,
            cellNo: victimOrganisationDetailDto.cellNo,
            interventionserviceReferrals:
                victimOrganisationDetailDto.interventionserviceReferrals,
            otherContacts: victimOrganisationDetailDto.otherContacts,
            contactPersonOccupation:
                victimOrganisationDetailDto.contactPersonOccupation,
            addressLine1: victimOrganisationDetailDto.addressLine1,
            addressLine2: victimOrganisationDetailDto.addressLine2,
            townId: victimOrganisationDetailDto.townId,
            postalCode: victimOrganisationDetailDto.postalCode,
            createdBy: victimOrganisationDetailDto.createdBy,
            dateCreated: victimOrganisationDetailDto.dateCreated,
            modifiedBy: victimOrganisationDetailDto.modifiedBy,
            dateModified: victimOrganisationDetailDto.dateModified));
  }

  Future<void> saveVictimOrganisationDetail(
      VictimOrganisationDetailDto victimOrganisationDetailDto) async {
    await _victimOrganisationDetailsBox.put(
        victimOrganisationDetailDto.victimOrganisationId,
        VictimOrganisationDetailModel(
            victimOrganisationId:
                victimOrganisationDetailDto.victimOrganisationId,
            intakeAssessmentId: victimOrganisationDetailDto.intakeAssessmentId,
            organisationName: victimOrganisationDetailDto.organisationName,
            contactPersonFirstName:
                victimOrganisationDetailDto.contactPersonFirstName,
            contactPersonLastName:
                victimOrganisationDetailDto.contactPersonLastName,
            telephone: victimOrganisationDetailDto.telephone,
            cellNo: victimOrganisationDetailDto.cellNo,
            interventionserviceReferrals:
                victimOrganisationDetailDto.interventionserviceReferrals,
            otherContacts: victimOrganisationDetailDto.otherContacts,
            contactPersonOccupation:
                victimOrganisationDetailDto.contactPersonOccupation,
            addressLine1: victimOrganisationDetailDto.addressLine1,
            addressLine2: victimOrganisationDetailDto.addressLine2,
            townId: victimOrganisationDetailDto.townId,
            postalCode: victimOrganisationDetailDto.postalCode,
            createdBy: victimOrganisationDetailDto.createdBy,
            dateCreated: victimOrganisationDetailDto.dateCreated,
            modifiedBy: victimOrganisationDetailDto.modifiedBy,
            dateModified: victimOrganisationDetailDto.dateModified));
  }

  Future<void> deleteVictimOrganisationDetail(int id) async {
    await _victimOrganisationDetailsBox.delete(id);
  }

  Future<void> deleteAllVictimOrganisationDetails() async {
    await _victimOrganisationDetailsBox.clear();
  }

  List<VictimOrganisationDetailDto> getAllVictimOrganisationDetails() {
    return _victimOrganisationDetailsBox.values
        .map(victimOrganisationDetailFromDb)
        .toList();
  }

  List<VictimOrganisationDetailDto>
      getAllVictimOrganisationDetailsByAssessmentId(int? intakeAssessmentId) {
    var victimOrganisationDetailDtoItems = _victimOrganisationDetailsBox.values
        .where((medical) => medical.intakeAssessmentId == intakeAssessmentId)
        .toList();
    return victimOrganisationDetailDtoItems
        .map(victimOrganisationDetailFromDb)
        .toList();
  }

  VictimOrganisationDetailDto? getVictimOrganisationDetailById(int id) {
    final bookDb = _victimOrganisationDetailsBox.get(id);
    if (bookDb != null) {
      return victimOrganisationDetailFromDb(bookDb);
    }
    return null;
  }

  VictimOrganisationDetailDto victimOrganisationDetailFromDb(
          VictimOrganisationDetailModel victimOrganisationDetailModel) =>
      VictimOrganisationDetailDto(
          victimOrganisationId:
              victimOrganisationDetailModel.victimOrganisationId,
          intakeAssessmentId: victimOrganisationDetailModel.intakeAssessmentId,
          organisationName: victimOrganisationDetailModel.organisationName,
          contactPersonFirstName:
              victimOrganisationDetailModel.contactPersonFirstName,
          contactPersonLastName:
              victimOrganisationDetailModel.contactPersonLastName,
          telephone: victimOrganisationDetailModel.telephone,
          cellNo: victimOrganisationDetailModel.cellNo,
          interventionserviceReferrals:
              victimOrganisationDetailModel.interventionserviceReferrals,
          otherContacts: victimOrganisationDetailModel.otherContacts,
          contactPersonOccupation:
              victimOrganisationDetailModel.contactPersonOccupation,
          addressLine1: victimOrganisationDetailModel.addressLine1,
          addressLine2: victimOrganisationDetailModel.addressLine2,
          townId: victimOrganisationDetailModel.townId,
          postalCode: victimOrganisationDetailModel.postalCode,
          createdBy: victimOrganisationDetailModel.createdBy,
          dateCreated: victimOrganisationDetailModel.dateCreated,
          modifiedBy: victimOrganisationDetailModel.modifiedBy,
          dateModified: victimOrganisationDetailModel.dateModified);

  VictimOrganisationDetailModel victimOrganisationDetailToDb(
          VictimOrganisationDetailDto? victimOrganisationDetailDto) =>
      VictimOrganisationDetailModel(
          victimOrganisationId:
              victimOrganisationDetailDto!.victimOrganisationId,
          intakeAssessmentId: victimOrganisationDetailDto.intakeAssessmentId,
          organisationName: victimOrganisationDetailDto.organisationName,
          contactPersonFirstName:
              victimOrganisationDetailDto.contactPersonFirstName,
          contactPersonLastName:
              victimOrganisationDetailDto.contactPersonLastName,
          telephone: victimOrganisationDetailDto.telephone,
          cellNo: victimOrganisationDetailDto.cellNo,
          interventionserviceReferrals:
              victimOrganisationDetailDto.interventionserviceReferrals,
          otherContacts: victimOrganisationDetailDto.otherContacts,
          contactPersonOccupation:
              victimOrganisationDetailDto.contactPersonOccupation,
          addressLine1: victimOrganisationDetailDto.addressLine1,
          addressLine2: victimOrganisationDetailDto.addressLine2,
          townId: victimOrganisationDetailDto.townId,
          postalCode: victimOrganisationDetailDto.postalCode,
          createdBy: victimOrganisationDetailDto.createdBy,
          dateCreated: victimOrganisationDetailDto.dateCreated,
          modifiedBy: victimOrganisationDetailDto.modifiedBy,
          dateModified: victimOrganisationDetailDto.dateModified);
}
