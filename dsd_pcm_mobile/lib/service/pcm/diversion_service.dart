import 'dart:convert';
import 'dart:io';
import 'package:http_interceptor/http/intercepted_client.dart';
import '../../model/pcm/diversion_dto.dart';
import '../../model/pcm/program_enrolment_session_outcome_dto.dart';
import '../../model/pcm/programs_enrolled_dto.dart';
import '../../util/app_url.dart';
import '../../util/auth_intercept/authorization_interceptor.dart';
import '../../util/http_client_service.dart';
import '../../util/shared/apierror.dart';
import '../../util/shared/apiresponse.dart';
import '../../util/shared/apiresults.dart';

class DiversionService {
  final client =
      InterceptedClient.build(interceptors: [AuthorizationInterceptor()]);
  final _httpClientService = HttpClientService();

  Future<ApiResponse> getDiversionByAssessmentId(
      int? intakeAssessmentId) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final response = await client.get(
          Uri.parse("${AppUrl.pcmURL}/diversion/GetAll/$intakeAssessmentId"));

      switch (response.statusCode) {
        case 200:
          apiResponse.Data = (json.decode(response.body) as List)
              .map((data) => DiversionDto.fromJson(data))
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

  Future<ApiResponse> adddDiversion(DiversionDto diversionDto) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final response = await client.post(
          Uri.parse("${AppUrl.pcmURL}/diversion/Add"),
          body: json.encode(diversionDto),
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

  Future<ApiResponse> getProgramesEnrolledByAssessmentIdOnline(
      int? intakeAssessmentId) async {
    ApiResponse apiResponse = ApiResponse();
    final response = await client.get(Uri.parse(
        "${AppUrl.pcmURL}/Diversion/ProgrammEnrolled/GetAll/$intakeAssessmentId"));
    switch (response.statusCode) {
      case 200:
        apiResponse.Data = (json.decode(response.body) as List)
            .map((data) => ProgramsEnrolledDto.fromJson(data))
            .toList();
        break;
      default:
        apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
        break;
    }
    return apiResponse;
  }

  Future<ApiResponse> getProgramesEnrolledByAssessmentId(
      int? intakeAssessmentId) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      apiResponse =
          await getProgramesEnrolledByAssessmentIdOnline(intakeAssessmentId);
      if (apiResponse.ApiError == null) {
        List<ProgramsEnrolledDto> programesEnrolledDtoResponse =
            apiResponse.Data as List<ProgramsEnrolledDto>;
        apiResponse.Data = programesEnrolledDtoResponse;
      }
    } on SocketException {
      apiResponse.ApiError = ApiError(error: "Connection Error. Please retry");
    }
    return apiResponse;
  }

  Future<ApiResponse> addSessionOutcomeOnline(
      ProgramEnrolmentSessionOutcomeDto
          programEnrolmentSessionOutcomeDto) async {
    return await _httpClientService.httpClientPost(
        "${AppUrl.pcmURL}/Diversion/Session/Add",
        programEnrolmentSessionOutcomeDto);
  }

  Future<ApiResponse> addSessionOutcome(
      ProgramEnrolmentSessionOutcomeDto
          programEnrolmentSessionOutcomeDto) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      apiResponse =
          await addSessionOutcomeOnline(programEnrolmentSessionOutcomeDto);
      if (apiResponse.ApiError == null) {
        ApiResults apiResults = (apiResponse.Data as ApiResults);
        ProgramEnrolmentSessionOutcomeDto
            programEnrolmentSessionOutcomeDtoResponse =
            ProgramEnrolmentSessionOutcomeDto.fromJson(apiResults.data);
        apiResponse.Data = programEnrolmentSessionOutcomeDtoResponse;
      }
    } on SocketException {
      apiResponse.ApiError = ApiError(error: "Connection Error. Please retry");
    }
    return apiResponse;
  }

  Future<ApiResponse> addUpdateSessionOutcome(
      ProgramEnrolmentSessionOutcomeDto
          programEnrolmentSessionOutcomeDto) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      apiResponse = await addUpdateSessionOutcomeOnline(
          programEnrolmentSessionOutcomeDto);
      if (apiResponse.ApiError == null) {
        ApiResults apiResults = (apiResponse.Data as ApiResults);
        ProgramEnrolmentSessionOutcomeDto sessionOutcomeDtoResponse =
            ProgramEnrolmentSessionOutcomeDto.fromJson(apiResults.data);
        apiResponse.Data = sessionOutcomeDtoResponse;
      }
    } on SocketException {
      apiResponse.ApiError = ApiError(error: "Connection Error. Please retry");
    }
    return apiResponse;
  }

  Future<ApiResponse> addUpdateSessionOutcomeOnline(
      ProgramEnrolmentSessionOutcomeDto
          programEnrolmentSessionOutcomeDto) async {
    return await _httpClientService.httpClientPost(
        "${AppUrl.pcmURL}/Diversion/Session/AddUpdate",
        programEnrolmentSessionOutcomeDto);
  }
}
