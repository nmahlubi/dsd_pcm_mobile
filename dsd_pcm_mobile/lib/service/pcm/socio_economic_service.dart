import 'dart:convert';
import 'dart:io';

import 'package:http_interceptor/http/intercepted_client.dart';

import '../../domain/repository/assessment/socio_economic_repository.dart';
import '../../model/pcm/socio_economic_dto.dart';
import '../../util/app_url.dart';
import '../../util/auth_intercept/authorization_interceptor.dart';
import '../../util/http_client_service.dart';
import '../../util/shared/apierror.dart';
import '../../util/shared/apiresponse.dart';
import '../../util/shared/apiresults.dart';

class SocioEconomicService {
  final client =
      InterceptedClient.build(interceptors: [AuthorizationInterceptor()]);
  final _httpClientService = HttpClientService();
  final _socioEconomicRepository = SocioEconomicRepository();

  Future<ApiResponse> getsocioEconomicByAssessmentIdOnline(
      int? intakeAssessmentId) async {
    ApiResponse apiResponse = ApiResponse();
    final response = await client.get(
        Uri.parse("${AppUrl.pcmURL}/SocioEconomic/Get/$intakeAssessmentId"));
    switch (response.statusCode) {
      case 200:
        apiResponse.Data =
            SocioEconomicDto.fromJson(json.decode(response.body));
        break;
      default:
        apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
        break;
    }
    return apiResponse;
  }

  Future<ApiResponse> getsocioEconomicByAssessmentId(
      int? intakeAssessmentId) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      apiResponse =
          await getsocioEconomicByAssessmentIdOnline(intakeAssessmentId);
      if (apiResponse.ApiError == null) {
        SocioEconomicDto recommendationDtoResponse =
            apiResponse.Data as SocioEconomicDto;
        apiResponse.Data = recommendationDtoResponse;
        _socioEconomicRepository.saveSocioEconomic(recommendationDtoResponse);
      }
    } on SocketException {
      apiResponse.Data = _socioEconomicRepository
          .getSocioEconomicsByAssessmentId(intakeAssessmentId!);
    }
    return apiResponse;
  }

  Future<ApiResponse> addSocioEconomicOnline(
      SocioEconomicDto socioEconomicDto) async {
    return await _httpClientService.httpClientPost(
        "${AppUrl.pcmURL}/SocioEconomic/Add", socioEconomicDto);
  }

  Future<ApiResponse> addSocioEconomic(
      SocioEconomicDto socioEconomicDto) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      apiResponse = await addSocioEconomicOnline(socioEconomicDto);
      if (apiResponse.ApiError == null) {
        ApiResults apiResults = (apiResponse.Data as ApiResults);
        SocioEconomicDto socioEconomicDtoResponse =
            SocioEconomicDto.fromJson(apiResults.data);
        apiResponse.Data = socioEconomicDtoResponse;
        _socioEconomicRepository.saveSocioEconomic(socioEconomicDtoResponse);
      }
    } on SocketException {
      _socioEconomicRepository.saveSocioEconomic(socioEconomicDto);
      apiResponse.Data = _socioEconomicRepository
          .getSocioEconomicsByAssessmentId(socioEconomicDto.socioEconomyid!);
    }
    return apiResponse;
  }

  Future<ApiResponse> addUpdateSocioEconomicOnline(
      SocioEconomicDto socioEconomicDto) async {
    return await _httpClientService.httpClientPost(
        "${AppUrl.pcmURL}/SocioEconomic/AddUpdate", socioEconomicDto);
  }

  Future<ApiResponse> addUpdateSocioEconomic(
      SocioEconomicDto socioEconomicDto) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      apiResponse = await addUpdateSocioEconomicOnline(socioEconomicDto);
      if (apiResponse.ApiError == null) {
        ApiResults apiResults = (apiResponse.Data as ApiResults);
        SocioEconomicDto socioEconomicDtoResponse =
            SocioEconomicDto.fromJson(apiResults.data);
        apiResponse.Data = socioEconomicDtoResponse;
        _socioEconomicRepository.saveSocioEconomic(socioEconomicDtoResponse);
      }
    } on SocketException {
      _socioEconomicRepository.saveSocioEconomic(socioEconomicDto);
      apiResponse.Data = _socioEconomicRepository
          .getSocioEconomicsByAssessmentId(socioEconomicDto.socioEconomyid!);
    }
    return apiResponse;
  }
}
