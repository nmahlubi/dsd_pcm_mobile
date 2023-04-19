import 'dart:convert';
import 'dart:io';
import 'package:http_interceptor/http/intercepted_client.dart';

import '../../model/pcm/allocated_case_probation_officer_dto.dart';
import '../../model/pcm/allocated_case_supervisor_dto.dart';
import '../../model/pcm/request/re_allocate_case.dart';
import '../../util/app_url.dart';
import '../../util/auth_intercept/authorization_interceptor.dart';
import '../../util/shared/apierror.dart';
import '../../util/shared/apiresponse.dart';
import '../../util/shared/apiresults.dart';

class EndPointInboxService {
  final client =
      InterceptedClient.build(interceptors: [AuthorizationInterceptor()]);

  Future<ApiResponse> getAllocatedCasesByProbationOfficer(
      int? probationOfficerId) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final response = await client.get(Uri.parse(
          "${AppUrl.pcmURL}/EndPointInbox/New/AllocatedCases/$probationOfficerId"));
      switch (response.statusCode) {
        case 200:
          List<AllocatedCaseProbationOfficerDto> allocatedCasesResponse = (json
                  .decode(response.body) as List)
              .map((data) => AllocatedCaseProbationOfficerDto.fromJson(data))
              .toList();
          apiResponse.Data = allocatedCasesResponse;
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

  Future<ApiResponse> getAllocatedCasesBySupervisor(int? supervisorId) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final response = await client.get(Uri.parse(
          "${AppUrl.pcmURL}/EndPointInbox/AllocatedCases/$supervisorId"));
      switch (response.statusCode) {
        case 200:
          List<AllocatedCaseSupervisorDto> allocatedSupervisorCasesResponse =
              (json.decode(response.body) as List)
                  .map((data) => AllocatedCaseSupervisorDto.fromJson(data))
                  .toList();
          apiResponse.Data = allocatedSupervisorCasesResponse;
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

  Future<ApiResponse> reAllocateCase(ReAllocateCase reAllocateCase) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final response = await client.post(
          Uri.parse("${AppUrl.pcmURL}/EndPointInbox/ReAllocate"),
          body: json.encode(reAllocateCase),
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
}
