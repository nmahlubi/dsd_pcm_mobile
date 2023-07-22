import 'package:dsd_pcm_mobile/background_job/syncing/assessment_sync/development_assessment_sync.dart';
import 'package:dsd_pcm_mobile/background_job/syncing/assessment_sync/intake_sync/person_address_sync.dart';
import 'package:dsd_pcm_mobile/model/pcm/accepted_worklist_dto.dart';

import '../domain/repository/authenticate/authenticate_repository.dart';
import 'syncing/assessment_sync/assessment_register_sync.dart';
import 'syncing/assessment_sync/care_giver_detail_sync.dart';
import 'syncing/assessment_sync/family_member_sync.dart';
import 'syncing/assessment_sync/general_detail_sync.dart';
import 'syncing/assessment_sync/intake_sync/person_education_sync.dart';
import 'syncing/assessment_sync/offence_details_sync.dart';
import 'syncing/assessment_sync/recommandation_sync.dart';
import 'syncing/assessment_sync/socio_economic_sync.dart';
import 'syncing/assessment_sync/victim_details_sync.dart';
import 'syncing/worklist_sync/accepted_worklist_sync.dart';
import 'syncing/assessment_sync/family_information_sync.dart';
import 'syncing/assessment_sync/intake_sync/person_sync.dart';
import 'syncing/assessment_sync/medical_health_detail_sync.dart';
import 'syncing/dashboard_sync/dashboard_sync.dart';

class BackgroundJobOffline {
  final _authenticateRepository = AuthenticateRepository();
  final _dashboardSync = DashboardSync();
  final _acceptedWorklistSync = AcceptedWorklistSync();
  final _personSync = PersonSync();
  final _medicalHealthDetailSync = MedicalHealthDetailSync();
  final _familyMemberSync = FamilyMemberSync();
  final _familyInformationSync = FamilyInformationSync();
  final _socioEconomicSync = SocioEconomicSync();
  final _careGiverDetailSync = CareGiverDetailSync();
  final _personAddressSync = PersonAddressSync();
  final _offenceDetailSync = OffenceDetailSync();
  final _generalDetailSync = GeneralDetailSync();
  final _victimDetailSync = VictimDetailSync();
  final _developmentAssessmentSync = DevelopmentAssessmentSync();
  final _personEducationSync = PersonEducationSync();
  final _assessmentRegisterSync = AssessmentRegisterSync();
  final _recommandationSync = RecommandationSync();

  Future<void> startRunningBackgroundSyncJob() async {
    var userToken = await _authenticateRepository.getAllAuthTokens();
    for (var user in userToken) {
      await startRunningBackgroundProcess(user.userId);
    }
  }

  Future<void> startRunningBackgroundSyncJobManually(int? userId) async {
    await startRunningBackgroundProcess(userId);
  }

  Future<void> startRunningBackgroundProcess(int? userId) async {
    //repopulate dash board
    await _dashboardSync.syncDashboard(userId);
    var acceptedWorkList =
        await _acceptedWorklistSync.syncAcceptedWorklist(userId);
    if (acceptedWorkList.isNotEmpty) {
      for (var acceptedWork in acceptedWorkList) {
        //sync child details
        await _personSync.syncPerson(acceptedWork.personId, userId);
        /*
        //medical health sync
        await _medicalHealthDetailSync
            .syncMedicalDetailHealth(acceptedWork.intakeAssessmentId);
        //Family Information sync
        
             */
        //Socio Economic sync

/*
        await _medicalHealthDetailSync
            .syncMedicalDetailHealth(acceptedWork.intakeAssessmentId);
        await _familyMemberSync
            .syncFamilyMember(acceptedWork.intakeAssessmentId);
        await _familyInformationSync
            .syncFamilyInformation(acceptedWork.intakeAssessmentId);
        await _socioEconomicSync
            .syncSocioEconomic(acceptedWork.intakeAssessmentId);
        await _careGiverDetailSync.syncCareGiverDetail(acceptedWork.clientId);
        
        await _personAddressSync.syncPersonAddress(acceptedWork.personId);
        await _offenceDetailSync
            .syncOffenceDetail(acceptedWork.intakeAssessmentId);
        await _generalDetailSync
            .syncGeneralDetail(acceptedWork.intakeAssessmentId);
            */

        await _victimDetailSync
            .syncVictimOrganisationDetail(acceptedWork.intakeAssessmentId);
      }
    }
  }

  Future<void> syncAcceptedWorklist(
      AcceptedWorklistDto acceptedWork, userId) async {
    await _dashboardSync.syncDashboard(userId);
    await _acceptedWorklistSync.syncAcceptedWorklist(userId);
    await _personSync.syncPerson(acceptedWork.personId, userId);
    await _medicalHealthDetailSync
        .syncMedicalDetailHealth(acceptedWork.intakeAssessmentId);
    await _medicalHealthDetailSync
        .syncMedicalDetailHealth(acceptedWork.intakeAssessmentId);
    await _familyMemberSync.syncFamilyMember(acceptedWork.intakeAssessmentId);
    await _familyInformationSync
        .syncFamilyInformation(acceptedWork.intakeAssessmentId);
    await _socioEconomicSync.syncSocioEconomic(acceptedWork.intakeAssessmentId);
    await _careGiverDetailSync.syncCareGiverDetail(acceptedWork.clientId);
    await _personAddressSync.syncPersonAddress(acceptedWork.personId);
    await _offenceDetailSync.syncOffenceDetail(acceptedWork.intakeAssessmentId);
    await _generalDetailSync.syncGeneralDetail(acceptedWork.intakeAssessmentId);
    await _victimDetailSync
        .syncVictimOrganisationDetail(acceptedWork.intakeAssessmentId);
    await _developmentAssessmentSync
        .syncDevelopmentAssessment(acceptedWork.intakeAssessmentId);

    await _personEducationSync.syncPersonEducationHealth(acceptedWork.personId);
    await _assessmentRegisterSync.syncAssesmentRegister(
        acceptedWork.intakeAssessmentId, acceptedWork.caseId);
    await _recommandationSync
        .syncRecommandationByAssessment(acceptedWork.intakeAssessmentId);
  }
}
  

  /*Future<void> startRunningBackgroundSyncJob() async {
    var userToken = await _authenticateRepository.getAllAuthTokens();
    for (var user in userToken) {
      //repopulate dash board
      await _dashboardSync.syncDashboard(user.userId);
      var acceptedWorkList =
          await _acceptedWorklistSync.syncAcceptedWorklist(user.userId);
      if (acceptedWorkList.isNotEmpty) {
        for (var acceptedWork in acceptedWorkList) {
          //sync child details
          await _personSync.syncPerson(acceptedWork.personId, user.userId);
          //medical health sync
          await _medicalHealthDetailSync
              .syncMedicalDetailHealth(acceptedWork.intakeAssessmentId);
          //Family Information sync
          await _familyInformationSync
              .syncFamilyInformation(acceptedWork.intakeAssessmentId);
          //Socio Economic sync
          await _socioEconomicSync
              .syncSocioEconomic(acceptedWork.intakeAssessmentId);
        }
      }
    }
  }*/

