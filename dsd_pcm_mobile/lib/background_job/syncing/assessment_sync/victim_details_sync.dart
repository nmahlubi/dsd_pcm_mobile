import 'dart:io';
import 'package:flutter/foundation.dart';

import '../../../../util/shared/apiresponse.dart';
import '../../../domain/repository/assessment/victim_organisation_repository.dart';
import '../../../model/pcm/victim_organisation_detail_dto.dart';
import '../../../service/pcm/victim_service.dart';

class VictimDetailSync {
  final _victimOrganisationDetailRepository =
      VictimOrganisationDetailRepository();
  final _victimServiceClient = VictimService();
  late ApiResponse apiResponse = ApiResponse();
  late List<VictimOrganisationDetailDto> victimOrganisationDetailsDto = [];

  Future<void> syncVictimOrganisationDetail(int? assessmentId) async {
    var offlineVictimOrganisationDetailDto = _victimOrganisationDetailRepository
        .getAllVictimOrganisationDetailsByAssessmentId(assessmentId!);
    if (offlineVictimOrganisationDetailDto.isNotEmpty) {
      for (var victimOrganisationDetail in offlineVictimOrganisationDetailDto) {
        try {
          apiResponse = await _victimServiceClient
              .addUpdateVictimOrganisationOnline(victimOrganisationDetail);
          _victimOrganisationDetailRepository.deleteVictimOrganisationDetail(
              victimOrganisationDetail.victimOrganisationId!);
        } on SocketException catch (_) {
          if (kDebugMode) {
            print(
                'Unable to access _victimServiceClient.syncVictimOrganisationDetail endpoint');
          }
        }
      }
    }
    //Repopulate offline box with latest data retrieve from end point
    await syncVictimOrganisationDetailOnlineToOffline(assessmentId);
  }

  Future<void> syncVictimOrganisationDetailOnlineToOffline(
      int? assessmentId) async {
    try {
      apiResponse = await _victimServiceClient
          .getVictimOrganisationDetailByIntakeAssessmentId(assessmentId);
      if ((apiResponse.ApiError) == null) {
        victimOrganisationDetailsDto =
            (apiResponse.Data as List<VictimOrganisationDetailDto>);
        if (victimOrganisationDetailsDto.isNotEmpty) {
          await _victimOrganisationDetailRepository
              .saveVictimOrganisationDetailItems(victimOrganisationDetailsDto);
        }
      }
    } on SocketException catch (_) {
      if (kDebugMode) {
        print(
            'Unable to access _victimServiceClient.syncVictimOrganisationDetailOnlineToOffline endpoint');
      }
    }
  }
}
