import 'dart:io';
import 'package:flutter/foundation.dart';

import '../../../domain/repository/assessment/general_detail_repository.dart';
import '../../../model/pcm/general_detail_dto.dart';
import '../../../service/pcm/general_detail_service.dart';
import '../../../util/shared/apiresponse.dart';

class GeneralDetailSync {
  final _generalDetailRepository = GeneralDetailRepository();
  final _generalDetailServiceClient = GeneralDetailService();
  late ApiResponse apiResponse = ApiResponse();

  Future<void> syncGeneralDetail(int? assessmentId) async {
    var offlineGeneralDetailDto =
        _generalDetailRepository.getGeneralDetailByAssessmentId(assessmentId!);
    if (offlineGeneralDetailDto != null) {
      try {
        apiResponse = await _generalDetailServiceClient
            .addUpdateGeneralDetailOnline(offlineGeneralDetailDto);
        _generalDetailRepository
            .deleteGeneralDetailByAssessmentId(assessmentId);
      } on SocketException catch (_) {
        if (kDebugMode) {
          print(
              'Unable to access _generalDetailServiceClient.syncGeneralDetail endpoint');
        }
      }
    }
    //Repopulate offline box with latest data retrieve from end point
    await syncGeneralDetailOnlineToOffline(assessmentId);
  }

  Future<void> syncGeneralDetailOnlineToOffline(int? assessmentId) async {
    try {
      apiResponse = await _generalDetailServiceClient
          .getGeneralDetailByIntakeAssessmentIdOnline(assessmentId);
      if ((apiResponse.ApiError) == null) {
        GeneralDetailDto generalDetailDtoResponse =
            apiResponse.Data as GeneralDetailDto;
        await _generalDetailRepository
            .saveGeneralDetail(generalDetailDtoResponse);
      }
    } on SocketException catch (_) {
      if (kDebugMode) {
        print(
            'Unable to access _generalDetailServiceClient.syncGeneralDetailOnlineToOffline endpoint');
      }
    }
  }
}
