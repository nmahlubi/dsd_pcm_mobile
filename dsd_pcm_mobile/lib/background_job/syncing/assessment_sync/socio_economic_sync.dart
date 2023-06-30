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
    var offlineSocioEconomicDto = await _socioEconomicRepository
        .getAllSocioEconomicsByAssessmentId(assessmentId!);
    if (offlineSocioEconomicDto.isNotEmpty) {
      for (var socioEconomic in offlineSocioEconomicDto) {
        try {
          apiResponse = await _socioEconomicService
              .addUpdateSocioEconomicOnline(socioEconomic);
          _socioEconomicRepository
              .deleteSocioEconomic(socioEconomic.socioEconomyid!);
        } on SocketException catch (_) {
          if (kDebugMode) {
            print(
                'Unable to access _socioEconomicService.syncSocioEconomic endpoint');
          }
        }
      }
    }
    //Repopulate offline box with latest data retrieve from end point
    await syncSocioEconomicOnlineToOffline(assessmentId);
  }

  Future<void> syncSocioEconomicOnlineToOffline(int? assessmentId) async {
    try {
      apiResponse = await _socioEconomicService
          .getsocioEconomicsByAssessmentIdOnline(assessmentId);
      if ((apiResponse.ApiError) == null) {
        socioEconomicsDto = (apiResponse.Data as List<SocioEconomicDto>);
        if (socioEconomicsDto.isNotEmpty) {
          await _socioEconomicRepository
              .saveSocioEconomicItems(socioEconomicsDto);
        }
      }
    } on SocketException catch (_) {
      if (kDebugMode) {
        print(
            'Unable to access _socioEconomicService.syncSocioEconomicOnlineToOffline endpoint');
      }
    }
  }
}
