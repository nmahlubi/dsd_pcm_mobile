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

  Future<ApiResponse> getsocioEconomicsByAssessmentIdOnline(
      int? intakeAssessmentId) async {
    ApiResponse apiResponse = ApiResponse();
    final response = await client.get(
        Uri.parse("${AppUrl.pcmURL}/SocioEconomic/GetAll/$intakeAssessmentId"));
    switch (response.statusCode) {
      case 200:
        apiResponse.Data = (json.decode(response.body) as List)
            .map((data) => SocioEconomicDto.fromJson(data))
            .toList();
        break;
      default:
        apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
        break;
    }
    return apiResponse;
  }

  Future<ApiResponse> getsocioEconomicsByAssessmentId(
      int? intakeAssessmentId) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      apiResponse =
          await getsocioEconomicsByAssessmentIdOnline(intakeAssessmentId);
      if (apiResponse.ApiError == null) {
        List<SocioEconomicDto> socioEconomicDtoResponse =
            apiResponse.Data as List<SocioEconomicDto>;
        apiResponse.Data = socioEconomicDtoResponse;
        _socioEconomicRepository
            .saveSocioEconomicItems(socioEconomicDtoResponse);
      }
    } on SocketException {
      apiResponse.Data = _socioEconomicRepository
          .getAllSocioEconomicsByAssessmentId(intakeAssessmentId!);
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
          .getSocioEconomicsById(socioEconomicDto.socioEconomyid!);
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
          .getSocioEconomicsById(socioEconomicDto.socioEconomyid!);
    }
    return apiResponse;
  }
}
