import 'dart:io';
import 'package:flutter/foundation.dart';

import '../../../../domain/repository/intake/person_address_repository.dart';
import '../../../../model/intake/person_address_dto.dart';
import '../../../../service/intake/address_service.dart';
import '../../../../util/shared/apiresponse.dart';

class PersonAddressSync {
  final _personAddressRepository = PersonAddressRepository();
  final _addressServiceClient = AddressService();
  late ApiResponse apiResponse = ApiResponse();
  late List<PersonAddressDto> PersonAddresssDto = [];

  Future<void> syncPersonAddress(int? personId) async {
    var offlinePersonAddressDto =
        await _personAddressRepository.getPersonAddressByPersonId(personId!);
    if (offlinePersonAddressDto.isNotEmpty) {
      for (var personAddress in offlinePersonAddressDto) {
        try {
          apiResponse = await _addressServiceClient
              .addUpdatePersonAddressOnline(personAddress);
          _personAddressRepository
              .deletePersonAddress(personAddress.addressId!);
        } on SocketException catch (_) {
          if (kDebugMode) {
            print(
                'Unable to access _addressServiceClient.syncPersonAddress endpoint');
          }
        }
      }
    }
    //Repopulate offline box with latest data retrieve from end point
    await syncPersonAddressOnlineToOffline(personId);
  }

  Future<void> syncPersonAddressOnlineToOffline(int? personId) async {
    try {
      apiResponse =
          await _addressServiceClient.getAddressByPersonIdOnline(personId);
      if ((apiResponse.ApiError) == null) {
        PersonAddresssDto = (apiResponse.Data as List<PersonAddressDto>);
        if (PersonAddresssDto.isNotEmpty) {
          await _personAddressRepository
              .savePersonAddressItems(PersonAddresssDto);
        }
      }
    } on SocketException catch (_) {
      if (kDebugMode) {
        print(
            'Unable to access _addressServiceClient.syncPersonAddressOnlineToOffline endpoint');
      }
    }
  }
}
