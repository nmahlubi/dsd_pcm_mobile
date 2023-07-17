import 'dart:io';
import 'package:flutter/foundation.dart';

import '../../../../util/shared/apiresponse.dart';
import '../../../domain/repository/assessment/family_information_repository.dart';
import '../../../model/pcm/family_information_dto.dart';
import '../../../service/pcm/family_service.dart';

class FamilyInformationSync {
  final _familyInformationRepository = FamilyInformationRepository();
  final _familyServiceService = FamilyService();
  late ApiResponse apiResponse = ApiResponse();
  late List<FamilyInformationDto> familyInformationsDto = [];

  Future<void> syncFamilyInformation(int? assessmentId) async {
    var offlineFamilyInformationDto = _familyInformationRepository
        .getAllFamilyInformationsByAssessmentId(assessmentId!);
    if (offlineFamilyInformationDto.isNotEmpty) {
      for (var familyInfo in offlineFamilyInformationDto) {
        try {
          apiResponse = await _familyServiceService
              .addUpdateFamilyInformationOnline(familyInfo);
          _familyInformationRepository
              .deleteFamilyInformation(familyInfo.familyInformationId!);
        } on SocketException catch (_) {
          if (kDebugMode) {
            print(
                'Unable to access _familyServiceService.syncFamilyInformation endpoint');
          }
        }
      }
    }
    //Repopulate offline box with latest data retrieve from end point
    await syncFamilyInformationOnlineToOffline(assessmentId);
  }

  Future<void> syncFamilyInformationOnlineToOffline(int? assessmentId) async {
    try {
      apiResponse = await _familyServiceService
          .getFamilyInformationByAssessmentIdOnline(assessmentId);
      if ((apiResponse.ApiError) == null) {
        familyInformationsDto =
            (apiResponse.Data as List<FamilyInformationDto>);
        if (familyInformationsDto.isNotEmpty) {
          await _familyInformationRepository
              .saveFamilyInformationItems(familyInformationsDto);
        }
      }
    } on SocketException catch (_) {
      if (kDebugMode) {
        print(
            'Unable to access _familyServiceService.syncFamilyInformationOnlineToOffline endpoint');
      }
    }
  }
}
