import 'dart:convert';
import 'dart:io';
import 'package:http_interceptor/http/intercepted_client.dart';

import '../../domain/repository/assessment/general_detail_repository.dart';
import '../../model/pcm/general_detail_dto.dart';
import '../../util/app_url.dart';
import '../../util/auth_intercept/authorization_interceptor.dart';
import '../../util/http_client_service.dart';
import '../../util/shared/apierror.dart';
import '../../util/shared/apiresponse.dart';
import '../../util/shared/apiresults.dart';

class GeneralDetailService {
  final client =
      InterceptedClient.build(interceptors: [AuthorizationInterceptor()]);
  final _generalDetailRepository = GeneralDetailRepository();
  final _httpClientService = HttpClientService();

  Future<ApiResponse> getGeneralDetailById(int? generalDetailId) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final response = await client
          .get(Uri.parse("${AppUrl.pcmURL}/GeneralDetail/$generalDetailId"));
      switch (response.statusCode) {
        case 200:
          apiResponse.Data =
              GeneralDetailDto.fromJson(json.decode(response.body));
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

  Future<ApiResponse> getGeneralDetailByIntakeAssessmentIdOnline(
      int? intakeAssessmentId) async {
    ApiResponse apiResponse = ApiResponse();
    final response = await client.get(
        Uri.parse("${AppUrl.pcmURL}/GeneralDetail/GetAll/$intakeAssessmentId"));
    switch (response.statusCode) {
      case 200:
        apiResponse.Data = (json.decode(response.body) as List)
            .map((data) => GeneralDetailDto.fromJson(data))
            .toList();
        break;
      default:
        apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
        break;
    }
    return apiResponse;
  }

  Future<ApiResponse> getGeneralDetailByIntakeAssessmentId(
      int? intakeAssessmentId) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      apiResponse =
          await getGeneralDetailByIntakeAssessmentIdOnline(intakeAssessmentId);
      if (apiResponse.ApiError == null) {
        List<GeneralDetailDto> generalDetailDtoResponse =
            apiResponse.Data as List<GeneralDetailDto>;
        apiResponse.Data = generalDetailDtoResponse;
        _generalDetailRepository
            .saveGeneralDetailItems(generalDetailDtoResponse);
      }
    } on SocketException {
      apiResponse.Data = _generalDetailRepository
          .getAllGeneralDetailsByAssessmentId(intakeAssessmentId!);
    }
    return apiResponse;
  }

  Future<ApiResponse> addGeneralDetailOnline(
      GeneralDetailDto generalDetailDto) async {
    return await _httpClientService.httpClientPost(
        "${AppUrl.pcmURL}/GeneralDetail/Add", generalDetailDto);
  }

  Future<ApiResponse> addGeneralDetail(
      GeneralDetailDto generalDetailDto) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      apiResponse = await addGeneralDetailOnline(generalDetailDto);
      if (apiResponse.ApiError == null) {
        ApiResults apiResults = (apiResponse.Data as ApiResults);
        GeneralDetailDto generalDetailDtoResponse =
            GeneralDetailDto.fromJson(apiResults.data);
        apiResponse.Data = generalDetailDtoResponse;
        _generalDetailRepository.saveGeneralDetailNewRecord(
            generalDetailDto, generalDetailDtoResponse.generalDetailsId);
      }
    } on SocketException {
      _generalDetailRepository.saveGeneralDetail(generalDetailDto);
      apiResponse.Data = _generalDetailRepository
          .getGeneralDetailById(generalDetailDto.generalDetailsId!);
    }
    return apiResponse;
  }

  Future<ApiResponse> addUpdateGeneralDetailOnline(
      GeneralDetailDto generalDetailDto) async {
    return await _httpClientService.httpClientPost(
        "${AppUrl.pcmURL}/GeneralDetail/AddUpdate", generalDetailDto);
  }

  Future<ApiResponse> addUpdateGeneralDetail(
      GeneralDetailDto generalDetailDto) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      apiResponse = await addUpdateGeneralDetailOnline(generalDetailDto);
      if (apiResponse.ApiError == null) {
        ApiResults apiResults = (apiResponse.Data as ApiResults);
        GeneralDetailDto generalDetailDtoResponse =
            GeneralDetailDto.fromJson(apiResults.data);
        apiResponse.Data = generalDetailDtoResponse;
        _generalDetailRepository.saveGeneralDetailNewRecord(
            generalDetailDto, generalDetailDtoResponse.generalDetailsId);
      }
    } on SocketException {
      _generalDetailRepository.saveGeneralDetail(generalDetailDto);
      apiResponse.Data = _generalDetailRepository
          .getGeneralDetailById(generalDetailDto.generalDetailsId!);
    }
    return apiResponse;
  }
}
