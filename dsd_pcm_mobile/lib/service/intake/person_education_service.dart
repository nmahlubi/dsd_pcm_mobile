import 'dart:convert';
import 'dart:io';
import 'package:http_interceptor/http/intercepted_client.dart';

import '../../domain/repository/intake/person_education_repository.dart';
import '../../model/intake/person_education_dto.dart';
import '../../util/app_url.dart';
import '../../util/auth_intercept/authorization_interceptor.dart';
import '../../util/http_client_service.dart';
import '../../util/shared/apierror.dart';
import '../../util/shared/apiresponse.dart';
import '../../util/shared/apiresults.dart';

class PersonEducationService {
  final client =
      InterceptedClient.build(interceptors: [AuthorizationInterceptor()]);
  final _personEducationRepository = PersonEducationRepository();
  final _httpClientService = HttpClientService();

  Future<ApiResponse> getPersonEducationByPersonIdOnline(int? personId) async {
    ApiResponse apiResponse = ApiResponse();
    final response = await client
        .get(Uri.parse("${AppUrl.intakeURL}/Person/Educations/$personId"));
    switch (response.statusCode) {
      case 200:
        apiResponse.Data = (json.decode(response.body) as List)
            .map((data) => PersonEducationDto.fromJson(data))
            .toList();
        break;
      default:
        apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
        break;
    }
    return apiResponse;
  }

  Future<ApiResponse> getPersonEducationByPersonId(int? personId) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      apiResponse = await getPersonEducationByPersonIdOnline(personId);
      if (apiResponse.ApiError == null) {
        List<PersonEducationDto> personEducationDtoResponse =
            apiResponse.Data as List<PersonEducationDto>;
        apiResponse.Data = personEducationDtoResponse;
        _personEducationRepository
            .savePersonEducationItems(personEducationDtoResponse);
      }
    } on SocketException {
      apiResponse.Data =
          _personEducationRepository.getAllPersonEducationByPersonId(personId!);
    }
    return apiResponse;
  }

  Future<ApiResponse> addPersonEducationOnline(
      PersonEducationDto personEducationDto) async {
    return await _httpClientService.httpClientPost(
        "${AppUrl.intakeURL}/Person/Educations/Add", personEducationDto);
  }

  Future<ApiResponse> addPersonEducation(
      PersonEducationDto personEducationDto) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      apiResponse = await addPersonEducationOnline(personEducationDto);
      if (apiResponse.ApiError == null) {
        ApiResults apiResults = (apiResponse.Data as ApiResults);
        PersonEducationDto personEducationDtoResponse =
            PersonEducationDto.fromJson(apiResults.data);
        apiResponse.Data = personEducationDtoResponse;
        _personEducationRepository.savePersonEducationNewDbRecord(
            personEducationDto, personEducationDtoResponse.personEducationId);
      }
    } on SocketException {
      _personEducationRepository.savePersonEducation(personEducationDto);
      apiResponse.Data = _personEducationRepository
          .getAllPersonEducationByPersonId(personEducationDto.personId!);
    }
    return apiResponse;
  }

  Future<ApiResponse> addUdatePersonEducationOnline(
      PersonEducationDto personEducationDto) async {
    return await _httpClientService.httpClientPost(
        "${AppUrl.intakeURL}/Person/Educations/AddUpdate", personEducationDto);
  }
}
