import 'dart:convert';
import 'dart:io';
import 'package:http_interceptor/http/intercepted_client.dart';

import '../../model/child_notification/case_information_dto.dart';
import '../../model/child_notification/request/request_assign_case.dart';
import '../../util/app_url.dart';
import '../../util/auth_intercept/authorization_interceptor.dart';
import '../../util/shared/apierror.dart';
import '../../util/shared/apiresponse.dart';
import '../../util/shared/apiresults.dart';

class CaseInformationService {
  final client =
      InterceptedClient.build(interceptors: [AuthorizationInterceptor()]);

  Future<ApiResponse> assignCaseToProbationOfficer(
      RequestAssignCase requestAssignCase) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final response = await client.post(
          Uri.parse(
              "${AppUrl.childNotificationURL}/CaseInformation/AssignToProbationOfficer"),
          body: json.encode(requestAssignCase),
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

  Future<ApiResponse> getCaseInformationById(int? caseInformationId) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final response = await client.get(
          Uri.parse(
              "${AppUrl.childNotificationURL}/CaseInformation/$caseInformationId"),
          headers: {'Content-Type': 'application/json'});

      switch (response.statusCode) {
        case 200:
          CaseInformationDto caseInformationResponse =
              CaseInformationDto.fromJson(json.decode(response.body));
          apiResponse.Data = caseInformationResponse;
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

  Future<ApiResponse> getAllocatedCasesByProbationOfficerId(
      int? probationOfficerId) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final response = await client.get(
          Uri.parse(
              "${AppUrl.baseURL}/CaseInformation/Get/$probationOfficerId"),
          headers: {'Content-Type': 'application/json'});

      switch (response.statusCode) {
        case 200:
          List<CaseInformationDto> casesInformationResponse =
              (json.decode(response.body) as List)
                  .map((data) => CaseInformationDto.fromJson(data))
                  .toList();
          apiResponse.Data = casesInformationResponse;
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
}
