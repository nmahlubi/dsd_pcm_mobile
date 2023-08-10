import 'dart:convert';
import 'dart:io';
import 'package:dsd_pcm_mobile/model/pcm/home_based_supervision_dto.dart';
import 'package:http_interceptor/http/intercepted_client.dart';
import '../../model/pcm/hbs_conditions_dto.dart';
import '../../model/pcm/visitation_outcome_dto.dart';
import '../../util/app_url.dart';
import '../../util/auth_intercept/authorization_interceptor.dart';
import '../../util/http_client_service.dart';
import '../../util/shared/apierror.dart';
import '../../util/shared/apiresponse.dart';
import '../../util/shared/apiresults.dart';


class HomeBasedSupervisionService{
  
   final client = InterceptedClient.build(interceptors: [AuthorizationInterceptor()]);
  final _httpClientService = HttpClientService();
  
  Future<ApiResponse> getHomeBasedSupervisionDetailsByAssessmentId(
    
    int? intakeAssessmentId) async 
    {
      ApiResponse apiResponse = ApiResponse();
      try {
        final response = await client.get(Uri.parse(
            "${AppUrl.pcmURL}/HomeBasedSupervison/GetAll/$intakeAssessmentId"));

        switch (response.statusCode) {
          case 200:
            apiResponse.Data = (json.decode(response.body) as List)
                .map((data) => HomeBasedSupervionDto.fromJson(data))
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
   Future<ApiResponse> getHomeBasedSupervisionConditionsByAssessmentId(
    
    int? intakeAssessmentId) async 
    {
      ApiResponse apiResponse = ApiResponse();
      try {
        final response = await client.get(Uri.parse(
            "${AppUrl.pcmURL}/HomeBasedSupervison/Conditions/GetAll/$intakeAssessmentId"));

        switch (response.statusCode) {
          case 200:
            apiResponse.Data = (json.decode(response.body) as List)
                .map((data) => HBSConditionsDto.fromJson(data))
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

Future<ApiResponse> getVisitationOutcomeByAssessmentIdOnline(
      int? intakeAssessmentId) async {
    ApiResponse apiResponse = ApiResponse();
    final response = await client.get(Uri.parse(
        "${AppUrl.pcmURL}/HomeBasedSupervison/VisitationOutcome/Get/$intakeAssessmentId"));
    switch (response.statusCode) {
      case 200:
        apiResponse.Data = (json.decode(response.body) as List)
            .map((data) => VisitationOutcomeDto.fromJson(data))
            .toList();
        break;
      default:
        apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
        break;
    }
    return apiResponse;
  }

  Future<ApiResponse> getVisitationOutcomeByAssessmentId(
      int? intakeAssessmentId) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      apiResponse =
          await getVisitationOutcomeByAssessmentIdOnline(intakeAssessmentId);
      if (apiResponse.ApiError == null) {
        List<VisitationOutcomeDto> visitationOutcomeDtoResponse =
            apiResponse.Data as List<VisitationOutcomeDto>;
        apiResponse.Data = visitationOutcomeDtoResponse;
      }
    } on SocketException {
     apiResponse.ApiError = ApiError(error: "Connection Error. Please retry");
    }
    return apiResponse;
  }

  Future<ApiResponse> addVisitationOutcomeOnline(
      VisitationOutcomeDto visitationOutcomeDto) async {
    return await _httpClientService.httpClientPost(
        "${AppUrl.pcmURL}/HomeBasedSupervison/VisitationOutcome/Add", visitationOutcomeDto);
  }

  Future<ApiResponse> addVisitationOutcome(
      VisitationOutcomeDto visitationOutcomeDto) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      apiResponse = await addVisitationOutcomeOnline(visitationOutcomeDto);
      if (apiResponse.ApiError == null) {
        ApiResults apiResults = (apiResponse.Data as ApiResults);
        VisitationOutcomeDto visitationOutcomeDtoResponse =
            VisitationOutcomeDto.fromJson(apiResults.data);
        apiResponse.Data = visitationOutcomeDtoResponse;

      }
    } on SocketException {
      apiResponse.ApiError = ApiError(error: "Connection Error. Please retry");
    }
    return apiResponse;
  }

  Future<ApiResponse> addUpdateVisitationOutcomeOnline(
      VisitationOutcomeDto visitationOutcomeDto) async {
    return await _httpClientService.httpClientPost(
        "${AppUrl.pcmURL}/HomeBasedSupervison/VisitationOutcome/AddUpdate", visitationOutcomeDto);
  }
  
 Future<ApiResponse> addUpdateVisitationOutcome(
      VisitationOutcomeDto visitationOutcomeDto) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      apiResponse =
          await addUpdateVisitationOutcomeOnline(visitationOutcomeDto);
      if (apiResponse.ApiError == null) {
        ApiResults apiResults = (apiResponse.Data as ApiResults);
        VisitationOutcomeDto visitationOutcomeDtoResponse =
            VisitationOutcomeDto.fromJson(apiResults.data);
        apiResponse.Data = visitationOutcomeDtoResponse;

      }
    } on SocketException {
     apiResponse.ApiError = ApiError(error: "Connection Error. Please retry");
    }
    return apiResponse;
  }
  
}
