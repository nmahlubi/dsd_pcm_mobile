import 'package:hive_flutter/adapters.dart';

import '../../../model/pcm/family_information_dto.dart';
import '../../db_model_hive/assessment/family_information.model.dart';

const String familyInformationBox = 'familyInformationBox';

class FamilyInformationRepository {
  FamilyInformationRepository._constructor();

  static final FamilyInformationRepository _instance =
      FamilyInformationRepository._constructor();

  factory FamilyInformationRepository() => _instance;

  late Box<FamilyInformationModel> _familyInformationsBox;

  Future<void> initialize() async {
    await Hive.initFlutter();
    Hive.registerAdapter<FamilyInformationModel>(
        FamilyInformationModelAdapter());
    _familyInformationsBox =
        await Hive.openBox<FamilyInformationModel>(familyInformationBox);
  }

  Future<void> saveFamilyInformationItems(
      List<FamilyInformationDto> familyInformationsDto) async {
    for (var familyInformationDto in familyInformationsDto) {
      await _familyInformationsBox.put(
          familyInformationDto.familyInformationId,
          (FamilyInformationModel(
              familyInformationId: familyInformationDto.familyInformationId,
              intakeAssessmentId: familyInformationDto.intakeAssessmentId,
              familyBackground: familyInformationDto.familyBackground,
              createdBy: familyInformationDto.createdBy,
              dateCreated: familyInformationDto.dateCreated,
              modifiedBy: familyInformationDto.modifiedBy,
              dateModified: familyInformationDto.dateCreated)));
    }
  }

  Future<void> saveFamilyInformation(
      FamilyInformationDto familyInformationDto) async {
    await _familyInformationsBox.put(
        familyInformationDto.familyInformationId,
        FamilyInformationModel(
            familyInformationId: familyInformationDto.familyInformationId,
            intakeAssessmentId: familyInformationDto.intakeAssessmentId,
            familyBackground: familyInformationDto.familyBackground,
            createdBy: familyInformationDto.createdBy,
            dateCreated: familyInformationDto.dateCreated,
            modifiedBy: familyInformationDto.modifiedBy,
            dateModified: familyInformationDto.dateCreated));
  }

  Future<void> deleteFamilyInformation(int id) async {
    await _familyInformationsBox.delete(id);
  }

  Future<void> deleteAllFamilyInformations() async {
    await _familyInformationsBox.clear();
  }

  List<FamilyInformationDto> getAllFamilyInformations() {
    return _familyInformationsBox.values.map(familyInformationFromDb).toList();
  }

  List<FamilyInformationDto> getAllFamilyInformationsByAssessmentId(
      int? intakeAssessmentId) {
    var familyInformationDtoItems = _familyInformationsBox.values
        .where((medical) => medical.intakeAssessmentId == intakeAssessmentId)
        .toList();
    return familyInformationDtoItems.map(familyInformationFromDb).toList();
  }

  FamilyInformationDto? getFamilyInformationById(int id) {
    final bookDb = _familyInformationsBox.get(id);
    if (bookDb != null) {
      return familyInformationFromDb(bookDb);
    }
    return null;
  }

  FamilyInformationDto familyInformationFromDb(
          FamilyInformationModel familyInformationModel) =>
      FamilyInformationDto(
          familyInformationId: familyInformationModel.familyInformationId,
          intakeAssessmentId: familyInformationModel.intakeAssessmentId,
          familyBackground: familyInformationModel.familyBackground,
          createdBy: familyInformationModel.createdBy,
          dateCreated: familyInformationModel.dateCreated,
          modifiedBy: familyInformationModel.modifiedBy,
          dateModified: familyInformationModel.dateCreated);

  FamilyInformationModel familyInformationToDb(
          FamilyInformationDto? familyInformationDto) =>
      FamilyInformationModel(
          familyInformationId: familyInformationDto?.familyInformationId,
          intakeAssessmentId: familyInformationDto?.intakeAssessmentId,
          familyBackground: familyInformationDto?.familyBackground,
          createdBy: familyInformationDto?.createdBy,
          dateCreated: familyInformationDto?.dateCreated,
          modifiedBy: familyInformationDto?.modifiedBy,
          dateModified: familyInformationDto?.dateCreated);
}
