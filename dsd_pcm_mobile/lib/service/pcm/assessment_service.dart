import 'dart:convert';
import 'dart:io';
import 'package:http_interceptor/http/intercepted_client.dart';

import '../../domain/repository/assessment/assesment_register_repository.dart';
import '../../model/pcm/assesment_register_dto.dart';
import '../../model/pcm/query/assessment_count_query_dto.dart';
import '../../util/app_url.dart';
import '../../util/auth_intercept/authorization_interceptor.dart';
import '../../util/http_client_service.dart';
import '../../util/shared/apierror.dart';
import '../../util/shared/apiresponse.dart';
import '../../util/shared/apiresults.dart';

class AssessmentService {
  final _httpClientService = HttpClientService();
  final client =
      InterceptedClient.build(interceptors: [AuthorizationInterceptor()]);
  final _assesmentRegisterRepository = AssesmentRegisterRepository();

  Future<ApiResponse> getAssessmentCountByIntakeAssessmentId(
      int? intakeAssessmentId, int? personId) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final response = await client.get(Uri.parse(
          "${AppUrl.pcmURL}/Assessment/Count/$intakeAssessmentId/$personId"));
      switch (response.statusCode) {
        case 200:
          apiResponse.Data =
              AssessmentCountQueryDto.fromJson(json.decode(response.body));
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

  Future<ApiResponse> getAssesmentRegisterByAssessmentIdOnline(
      int? intakeAssessmentId, int? caseId) async {
    ApiResponse apiResponse = ApiResponse();
    final response = await client.get(Uri.parse(
        "${AppUrl.pcmURL}/Assessment/Register/$intakeAssessmentId/$caseId"));
    switch (response.statusCode) {
      case 200:
        apiResponse.Data =
            AssesmentRegisterDto.fromJson(json.decode(response.body));
        break;
      default:
        apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
        break;
    }
    return apiResponse;
  }

  Future<ApiResponse> getAssesmentRegisterByAssessmentId(
      int? intakeAssessmentId, int? caseId) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      apiResponse = await getAssesmentRegisterByAssessmentIdOnline(
          intakeAssessmentId, caseId);
      if (apiResponse.ApiError == null) {
        if (apiResponse.Data != null) {
          AssesmentRegisterDto assesmentRegisterDtoResponse =
              apiResponse.Data as AssesmentRegisterDto;
          apiResponse.Data = assesmentRegisterDtoResponse;
          _assesmentRegisterRepository
              .saveAssesmentRegister(assesmentRegisterDtoResponse);
        }
      }
    } on SocketException {
      apiResponse.Data = _assesmentRegisterRepository
          .getAssesmentRegisterByAssessmentId(intakeAssessmentId!);
    }
    return apiResponse;
  }

  Future<ApiResponse> addUpdateAssesmentRegisterOnline(
      AssesmentRegisterDto assesmentRegisterDto) async {
    return await _httpClientService.httpClientPost(
        "${AppUrl.pcmURL}/Assessment/Register/AddUpdate", assesmentRegisterDto);
  }

  Future<ApiResponse> addUpdateAssesmentRegister(
      AssesmentRegisterDto assesmentRegisterDto) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      apiResponse =
          await addUpdateAssesmentRegisterOnline(assesmentRegisterDto);
      if (apiResponse.ApiError == null) {
        ApiResults apiResults = (apiResponse.Data as ApiResults);
        AssesmentRegisterDto assesmentRegisterDtoResponse =
            AssesmentRegisterDto.fromJson(apiResults.data);
        apiResponse.Data = assesmentRegisterDtoResponse;
        _assesmentRegisterRepository.saveAssesmentRegisterAfterOnline(
            assesmentRegisterDto,
            assesmentRegisterDtoResponse.assesmentRegisterId!);
      }
    } on SocketException {
      _assesmentRegisterRepository.saveAssesmentRegister(assesmentRegisterDto);
      apiResponse.Data =
          _assesmentRegisterRepository.getAssesmentRegisterByAssessmentId(
              assesmentRegisterDto.intakeAssessmentId!);
    }
    return apiResponse;
  }
}
