import 'dart:io';
import 'package:flutter/foundation.dart';

import '../../../../util/shared/apiresponse.dart';
import '../../../domain/repository/assessment/socio_economic_repository.dart';
import '../../../model/pcm/socio_economic_dto.dart';
import '../../../service/pcm/socio_economic_service.dart';

class SocioEconomicSync {
  final _socioEconomicRepository = SocioEconomicRepository();
  final _socioEconomicService = SocioEconomicService();
  late ApiResponse apiResponse = ApiResponse();
  late List<SocioEconomicDto> socioEconomicsDto = [];

  Future<void> syncSocioEconomic(int? assessmentId) async {
    var offlineSocioEconomicDto =
        _socioEconomicRepository.getSocioEconomicsByAssessmentId(assessmentId!);
    if (offlineSocioEconomicDto != null) {
      try {
        apiResponse = await _socioEconomicService
            .addUpdateSocioEconomicOnline(offlineSocioEconomicDto);
        _socioEconomicRepository.deleteSocioEconomicByAssesmentId(assessmentId);
      } on SocketException catch (_) {
        if (kDebugMode) {
          print(
              'Unable to access _socioEconomicService.syncSocioEconomic endpoint');
        }
      }
    }
    //Repopulate offline box with latest data retrieve from end point
    await syncSocioEconomicOnlineToOffline(assessmentId);
  }

  Future<void> syncSocioEconomicOnlineToOffline(int? assessmentId) async {
    try {
      apiResponse = await _socioEconomicService
          .getsocioEconomicByAssessmentIdOnline(assessmentId);
      if ((apiResponse.ApiError) == null) {
        SocioEconomicDto socioEconomicDtoResponse =
            apiResponse.Data as SocioEconomicDto;
        await _socioEconomicRepository
            .saveSocioEconomic(socioEconomicDtoResponse);
      }
    } on SocketException catch (_) {
      if (kDebugMode) {
        print(
            'Unable to access _socioEconomicService.syncSocioEconomicOnlineToOffline endpoint');
      }
    }
  }
}
