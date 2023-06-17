import 'dart:io';
import 'package:flutter/foundation.dart';

import '../../../../domain/repository/intake/person_repository.dart';
import '../../../../model/intake/person_dto.dart';
import '../../../../service/intake/person_service.dart';
import '../../../../util/shared/apiresponse.dart';

class PersonSync {
  final _personRepository = PersonRepository();
  final _personService = PersonService();
  late ApiResponse apiResponse = ApiResponse();
  late PersonDto personDto;

  Future<void> syncPerson(int? personId, int? userId) async {
    var offlinePersonDto = await _personRepository.getPersonById(personId!);
    try {
      if (offlinePersonDto != null) {
        apiResponse = await _personService.updatePersonOnline(offlinePersonDto);
      } else {
        apiResponse =
            await _personService.getPersonByIdOnline(personId, userId);
        if ((apiResponse.ApiError) == null) {
          personDto = (apiResponse.Data as PersonDto);
          await _personRepository.savePerson(personDto, userId);
        }
      }
    } on SocketException catch (_) {
      if (kDebugMode) {
        print('Unable to access _personService.syncPerson endpoint');
      }
    }
  }
}
