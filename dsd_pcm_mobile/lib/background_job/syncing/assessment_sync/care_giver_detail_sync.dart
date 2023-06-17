import 'dart:io';
import 'package:flutter/foundation.dart';

import '../../../domain/repository/assessment/care_giver_detail_repository.dart';
import '../../../model/intake/care_giver_details_dto.dart';
import '../../../model/intake/person_dto.dart';
import '../../../service/intake/care_giver_detail_service.dart';
import '../../../service/intake/person_service.dart';
import '../../../util/shared/apiresponse.dart';
import '../../../util/shared/apiresults.dart';

class CareGiverDetailSync {
  final _careGiverDetailRepository = CareGiverDetailRepository();
  final _careGiverDetailService = CareGiverDetailService();
  final _personService = PersonService();
  late ApiResponse apiResponse = ApiResponse();
  late PersonDto personDto;
  late List<CareGiverDetailsDto> careGiverDetailsDto = [];

  Future<void> syncCareGiverDetail(int? clientId) async {
    var offlineCareGiverDetailsDto = await _careGiverDetailRepository
        .getAllCareGiverDetailsByClientId(clientId!);
    if (offlineCareGiverDetailsDto.isNotEmpty) {
      for (var careGiver in offlineCareGiverDetailsDto) {
        try {
          if (careGiver.personDto != null) {
            apiResponse = await _personService
                .searchAddUdatePersonOnline(careGiver.personDto!);
            if ((apiResponse.ApiError) == null) {
              ApiResults apiResults = (apiResponse.Data as ApiResults);
              PersonDto personDto = PersonDto.fromJson(apiResults.data);
              apiResponse = await _careGiverDetailService
                  .addCareGiverDetailOnline(careGiver, personDto.personId);
            }
          }
          _careGiverDetailRepository
              .getCareGiverDetailById(careGiver.clientCaregiverId!);
        } on SocketException catch (_) {
          if (kDebugMode) {
            print(
                'Unable to access _careGiverDetailService.syncCareGiverDetail endpoint');
          }
        }
      }
    }
    //Repopulate offline box with latest data retrieve from end point
    await syncCareGiverDetailsOnlineToOffline(clientId);
  }

  Future<void> syncCareGiverDetailsOnlineToOffline(int? clientId) async {
    try {
      apiResponse = await _careGiverDetailService
          .getCareGiverDetailsByClientIdOnline(clientId);
      if ((apiResponse.ApiError) == null) {
        careGiverDetailsDto = (apiResponse.Data as List<CareGiverDetailsDto>);
        if (careGiverDetailsDto.isNotEmpty) {
          await _careGiverDetailRepository
              .saveCareGiverDetailItems(careGiverDetailsDto);
        }
      }
    } on SocketException catch (_) {
      if (kDebugMode) {
        print(
            'Unable to access _careGiverDetailService.syncCareGiverDetailsOnlineToOffline endpoint');
      }
    }
  }
}
