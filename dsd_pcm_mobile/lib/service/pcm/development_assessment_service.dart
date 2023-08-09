import 'dart:convert';
import 'dart:io';
import 'package:http_interceptor/http/intercepted_client.dart';

import '../../domain/repository/assessment/development_assessment_repository.dart';
import '../../model/pcm/development_assessment_dto.dart';
import '../../util/app_url.dart';
import '../../util/auth_intercept/authorization_interceptor.dart';
import '../../util/http_client_service.dart';
import '../../util/shared/apierror.dart';
import '../../util/shared/apiresponse.dart';
import '../../util/shared/apiresults.dart';

class DevelopmentAssessmentService {
  final client =
      InterceptedClient.build(interceptors: [AuthorizationInterceptor()]);
  final _httpClientService = HttpClientService();
  final _developmentAssessmentRepository = DevelopmentAssessmentRepository();

  Future<ApiResponse> getDevelopmentAssessmentById(int? developmentId) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final response = await client.get(
          Uri.parse("${AppUrl.pcmURL}/DevelopmentAssessment/$developmentId"));
      switch (response.statusCode) {
        case 200:
          apiResponse.Data =
              DevelopmentAssessmentDto.fromJson(json.decode(response.body));
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

  Future<ApiResponse> getDevelopmentAssessmentByIntakeAssessmentIdOnline(
      int? intakeAssessmentId) async {
    ApiResponse apiResponse = ApiResponse();
    final response = await client.get(Uri.parse(
        "${AppUrl.pcmURL}/DevelopmentAssessment/Get/$intakeAssessmentId"));
    switch (response.statusCode) {
      case 200:
        apiResponse.Data =
            DevelopmentAssessmentDto.fromJson(json.decode(response.body));
        break;
      default:
        apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
        break;
    }
    return apiResponse;
  }

  Future<ApiResponse> getDevelopmentAssessmentByIntakeAssessmentId(
      int? intakeAssessmentId) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      apiResponse = await getDevelopmentAssessmentByIntakeAssessmentIdOnline(
          intakeAssessmentId);
      if (apiResponse.ApiError == null) {
        DevelopmentAssessmentDto developmentAssessmentDtoResponse =
            apiResponse.Data as DevelopmentAssessmentDto;
        apiResponse.Data = developmentAssessmentDtoResponse;
        _developmentAssessmentRepository
            .saveDevelopmentAssessment(developmentAssessmentDtoResponse);
      }
    } on SocketException {
      apiResponse.Data = _developmentAssessmentRepository
          .getDevelopmentAssessmentById(intakeAssessmentId!);
    }
    return apiResponse;
  }

  Future<ApiResponse> addDevelopmentAssessmentOnline(
      DevelopmentAssessmentDto developmentAssessmentDto) async {
    return await _httpClientService.httpClientPost(
        "${AppUrl.pcmURL}/DevelopmentAssessment/Add", developmentAssessmentDto);
  }

  Future<ApiResponse> addDevelopmentAssessment(
      DevelopmentAssessmentDto developmentAssessmentDto) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      apiResponse =
          await addDevelopmentAssessmentOnline(developmentAssessmentDto);
      if (apiResponse.ApiError == null) {
        ApiResults apiResults = (apiResponse.Data as ApiResults);
        DevelopmentAssessmentDto developmentAssessmentDtoResponse =
            DevelopmentAssessmentDto.fromJson(apiResults.data);
        apiResponse.Data = developmentAssessmentDtoResponse;
        _developmentAssessmentRepository
            .saveDevelopmentAssessment(developmentAssessmentDtoResponse);
      }
    } on SocketException {
      _developmentAssessmentRepository
          .saveDevelopmentAssessment(developmentAssessmentDto);
      apiResponse.Data =
          _developmentAssessmentRepository.getDevelopmentAssessmentById(
              developmentAssessmentDto.developmentId!);
    }
    return apiResponse;
  }

  Future<ApiResponse> addUpdateDevelopmentAssessmentOnline(
      DevelopmentAssessmentDto developmentAssessmentDto) async {
    return await _httpClientService.httpClientPost(
        "${AppUrl.pcmURL}/DevelopmentAssessment/AddUpdate",
        developmentAssessmentDto);
  }

  Future<ApiResponse> addUpdateDevelopmentAssessment(
      DevelopmentAssessmentDto developmentAssessmentDto) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      apiResponse =
          await addUpdateDevelopmentAssessmentOnline(developmentAssessmentDto);
      if (apiResponse.ApiError == null) {
        ApiResults apiResults = (apiResponse.Data as ApiResults);
        DevelopmentAssessmentDto developmentAssessmentDtoResponse =
            DevelopmentAssessmentDto.fromJson(apiResults.data);
        apiResponse.Data = developmentAssessmentDtoResponse;
        _developmentAssessmentRepository
            .saveDevelopmentAssessment(developmentAssessmentDtoResponse);
      }
    } on SocketException {
      _developmentAssessmentRepository
          .saveDevelopmentAssessment(developmentAssessmentDto);
      apiResponse.Data =
          _developmentAssessmentRepository.getDevelopmentAssessmentById(
              developmentAssessmentDto.developmentId!);
    }
    return apiResponse;
  }
}
