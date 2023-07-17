import 'dart:io';
import 'package:flutter/foundation.dart';

import '../../../../util/shared/apiresponse.dart';
import '../../../domain/repository/assessment/offence_detail_repository.dart';
import '../../../model/pcm/offence_detail_dto.dart';
import '../../../service/pcm/offence_detail_service.dart';

class OffenceDetailSync {
  final _offenceDetailRepository = OffenceDetailRepository();
  final _offenceDetailServiceClient = OffenceDetailService();
  late ApiResponse apiResponse = ApiResponse();
  late List<OffenceDetailDto> offenceDetailsDto = [];

  Future<void> syncOffenceDetail(int? assessmentId) async {
    var offlineOffenceDetailDto = _offenceDetailRepository
        .getAllOffenceDetailsByAssessmentId(assessmentId!);
    if (offlineOffenceDetailDto.isNotEmpty) {
      for (var offenceDetail in offlineOffenceDetailDto) {
        try {
          apiResponse = await _offenceDetailServiceClient
              .addUpdateOffenceDetailOnline(offenceDetail);
          _offenceDetailRepository
              .deleteOffenceDetail(offenceDetail.pcmOffenceId!);
        } on SocketException catch (_) {
          if (kDebugMode) {
            print(
                'Unable to access _offenceDetailServiceClient.syncOffenceDetail endpoint');
          }
        }
      }
    }
    //Repopulate offline box with latest data retrieve from end point
    await syncOffenceDetailOnlineToOffline(assessmentId);
  }

  Future<void> syncOffenceDetailOnlineToOffline(int? assessmentId) async {
    try {
      apiResponse = await _offenceDetailServiceClient
          .getOffenceDetailIntakeAssessmentIdOnline(assessmentId);
      if ((apiResponse.ApiError) == null) {
        offenceDetailsDto = (apiResponse.Data as List<OffenceDetailDto>);
        if (offenceDetailsDto.isNotEmpty) {
          await _offenceDetailRepository
              .saveOffenceDetailItems(offenceDetailsDto);
        }
      }
    } on SocketException catch (_) {
      if (kDebugMode) {
        print(
            'Unable to access _offenceDetailServiceClient.syncOffenceDetailOnlineToOffline endpoint');
      }
    }
  }
}
