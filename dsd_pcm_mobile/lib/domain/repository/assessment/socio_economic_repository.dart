import 'package:hive_flutter/adapters.dart';

import '../../../model/pcm/socio_economic_dto.dart';
import '../../db_model_hive/assessment/socio_economic.model.dart';

const String socioEconomicBox = 'socioEconomicBox';

class SocioEconomicRepository {
  SocioEconomicRepository._constructor();
  static final SocioEconomicRepository _instance =
      SocioEconomicRepository._constructor();

  factory SocioEconomicRepository() => _instance;

  late Box<SocioEconomicModel> _socioEconomicsBox;

  Future<void> initialize() async {
    await Hive.initFlutter();
    Hive.registerAdapter<SocioEconomicModel>(SocioEconomicModelAdapter());
    _socioEconomicsBox =
        await Hive.openBox<SocioEconomicModel>(socioEconomicBox);
  }

  Future<void> saveSocioEconomicItems(
      List<SocioEconomicDto> socioEconomicsDto) async {
    for (var socioEconomicDto in socioEconomicsDto) {
      await _socioEconomicsBox.put(
          socioEconomicDto.socioEconomyid,
          (SocioEconomicModel(
              socioEconomyid: socioEconomicDto.socioEconomyid,
              intakeAssessmentId: socioEconomicDto.intakeAssessmentId,
              familyBackgroundComment: socioEconomicDto.familyBackgroundComment,
              financeWorkRecord: socioEconomicDto.financeWorkRecord,
              housing: socioEconomicDto.housing,
              socialCircumsances: socioEconomicDto.socialCircumsances,
              previousIntervention: socioEconomicDto.previousIntervention,
              interPersonalRelationship:
                  socioEconomicDto.interPersonalRelationship,
              peerPresure: socioEconomicDto.peerPresure,
              substanceAbuse: socioEconomicDto.substanceAbuse,
              religiousInvolve: socioEconomicDto.religiousInvolve,
              childBehavior: socioEconomicDto.childBehavior,
              other: socioEconomicDto.other,
              createdBy: socioEconomicDto.createdBy,
              dateCreated: socioEconomicDto.dateCreated,
              modifiedBy: socioEconomicDto.modifiedBy,
              dateModified: socioEconomicDto.dateModified)));
    }
  }

  Future<void> saveSocioEconomic(SocioEconomicDto socioEconomicDto) async {
    await _socioEconomicsBox.put(
        socioEconomicDto.socioEconomyid,
        SocioEconomicModel(
            socioEconomyid: socioEconomicDto.socioEconomyid,
            intakeAssessmentId: socioEconomicDto.intakeAssessmentId,
            familyBackgroundComment: socioEconomicDto.familyBackgroundComment,
            financeWorkRecord: socioEconomicDto.financeWorkRecord,
            housing: socioEconomicDto.housing,
            socialCircumsances: socioEconomicDto.socialCircumsances,
            previousIntervention: socioEconomicDto.previousIntervention,
            interPersonalRelationship:
                socioEconomicDto.interPersonalRelationship,
            peerPresure: socioEconomicDto.peerPresure,
            substanceAbuse: socioEconomicDto.substanceAbuse,
            religiousInvolve: socioEconomicDto.religiousInvolve,
            childBehavior: socioEconomicDto.childBehavior,
            other: socioEconomicDto.other,
            createdBy: socioEconomicDto.createdBy,
            dateCreated: socioEconomicDto.dateCreated,
            modifiedBy: socioEconomicDto.modifiedBy,
            dateModified: socioEconomicDto.dateModified));
  }

  SocioEconomicDto? getSocioEconomicsById(int id) {
    final socioEconomicDb = _socioEconomicsBox.get(id);
    if (socioEconomicDb != null) {
      return socioEconomicFromDb(socioEconomicDb);
    }
    return null;
  }

  List<SocioEconomicDto> getAllSocioEconomics() {
    return _socioEconomicsBox.values.map(socioEconomicFromDb).toList();
  }

  List<SocioEconomicDto> getAllAcceptedWorklistsByUserId(
      int? intakeAssessmentId) {
    var socioEconomicDtoItems = _socioEconomicsBox.values
        .where((medical) => medical.intakeAssessmentId == intakeAssessmentId)
        .toList();

    return socioEconomicDtoItems.map(socioEconomicFromDb).toList();
  }

  List<SocioEconomicDto> getAllSocioEconomicsByAssessmentId(
      int intakeAssessmentId) {
    return _socioEconomicsBox.values.map(socioEconomicFromDb).toList();
  }

  Future<void> deleteSocioEconomic(int id) async {
    await _socioEconomicsBox.delete(id);
  }

  SocioEconomicDto socioEconomicFromDb(SocioEconomicModel socioEconomicModel) =>
      SocioEconomicDto(
          socioEconomyid: socioEconomicModel.socioEconomyid,
          intakeAssessmentId: socioEconomicModel.intakeAssessmentId,
          familyBackgroundComment: socioEconomicModel.familyBackgroundComment,
          financeWorkRecord: socioEconomicModel.financeWorkRecord,
          housing: socioEconomicModel.housing,
          socialCircumsances: socioEconomicModel.socialCircumsances,
          previousIntervention: socioEconomicModel.previousIntervention,
          interPersonalRelationship:
              socioEconomicModel.interPersonalRelationship,
          peerPresure: socioEconomicModel.peerPresure,
          substanceAbuse: socioEconomicModel.substanceAbuse,
          religiousInvolve: socioEconomicModel.religiousInvolve,
          childBehavior: socioEconomicModel.childBehavior,
          other: socioEconomicModel.other,
          createdBy: socioEconomicModel.createdBy,
          dateCreated: socioEconomicModel.dateCreated,
          modifiedBy: socioEconomicModel.modifiedBy,
          dateModified: socioEconomicModel.dateModified);
}
