import 'dart:convert';
import 'dart:io';
import 'package:dsd_pcm_mobile/model/intake/person_dto.dart';
import 'package:http_interceptor/http/intercepted_client.dart';

import '../../domain/repository/intake/person_repository.dart';
import '../../domain/repository/worklist/accepted_worklist_repository.dart';
import '../../model/intake/person_education_query_dto.dart';
import '../../model/pcm/accepted_worklist_dto.dart';
import '../../util/app_url.dart';
import '../../util/auth_intercept/authorization_interceptor.dart';
import '../../util/http_client_service.dart';
import '../../util/shared/apierror.dart';
import '../../util/shared/apiresponse.dart';
import '../../util/shared/apiresults.dart';

class PersonService {
  final client =
      InterceptedClient.build(interceptors: [AuthorizationInterceptor()]);
  final _personRepository = PersonRepository();
  final _acceptedWorklistRepository = AcceptedWorklistRepository();
  final _httpClientService = HttpClientService();

  Future<ApiResponse> getPersonByIdOnline(int? personId, int? userId) async {
    ApiResponse apiResponse = ApiResponse();
    final response =
        await client.get(Uri.parse("${AppUrl.intakeURL}/Person/Get/$personId"));
    switch (response.statusCode) {
      case 200:
        apiResponse.Data = PersonDto.fromJson(json.decode(response.body));
        break;
      default:
        apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
        break;
    }
    return apiResponse;
  }

  Future<ApiResponse> getPersonById(int? personId, int? userId) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      apiResponse = await getPersonByIdOnline(personId, userId);
      if (apiResponse.ApiError == null) {
        PersonDto personDtoResponse = apiResponse.Data as PersonDto;
        apiResponse.Data = personDtoResponse;
        _personRepository.savePerson(personDtoResponse, userId);
      }
    } on SocketException {
      apiResponse.Data = _personRepository.getPersonById(personId!);
    }
    return apiResponse;
  }

  Future<ApiResponse> addPersonOnline(PersonDto personDto) async {
    return await _httpClientService.httpClientPost(
        "${AppUrl.intakeURL}/Person/Add", personDto);
  }

  Future<ApiResponse> addPerson(PersonDto personDto) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final response = await client.post(
          Uri.parse("${AppUrl.intakeURL}/Person/Add"),
          body: json.encode(personDto),
          headers: {'Content-Type': 'application/json'});
      switch (response.statusCode) {
        case 200:
          ApiResults apiResults =
              ApiResults.fromJson(json.decode(response.body));
          apiResponse.Data = apiResults;
          PersonDto personDto = PersonDto.fromJson(json.decode(response.body));
          apiResponse.Data = personDto;
          _personRepository.savePerson(personDto, 8);
          break;
        default:
          apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
          break;
      }
    } on SocketException {
      apiResponse.Data = _personRepository.getPersonById(personDto.personId!);
    }
    return apiResponse;
  }

  Future<ApiResponse> updatePersonOnline(PersonDto personDto) async {
    return await _httpClientService.httpClientPost(
        "${AppUrl.intakeURL}/Person/Update", personDto);
  }

  Future<ApiResponse> updatePerson(PersonDto personDto, int userId,
      AcceptedWorklistDto acceptedWorklistDto) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      apiResponse = await updatePersonOnline(personDto);
      if (apiResponse.ApiError == null) {
        ApiResults apiResults = (apiResponse.Data as ApiResults);
        PersonDto personDtoResponse = PersonDto.fromJson(apiResults.data);
        apiResponse.Data = personDtoResponse;
        _personRepository.savePersonNewDbRecord(
            personDto, userId, personDtoResponse.personId);
        _acceptedWorklistRepository.saveAcceptedWorklistSingle(
            acceptedWorklistDto, userId);
      }
    } on SocketException {
      _personRepository.savePerson(personDto, userId);
      _acceptedWorklistRepository.saveAcceptedWorklistSingle(
          acceptedWorklistDto, userId);
      apiResponse.Data = _personRepository.getPersonById(personDto.personId!);
    }
    return apiResponse;
  }

  Future<ApiResponse> getEducationByPersonId(int? personId) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final response = await client
          .get(Uri.parse("${AppUrl.intakeURL}/Person/Educations/$personId"));
      switch (response.statusCode) {
        case 200:
          apiResponse.Data = (json.decode(response.body) as List)
              .map((data) => PersonEducationQueryDto.fromJson(data))
              .toList();
          break;
        default:
          apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
          break;
      }
    } on SocketException {
      apiResponse.ApiError = ApiError(error: "Connection Error. Please retry");
    }
    return apiResponse;
  }

  Future<ApiResponse> searchAddUdatePersonOnline(PersonDto personDto) async {
    return await _httpClientService.httpClientPost(
        "${AppUrl.intakeURL}/Person/AddPersonNotExist", personDto);
  }
}
