import 'package:hive_flutter/adapters.dart';

import '../../../model/pcm/accepted_worklist_dto.dart';
import '../../db_model_hive/worklist/accepted_worklist.model.dart';

const String _acceptedWorklistBox = 'acceptedWorklistBox';

class AcceptedWorklistRepository {
  AcceptedWorklistRepository._constructor();

  static final AcceptedWorklistRepository _instance =
      AcceptedWorklistRepository._constructor();

  factory AcceptedWorklistRepository() => _instance;

  late Box<AcceptedWorklistModel> _acceptedWorklistsBox;

  Future<void> initialize() async {
    await Hive.initFlutter();
    Hive.registerAdapter<AcceptedWorklistModel>(AcceptedWorklistModelAdapter());
    _acceptedWorklistsBox =
        await Hive.openBox<AcceptedWorklistModel>(_acceptedWorklistBox);
  }

  Future<void> saveAcceptedWorklistSingle(
      AcceptedWorklistDto worklist, int userId) async {
    await _acceptedWorklistsBox.put(
        worklist.worklistId,
        (AcceptedWorklistModel(
            assessmentStatus: worklist.assessmentStatus,
            assessmentRegisterId: worklist.assessmentRegisterId,
            caseId: worklist.caseId,
            worklistId: worklist.worklistId,
            intakeAssessmentId: worklist.intakeAssessmentId,
            personId: worklist.personId,
            childName: worklist.childName,
            dateAccepted: worklist.dateAccepted,
            childNameAbbr: worklist.childNameAbbr,
            clientId: worklist.clientId,
            userId: userId)));
  }

  Future<void> saveAcceptedWorklist(
      List<AcceptedWorklistDto> acceptedWorklistDto, int userId) async {
    for (var worklist in acceptedWorklistDto) {
      await _acceptedWorklistsBox.put(
          worklist.worklistId,
          (AcceptedWorklistModel(
              assessmentStatus: worklist.assessmentStatus,
              assessmentRegisterId: worklist.assessmentRegisterId,
              caseId: worklist.caseId,
              worklistId: worklist.worklistId,
              intakeAssessmentId: worklist.intakeAssessmentId,
              personId: worklist.personId,
              childName: worklist.childName,
              dateAccepted: worklist.dateAccepted,
              childNameAbbr: worklist.childNameAbbr,
              clientId: worklist.clientId,
              userId: userId)));
    }
  }

  Future<void> deleteAcceptedWorklistById(int id) async {
    await _acceptedWorklistsBox.delete(id);
  }

  Future<void> deleteAllAcceptedWorklists() async {
    await _acceptedWorklistsBox.clear();
  }

  AcceptedWorklistDto getAcceptedWorklist() {
    return _acceptedWorklistsBox.values.map(acceptedWorklistFromDb).single;
  }

  List<AcceptedWorklistDto> getAllAcceptedWorklists() {
    return _acceptedWorklistsBox.values.map(acceptedWorklistFromDb).toList();
  }

  List<AcceptedWorklistDto> getAllAcceptedWorklistsByUserId(int? userId) {
    var acceptedWorklistDtoItems = _acceptedWorklistsBox.values
        .where((worklist) => worklist.userId == userId)
        .toList();

    return acceptedWorklistDtoItems.map(acceptedWorklistFromDb).toList();
  }

  AcceptedWorklistDto? getMobileDashboardById(int id) {
    final bookDb = _acceptedWorklistsBox.get(id);
    if (bookDb != null) {
      return acceptedWorklistFromDb(bookDb);
    }
    return null;
  }

  AcceptedWorklistDto acceptedWorklistFromDb(
          AcceptedWorklistModel acceptedWorklistModel) =>
      AcceptedWorklistDto(
          assessmentStatus: acceptedWorklistModel.assessmentStatus,
          assessmentRegisterId: acceptedWorklistModel.assessmentRegisterId,
          caseId: acceptedWorklistModel.caseId,
          worklistId: acceptedWorklistModel.worklistId,
          intakeAssessmentId: acceptedWorklistModel.intakeAssessmentId,
          personId: acceptedWorklistModel.personId,
          childName: acceptedWorklistModel.childName,
          dateAccepted: acceptedWorklistModel.dateAccepted,
          childNameAbbr: acceptedWorklistModel.childNameAbbr,
          clientId: acceptedWorklistModel.clientId);
}
