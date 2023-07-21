import 'dart:convert';
import 'dart:io';
import 'package:http_interceptor/http/intercepted_client.dart';

import '../../domain/repository/worklist/accepted_worklist_repository.dart';
import '../../model/pcm/accepted_worklist_dto.dart';
import '../../model/pcm/request/create_worklist.dart';
import '../../util/app_url.dart';
import '../../util/auth_intercept/authorization_interceptor.dart';
import '../../util/shared/apierror.dart';
import '../../util/shared/apiresponse.dart';
import '../../util/shared/apiresults.dart';

class WorklistService {
  final client =
      InterceptedClient.build(interceptors: [AuthorizationInterceptor()]);
  final acceptedWorklistRepository = AcceptedWorklistRepository();

  Future<ApiResponse> createWorklist(CreateWorklist createWorklist) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final response = await client.post(
          Uri.parse("${AppUrl.pcmURL}/Worklist/Create"),
          body: json.encode(createWorklist),
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

  Future<ApiResponse> getAcceptedWorklistByProbationOfficerOnline(
      int? probationOfficerId) async {
    ApiResponse apiResponse = ApiResponse();
    final response = await client.get(Uri.parse(
        "${AppUrl.pcmURL}/Worklist/Accepted/All/$probationOfficerId"));
    switch (response.statusCode) {
      case 200:
        apiResponse.Data = (json.decode(response.body) as List)
            .map((data) => AcceptedWorklistDto.fromJson(data))
            .toList();
        break;
      default:
        apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
        break;
    }
    return apiResponse;
  }

  Future<ApiResponse> getAcceptedWorklistByProbationOfficer(
      int? probationOfficerId) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      apiResponse =
          await getAcceptedWorklistByProbationOfficerOnline(probationOfficerId);
      if (apiResponse.ApiError == null) {
        List<AcceptedWorklistDto> acceptedWorklistDtoResponse =
            apiResponse.Data as List<AcceptedWorklistDto>;
        apiResponse.Data = acceptedWorklistDtoResponse;
        acceptedWorklistRepository.saveAcceptedWorklist(
            acceptedWorklistDtoResponse, probationOfficerId!);
      }
    } on SocketException {
      apiResponse.Data = acceptedWorklistRepository
          .getAllAcceptedWorklistsByUserId(probationOfficerId);
    }
    return apiResponse;
  }

  Future<ApiResponse> completeWorklist(
      AcceptedWorklistDto acceptedWorklistDto) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final response = await client.post(
          Uri.parse("${AppUrl.pcmURL}/Worklist/Complete"),
          body: json.encode(acceptedWorklistDto),
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

//for preliminary details
  Future<ApiResponse> getCompleteTaskAllocatedToProbationOfficer(
      int? probationOfficerId) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final response = await client.get(Uri.parse(
          "${AppUrl.pcmURL}/Worklist/CompletedAssessment/All/$probationOfficerId"));
      switch (response.statusCode) {
        case 200:
          List<AcceptedWorklistDto> acceptedWorklistDtoResponse =
              (json.decode(response.body) as List)
                  .map((data) => AcceptedWorklistDto.fromJson(data))
                  .toList();
          apiResponse.Data = acceptedWorklistDtoResponse;
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
