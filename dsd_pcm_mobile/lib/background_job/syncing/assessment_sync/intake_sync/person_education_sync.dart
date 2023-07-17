import 'dart:io';
import 'package:flutter/foundation.dart';

import '../../../../domain/repository/intake/person_education_repository.dart';
import '../../../../model/intake/person_education_dto.dart';
import '../../../../service/intake/person_education_service.dart';
import '../../../../util/shared/apiresponse.dart';

class PersonEducationSync {
  final _personEducationRepository = PersonEducationRepository();
  final _personEducationService = PersonEducationService();
  late ApiResponse apiResponse = ApiResponse();
  late List<PersonEducationDto> personEducationsDto = [];

  Future<void> syncPersonEducationHealth(int? personId) async {
    var offlinePersonEducationHealthDto =
        _personEducationRepository.getAllPersonEducationByPersonId(personId!);
    if (offlinePersonEducationHealthDto.isNotEmpty) {
      for (var personEducation in offlinePersonEducationHealthDto) {
        try {
          apiResponse = await _personEducationService
              .addUdatePersonEducationOnline(personEducation);
          _personEducationRepository
              .deletePersonEducationById(personEducation.personEducationId!);
        } on SocketException catch (_) {
          if (kDebugMode) {
            print(
                'Unable to access _PersonEducationsService.syncPersonEducationHealth endpoint');
          }
        }
      }
    }
    //Repopulate offline box with latest data retrieve from end point
    await syncPersonEducationHealthOnlineToOffline(personId);
  }

  Future<void> syncPersonEducationHealthOnlineToOffline(int? personId) async {
    try {
      apiResponse = await _personEducationService
          .getPersonEducationByPersonIdOnline(personId);
      if ((apiResponse.ApiError) == null) {
        personEducationsDto = (apiResponse.Data as List<PersonEducationDto>);
        if (personEducationsDto.isNotEmpty) {
          await _personEducationRepository
              .savePersonEducationItems(personEducationsDto);
        }
      }
    } on SocketException catch (_) {
      if (kDebugMode) {
        print(
            'Unable to access _PersonEducationsService.syncPersonEducationHealthOnlineToOffline endpoint');
      }
    }
  }
}
