import 'dart:convert';
import 'dart:io';

import 'package:http_interceptor/http/intercepted_client.dart';

import '../../domain/repository/assessment/medical_health_detail_repository.dart';
import '../../model/pcm/medical_health_detail_dto.dart';
import '../../util/app_url.dart';
import '../../util/auth_intercept/authorization_interceptor.dart';
import '../../util/http_client_service.dart';
import '../../util/shared/apierror.dart';
import '../../util/shared/apiresponse.dart';
import '../../util/shared/apiresults.dart';

class MedicalHealthDetailsService {
  final client =
      InterceptedClient.build(interceptors: [AuthorizationInterceptor()]);
  final _httpClientService = HttpClientService();
  final _medicalHealthDetailRepository = MedicalHealthDetailRepository();

  Future<ApiResponse> getMedicalHealthDetailsByAssessmentIdOnline(
      int? intakeAssessmentId) async {
    ApiResponse apiResponse = ApiResponse();
    final response = await client.get(Uri.parse(
        "${AppUrl.pcmURL}/Medical/HealthDetails/GetAll/$intakeAssessmentId"));
    switch (response.statusCode) {
      case 200:
        apiResponse.Data = (json.decode(response.body) as List)
            .map((data) => MedicalHealthDetailDto.fromJson(data))
            .toList();
        break;
      default:
        apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
        break;
    }
    return apiResponse;
  }

  Future<ApiResponse> getMedicalHealthDetailsByAssessmentId(
      int? intakeAssessmentId) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      apiResponse =
          await getMedicalHealthDetailsByAssessmentIdOnline(intakeAssessmentId);
      if (apiResponse.ApiError == null) {
        List<MedicalHealthDetailDto> medicalHealthDetailDtoResponse =
            apiResponse.Data as List<MedicalHealthDetailDto>;
        apiResponse.Data = medicalHealthDetailDtoResponse;
        _medicalHealthDetailRepository
            .saveMedicalHealthDetailItems(medicalHealthDetailDtoResponse);
      }
    } on SocketException {
      apiResponse.Data = _medicalHealthDetailRepository
          .getAllMedicalHealthDetailsByAssessmentId(intakeAssessmentId!);
    }
    return apiResponse;
  }

  Future<ApiResponse> addMedicalHealthDetailOnline(
      MedicalHealthDetailDto medicalHealthDetailDto) async {
    return await _httpClientService.httpClientPost(
        "${AppUrl.pcmURL}/Medical/HealthDetails/Add", medicalHealthDetailDto);
  }

  Future<ApiResponse> addMedicalHealthDetail(
      MedicalHealthDetailDto medicalHealthDetailDto) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      apiResponse = await addMedicalHealthDetailOnline(medicalHealthDetailDto);
      if (apiResponse.ApiError == null) {
        ApiResults apiResults = (apiResponse.Data as ApiResults);
        MedicalHealthDetailDto medicalHealthDetailDtoResponse =
            MedicalHealthDetailDto.fromJson(apiResults.data);
        apiResponse.Data = medicalHealthDetailDtoResponse;
        _medicalHealthDetailRepository
            .saveMedicalHealthDetail(medicalHealthDetailDtoResponse);
      }
    } on SocketException {
      _medicalHealthDetailRepository
          .saveMedicalHealthDetail(medicalHealthDetailDto);
      apiResponse.Data = _medicalHealthDetailRepository
          .getMedicalHealthDetailsById(medicalHealthDetailDto.healthDetailsId!);
    }
    return apiResponse;
  }

/*
 Future<ApiResponse> addMedicalHealthDetail(
      MedicalHealthDetailDto medicalHealthDetailDto) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final response = await client.post(
          Uri.parse("${AppUrl.pcmURL}/Medical/HealthDetails/Add"),
          body: json.encode(medicalHealthDetailDto),
          headers: {'Content-Type': 'application/json'});

      switch (response.statusCode) {
        case 200:
          ApiResults apiResults =
              ApiResults.fromJson(json.decode(response.body));
          apiResponse.Data = apiResults;
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
  */

  /* Future<ApiResponse> addMedicalHealthDetailOnline(
      MedicalHealthDetailDto medicalHealthDetailDto) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final response = await client.post(
          Uri.parse("${AppUrl.pcmURL}/Medical/HealthDetails/Add"),
          body: json.encode(medicalHealthDetailDto),
          headers: {'Content-Type': 'application/json'});

      switch (response.statusCode) {
        case 200:
          ApiResults apiResults =
              ApiResults.fromJson(json.decode(response.body));
          apiResponse.Data = apiResults;
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

  Future<ApiResponse> addMedicalHealthDetail(
      MedicalHealthDetailDto medicalHealthDetailDto) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final response = await client.post(
          Uri.parse("${AppUrl.pcmURL}/Medical/HealthDetails/Add"),
          body: json.encode(medicalHealthDetailDto),
          headers: {'Content-Type': 'application/json'});

      switch (response.statusCode) {
        case 200:
          ApiResults apiResults =
              ApiResults.fromJson(json.decode(response.body));
          apiResponse.Data = apiResults;
          break;
        default:
          apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
          break;
      }
    } on SocketException {
      apiResponse.ApiError = ApiError(error: "Connection Error. Please retry");
    }
    return apiResponse;
  }*/
}
