import 'package:hive_flutter/adapters.dart';

import '../../../model/intake/care_giver_details_dto.dart';
import '../../db_model_hive/assessment/care_giver_detail.model.dart';
import '../intake/person_repository.dart';
import '../lookup/relationship_type_repository.dart';

const String careGiverDetailBox = 'careGiverDetailBox';

class CareGiverDetailRepository {
  CareGiverDetailRepository._constructor();

  static final CareGiverDetailRepository _instance =
      CareGiverDetailRepository._constructor();
  final _relationshipTypeRepository = RelationshipTypeRepository();
  final _personRepository = PersonRepository();
  factory CareGiverDetailRepository() => _instance;

  late Box<CareGiverDetailModel> _careGiverDetailsBox;

  Future<void> initialize() async {
    await Hive.initFlutter();
    Hive.registerAdapter<CareGiverDetailModel>(CareGiverDetailModelAdapter());
    _careGiverDetailsBox =
        await Hive.openBox<CareGiverDetailModel>(careGiverDetailBox);
  }

  Future<void> saveCareGiverDetailItems(
      List<CareGiverDetailsDto> careGiverDetailsDto) async {
    for (var careGiverDetailDto in careGiverDetailsDto) {
      await _careGiverDetailsBox.put(
          careGiverDetailDto.clientCaregiverId,
          (CareGiverDetailModel(
              clientCaregiverId: careGiverDetailDto.clientCaregiverId,
              clientId: careGiverDetailDto.clientId,
              personId: careGiverDetailDto.personId,
              relationshipTypeId: careGiverDetailDto.relationshipTypeId,
              createdBy: careGiverDetailDto.createdBy,
              dateCreated: careGiverDetailDto.dateCreated,
              modifiedBy: careGiverDetailDto.modifiedBy,
              dateModified: careGiverDetailDto.dateModified,
              relationshipTypeModel:
                  careGiverDetailDto.relationshipTypeDto != null
                      ? _relationshipTypeRepository.relationshipTypeToDb(
                          careGiverDetailDto.relationshipTypeDto)
                      : null,
              personModel: careGiverDetailDto.personDto != null
                  ? _personRepository.personToDb(careGiverDetailDto.personDto)
                  : null)));
    }
  }

  Future<void> saveCareGiverDetailAfterOnline(
      CareGiverDetailsDto careGiverDetailDto,
      int personId,
      int clientCaregiverId) async {
    await _careGiverDetailsBox.put(
        clientCaregiverId,
        CareGiverDetailModel(
            clientCaregiverId: clientCaregiverId,
            clientId: careGiverDetailDto.clientId,
            personId: personId,
            relationshipTypeId: careGiverDetailDto.relationshipTypeId,
            createdBy: careGiverDetailDto.createdBy,
            dateCreated: careGiverDetailDto.dateCreated,
            modifiedBy: careGiverDetailDto.modifiedBy,
            dateModified: careGiverDetailDto.dateModified,
            relationshipTypeModel:
                careGiverDetailDto.relationshipTypeDto != null
                    ? _relationshipTypeRepository.relationshipTypeToDb(
                        careGiverDetailDto.relationshipTypeDto)
                    : null,
            personModel: careGiverDetailDto.personDto != null
                ? _personRepository.personToDb(careGiverDetailDto.personDto)
                : null));
  }

  Future<void> saveCareGiverDetail(
      CareGiverDetailsDto careGiverDetailDto) async {
    await _careGiverDetailsBox.put(
        careGiverDetailDto.clientCaregiverId,
        CareGiverDetailModel(
            clientCaregiverId: careGiverDetailDto.clientCaregiverId,
            clientId: careGiverDetailDto.clientId,
            personId: careGiverDetailDto.personId,
            relationshipTypeId: careGiverDetailDto.relationshipTypeId,
            createdBy: careGiverDetailDto.createdBy,
            dateCreated: careGiverDetailDto.dateCreated,
            modifiedBy: careGiverDetailDto.modifiedBy,
            dateModified: careGiverDetailDto.dateModified,
            relationshipTypeModel:
                careGiverDetailDto.relationshipTypeDto != null
                    ? _relationshipTypeRepository.relationshipTypeToDb(
                        careGiverDetailDto.relationshipTypeDto)
                    : null,
            personModel: careGiverDetailDto.personDto != null
                ? _personRepository.personToDb(careGiverDetailDto.personDto)
                : null));
  }

  Future<void> deleteCareGiverDetail(int id) async {
    await _careGiverDetailsBox.delete(id);
  }

  Future<void> deleteAllCareGiverDetails() async {
    await _careGiverDetailsBox.clear();
  }

  List<CareGiverDetailsDto> getAllCareGiverDetails() {
    return _careGiverDetailsBox.values.map(careGiverDetailFromDb).toList();
  }

  List<CareGiverDetailsDto> getAllCareGiverDetailsByClientId(int? clientId) {
    var careGiverDetailsDtoItems = _careGiverDetailsBox.values
        .where((careGiver) => careGiver.clientId == clientId)
        .toList();
    return careGiverDetailsDtoItems.map(careGiverDetailFromDb).toList();
  }

  CareGiverDetailsDto? getCareGiverDetailById(int id) {
    final bookDb = _careGiverDetailsBox.get(id);
    if (bookDb != null) {
      return careGiverDetailFromDb(bookDb);
    }
    return null;
  }

  CareGiverDetailsDto careGiverDetailFromDb(
          CareGiverDetailModel careGiverDetailModel) =>
      CareGiverDetailsDto(
          clientCaregiverId: careGiverDetailModel.clientCaregiverId,
          clientId: careGiverDetailModel.clientId,
          personId: careGiverDetailModel.personId,
          relationshipTypeId: careGiverDetailModel.relationshipTypeId,
          createdBy: careGiverDetailModel.createdBy,
          dateCreated: careGiverDetailModel.dateCreated,
          modifiedBy: careGiverDetailModel.modifiedBy,
          dateModified: careGiverDetailModel.dateModified,
          relationshipTypeDto:
              careGiverDetailModel.relationshipTypeModel != null
                  ? _relationshipTypeRepository.relationshipTypeFromDb(
                      careGiverDetailModel.relationshipTypeModel)
                  : null,
          personDto: careGiverDetailModel.personModel != null
              ? _personRepository
                  .personFromDb(careGiverDetailModel.personModel!)
              : null);

  CareGiverDetailModel careGiverDetailToDb(
          CareGiverDetailsDto? careGiverDetailDto) =>
      CareGiverDetailModel(
          clientCaregiverId: careGiverDetailDto?.clientCaregiverId,
          clientId: careGiverDetailDto?.clientId,
          personId: careGiverDetailDto?.personId,
          relationshipTypeId: careGiverDetailDto?.relationshipTypeId,
          createdBy: careGiverDetailDto?.createdBy,
          dateCreated: careGiverDetailDto?.dateCreated,
          modifiedBy: careGiverDetailDto?.modifiedBy,
          dateModified: careGiverDetailDto?.dateModified,
          relationshipTypeModel: careGiverDetailDto?.relationshipTypeDto != null
              ? _relationshipTypeRepository
                  .relationshipTypeToDb(careGiverDetailDto?.relationshipTypeDto)
              : null,
          personModel: careGiverDetailDto?.personDto != null
              ? _personRepository.personToDb(careGiverDetailDto?.personDto)
              : null);
}
