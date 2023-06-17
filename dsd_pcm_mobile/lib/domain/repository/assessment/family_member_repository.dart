import 'package:hive_flutter/adapters.dart';

import '../../../model/pcm/family_member_dto.dart';
import '../../db_model_hive/assessment/family_member.model.dart';
import '../intake/person_repository.dart';
import '../lookup/relationship_type_repository.dart';

const String familyMemberBox = 'familyMemberBox';

class FamilyMemberRepository {
  FamilyMemberRepository._constructor();

  static final FamilyMemberRepository _instance =
      FamilyMemberRepository._constructor();
  final _relationshipTypeRepository = RelationshipTypeRepository();
  final _personRepository = PersonRepository();
  factory FamilyMemberRepository() => _instance;

  late Box<FamilyMemberModel> _familyMembersBox;

  Future<void> initialize() async {
    await Hive.initFlutter();
    Hive.registerAdapter<FamilyMemberModel>(FamilyMemberModelAdapter());
    _familyMembersBox = await Hive.openBox<FamilyMemberModel>(familyMemberBox);
  }

  Future<void> saveFamilyMemberItems(
      List<FamilyMemberDto> familyMembersDto) async {
    for (var familyMemberDto in familyMembersDto) {
      await _familyMembersBox.put(
          familyMemberDto.familyMemberId,
          (FamilyMemberModel(
              familyMemberId: familyMemberDto.familyMemberId,
              intakeAssessmentId: familyMemberDto.intakeAssessmentId,
              personId: familyMemberDto.personId,
              relationshipTypeId: familyMemberDto.relationshipTypeId,
              createdBy: familyMemberDto.createdBy,
              relationshipTypeModel: familyMemberDto.relationshipTypeDto != null
                  ? _relationshipTypeRepository
                      .relationshipTypeToDb(familyMemberDto.relationshipTypeDto)
                  : null,
              personModel: familyMemberDto.personDto != null
                  ? _personRepository.personToDb(familyMemberDto.personDto)
                  : null)));
    }
  }

  Future<void> saveFamilyMemberAfterOnline(
      FamilyMemberDto familyMemberDto, int personId, int familyMemberId) async {
    await _familyMembersBox.put(
        familyMemberId,
        FamilyMemberModel(
            familyMemberId: familyMemberId,
            intakeAssessmentId: familyMemberDto.intakeAssessmentId,
            personId: personId,
            relationshipTypeId: familyMemberDto.relationshipTypeId,
            createdBy: familyMemberDto.createdBy,
            relationshipTypeModel: familyMemberDto.relationshipTypeDto != null
                ? _relationshipTypeRepository
                    .relationshipTypeToDb(familyMemberDto.relationshipTypeDto)
                : null,
            personModel: familyMemberDto.personDto != null
                ? _personRepository.personToDb(familyMemberDto.personDto)
                : null));
  }

  Future<void> saveFamilyMember(FamilyMemberDto familyMemberDto) async {
    await _familyMembersBox.put(
        familyMemberDto.familyMemberId,
        FamilyMemberModel(
            familyMemberId: familyMemberDto.familyMemberId,
            intakeAssessmentId: familyMemberDto.intakeAssessmentId,
            personId: familyMemberDto.personId,
            relationshipTypeId: familyMemberDto.relationshipTypeId,
            createdBy: familyMemberDto.createdBy,
            relationshipTypeModel: familyMemberDto.relationshipTypeDto != null
                ? _relationshipTypeRepository
                    .relationshipTypeToDb(familyMemberDto.relationshipTypeDto)
                : null,
            personModel: familyMemberDto.personDto != null
                ? _personRepository.personToDb(familyMemberDto.personDto)
                : null));
  }

  Future<void> deleteFamilyMember(int id) async {
    await _familyMembersBox.delete(id);
  }

  Future<void> deleteAllFamilyMembers() async {
    await _familyMembersBox.clear();
  }

  List<FamilyMemberDto> getAllFamilyMembers() {
    return _familyMembersBox.values.map(familyMemberFromDb).toList();
  }

  List<FamilyMemberDto> getAllFamilyMembersByAssessmentId(
      int? intakeAssessmentId) {
    var familyMemberDtoItems = _familyMembersBox.values
        .where((medical) => medical.intakeAssessmentId == intakeAssessmentId)
        .toList();
    return familyMemberDtoItems.map(familyMemberFromDb).toList();
  }

  FamilyMemberDto? getFamilyMemberById(int id) {
    final bookDb = _familyMembersBox.get(id);
    if (bookDb != null) {
      return familyMemberFromDb(bookDb);
    }
    return null;
  }

  FamilyMemberDto familyMemberFromDb(FamilyMemberModel familyMemberModel) =>
      FamilyMemberDto(
          familyMemberId: familyMemberModel.familyMemberId,
          intakeAssessmentId: familyMemberModel.intakeAssessmentId,
          personId: familyMemberModel.personId,
          relationshipTypeId: familyMemberModel.relationshipTypeId,
          createdBy: familyMemberModel.createdBy,
          relationshipTypeDto: familyMemberModel.relationshipTypeModel != null
              ? _relationshipTypeRepository.relationshipTypeFromDb(
                  familyMemberModel.relationshipTypeModel)
              : null,
          personDto: familyMemberModel.personModel != null
              ? _personRepository.personFromDb(familyMemberModel.personModel!)
              : null);

  FamilyMemberModel familyMemberToDb(FamilyMemberDto? familyMemberDto) =>
      FamilyMemberModel(
          familyMemberId: familyMemberDto?.familyMemberId,
          intakeAssessmentId: familyMemberDto?.intakeAssessmentId,
          personId: familyMemberDto?.personId,
          relationshipTypeId: familyMemberDto?.relationshipTypeId,
          createdBy: familyMemberDto?.createdBy,
          relationshipTypeModel: familyMemberDto?.relationshipTypeDto != null
              ? _relationshipTypeRepository
                  .relationshipTypeToDb(familyMemberDto?.relationshipTypeDto)
              : null,
          personModel: familyMemberDto?.personDto != null
              ? _personRepository.personToDb(familyMemberDto?.personDto)
              : null);
}
