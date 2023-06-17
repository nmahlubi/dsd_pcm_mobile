import 'dart:convert';
import 'dart:io';
import 'package:dsd_pcm_mobile/model/intake/address_dto.dart';
import 'package:http_interceptor/http/intercepted_client.dart';

import '../../domain/repository/intake/address_repository.dart';
import '../../domain/repository/intake/address_type_repository.dart';
import '../../domain/repository/intake/person_address_repository.dart';
import '../../model/intake/address_type_dto.dart';
import '../../model/intake/person_address_dto.dart';
import '../../util/app_url.dart';
import '../../util/auth_intercept/authorization_interceptor.dart';
import '../../util/http_client_service.dart';
import '../../util/shared/apierror.dart';
import '../../util/shared/apiresponse.dart';
import '../../util/shared/apiresults.dart';

class AddressService {
  final client =
      InterceptedClient.build(interceptors: [AuthorizationInterceptor()]);
  final _addressTypeRepository = AddressTypeRepository();
  final _personAddressRepository = PersonAddressRepository();
  final _httpClientService = HttpClientService();

  Future<ApiResponse> getAddressByPersonIdOnline(int? personId) async {
    ApiResponse apiResponse = ApiResponse();
    final response = await client
        .get(Uri.parse("${AppUrl.intakeURL}/Address/Get/Person/$personId"));
    switch (response.statusCode) {
      case 200:
        apiResponse.Data = (json.decode(response.body) as List)
            .map((data) => PersonAddressDto.fromJson(data))
            .toList();
        break;
      default:
        apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
        break;
    }
    return apiResponse;
  }

  Future<ApiResponse> getAddressByPersonId(int? personId) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      apiResponse = await getAddressByPersonIdOnline(personId);
      if (apiResponse.ApiError == null) {
        List<PersonAddressDto> personAddressDtoResponse =
            apiResponse.Data as List<PersonAddressDto>;
        apiResponse.Data = personAddressDtoResponse;
        _personAddressRepository
            .savePersonAddressItems(personAddressDtoResponse);
      }
    } on SocketException {
      apiResponse.Data =
          _personAddressRepository.getPersonAddressByPersonId(personId!);
    }
    return apiResponse;
  }

  Future<ApiResponse> getAddressTypes() async {
    ApiResponse apiResponse = ApiResponse();
    try {
      if (_addressTypeRepository.getAllAddressTypes().isNotEmpty) {
        apiResponse.Data = _addressTypeRepository.getAllAddressTypes();
        return apiResponse;
      }
      final response =
          await client.get(Uri.parse("${AppUrl.intakeURL}/Address/Type/All"));
      switch (response.statusCode) {
        case 200:
          List<AddressTypeDto> addressTypeDtoResponse =
              (json.decode(response.body) as List)
                  .map((data) => AddressTypeDto.fromJson(data))
                  .toList();
          apiResponse.Data = addressTypeDtoResponse;
          _addressTypeRepository.saveAddressTypeItems(addressTypeDtoResponse);
          break;
        default:
          apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
          break;
      }
    } on SocketException {
      apiResponse.Data = _addressTypeRepository.getAllAddressTypes();
    }
    return apiResponse;
  }

  Future<ApiResponse> addPersonAddressOnline(
      PersonAddressDto personAddressDto) async {
    return await _httpClientService.httpClientPost(
        "${AppUrl.intakeURL}/Address/Add/Person", personAddressDto);
  }

  Future<ApiResponse> addPersonAddress(
      PersonAddressDto personAddressDto) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      apiResponse = await addPersonAddressOnline(personAddressDto);
      if (apiResponse.ApiError == null) {
        ApiResults apiResults = (apiResponse.Data as ApiResults);
        PersonAddressDto personAddressDtoResponse =
            PersonAddressDto.fromJson(apiResults.data);
        apiResponse.Data = personAddressDtoResponse;
        _personAddressRepository.savePersonAddress(personAddressDtoResponse);
      }
    } on SocketException {
      _personAddressRepository.savePersonAddress(personAddressDto);
      apiResponse.Data = _personAddressRepository
          .getPersonAddressById(personAddressDto.addressId!);
    }
    return apiResponse;
  }

  Future<ApiResponse> addUpdatePersonAddressOnline(
      PersonAddressDto personAddressDto) async {
    return await _httpClientService.httpClientPost(
        "${AppUrl.intakeURL}/Address/AddUpdate/Person", personAddressDto);
  }
}
