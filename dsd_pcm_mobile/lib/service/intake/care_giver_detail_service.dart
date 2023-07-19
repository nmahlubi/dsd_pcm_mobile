import 'dart:convert';
import 'dart:io';
import 'package:http_interceptor/http/intercepted_client.dart';

import '../../domain/repository/assessment/care_giver_detail_repository.dart';
import '../../model/intake/care_giver_details_dto.dart';
import '../../model/intake/person_dto.dart';
import '../../util/app_url.dart';
import '../../util/auth_intercept/authorization_interceptor.dart';
import '../../util/http_client_service.dart';
import '../../util/shared/apierror.dart';
import '../../util/shared/apiresponse.dart';
import '../../util/shared/apiresults.dart';
import 'person_service.dart';

class CareGiverDetailService {
  final client =
      InterceptedClient.build(interceptors: [AuthorizationInterceptor()]);
  final _personServiceClient = PersonService();
  final _httpClientService = HttpClientService();
  final _careGiverDetailRepository = CareGiverDetailRepository();

  Future<ApiResponse> getCareGiverDetailsByClientIdOnline(int? clientId) async {
    ApiResponse apiResponse = ApiResponse();
    final response = await client.get(
        Uri.parse("${AppUrl.intakeURL}/CareGiverDetails/GetAll/$clientId"));
    switch (response.statusCode) {
      case 200:
        apiResponse.Data = (json.decode(response.body) as List)
            .map((data) => CareGiverDetailsDto.fromJson(data))
            .toList();
        break;
      default:
        apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
        break;
    }
    return apiResponse;
  }

  Future<ApiResponse> getCareGiverDetailsByClientId(int? clientId) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      apiResponse = await getCareGiverDetailsByClientIdOnline(clientId);
      if (apiResponse.ApiError == null) {
        List<CareGiverDetailsDto> careGiverDetailsDtoResponse =
            apiResponse.Data as List<CareGiverDetailsDto>;
        apiResponse.Data = careGiverDetailsDtoResponse;
        _careGiverDetailRepository
            .saveCareGiverDetailItems(careGiverDetailsDtoResponse);
      }
    } on SocketException {
      apiResponse.Data = _careGiverDetailRepository
          .getAllCareGiverDetailsByClientId(clientId!);
    }
    return apiResponse;
  }

  Future<ApiResponse> addCareGiverDetailOnline(
      CareGiverDetailsDto careGiverDetailsDto) async {
    return await _httpClientService.httpClientPost(
        "${AppUrl.intakeURL}/CareGiverDetails/Add", careGiverDetailsDto);
  }

  Future<ApiResponse> addCareGiverDetail(
      CareGiverDetailsDto careGiverDetailsDto) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      apiResponse = await _personServiceClient
          .searchAddUdatePersonOnline(careGiverDetailsDto.personDto!);
      if (apiResponse.ApiError == null) {
        ApiResults apiResults = (apiResponse.Data as ApiResults);
        PersonDto personResponse = PersonDto.fromJson(apiResults.data);
        //Care Giver
        apiResponse = await addCareGiverDetailOnline(careGiverDetailsDto);
        if (apiResponse.ApiError == null) {
          ApiResults apiResults = (apiResponse.Data as ApiResults);
          CareGiverDetailsDto careGiverDetailsDtoResponse =
              CareGiverDetailsDto.fromJson(apiResults.data);
          apiResponse.Data = careGiverDetailsDtoResponse;
          _careGiverDetailRepository.saveCareGiverDetailAfterOnline(
              careGiverDetailsDtoResponse,
              personResponse.personId!,
              careGiverDetailsDtoResponse.clientCaregiverId!);
        }
      }
    } on SocketException {
      _careGiverDetailRepository.saveCareGiverDetail(careGiverDetailsDto);
      apiResponse.Data = _careGiverDetailRepository
          .getCareGiverDetailById(careGiverDetailsDto.clientCaregiverId!);
    }
    return apiResponse;
  }

  Future<ApiResponse> addUpdateCareGiverDetailOnline(
      CareGiverDetailsDto careGiverDetailsDto) async {
    return await _httpClientService.httpClientPost(
        "${AppUrl.intakeURL}/CareGiverDetails/AddUpdate", careGiverDetailsDto);
  }

  Future<ApiResponse> addUpdateCareGiverDetail(
      CareGiverDetailsDto careGiverDetailsDto) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      apiResponse = await addUpdateCareGiverDetailOnline(careGiverDetailsDto);
      if (apiResponse.ApiError == null) {
        ApiResults apiResults = (apiResponse.Data as ApiResults);
        CareGiverDetailsDto careGiverDetailsDtoResponse =
            CareGiverDetailsDto.fromJson(apiResults.data);
        apiResponse.Data = careGiverDetailsDtoResponse;
        _careGiverDetailRepository.saveCareGiverDetailAfterOnline(
            careGiverDetailsDtoResponse,
            careGiverDetailsDtoResponse.personId!,
            careGiverDetailsDtoResponse.clientCaregiverId!);
      }
    } on SocketException {
      _careGiverDetailRepository.saveCareGiverDetail(careGiverDetailsDto);
      apiResponse.Data = _careGiverDetailRepository
          .getCareGiverDetailById(careGiverDetailsDto.clientCaregiverId!);
    }
    return apiResponse;
  }
}
