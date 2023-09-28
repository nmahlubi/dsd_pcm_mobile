// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:convert';
import 'dart:io';
import 'package:dsd_pcm_mobile/model/child_notification/incoming_cases_dto.dart';
import 'package:http_interceptor/http/intercepted_client.dart';

import '../../model/child_notification/notification_case_dto.dart';

import '../../util/app_url.dart';
import '../../util/auth_intercept/authorization_interceptor.dart';
import '../../util/shared/apierror.dart';
import '../../util/shared/apiresponse.dart';

class NotificationService {
  final client =
      InterceptedClient.build(interceptors: [AuthorizationInterceptor()]);

  Future<ApiResponse> getNotificationCasesBySupervisor(String username) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final response = await client.get(Uri.parse(
          "${AppUrl.childNotificationURL}/Notification/Cases/$username"));
      switch (response.statusCode) {
        case 200:
          List<NotificationCaseDto> notificationCasesResponse =
              (json.decode(response.body) as List)
                  .map((data) => NotificationCaseDto.fromJson(data))
                  .toList();
          apiResponse.Data = notificationCasesResponse;
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

  Future<ApiResponse> getOverdueCasesBySupervisor(
      String username, String startdate, String enddate) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final response = await client.get(Uri.parse(
          "${AppUrl.childNotificationURL}/Notification/Cases/Overdue?supervisorName=${username}&notificationStartDate=${startdate}&notificationEndDate=${enddate}"));
      switch (response.statusCode) {
        case 200:
          List<NotificationCaseDto> notificationCasesResponse =
              (json.decode(response.body) as List)
                  .map((data) => NotificationCaseDto.fromJson(data))
                  .toList();
          apiResponse.Data = notificationCasesResponse;
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

  Future<ApiResponse> getCountedOverdueCasesBySupervisor(
      String username) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final response = await client.get(Uri.parse(
          "${AppUrl.childNotificationURL}/Notification/Cases/Counted/Overdue/${username}"));
      switch (response.statusCode) {
        case 200:
          apiResponse.Data = json.decode(response.body);
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

  Future<ApiResponse> getCountedIncomingCasesBySupervisor(
      String? username) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final response = await client.get(Uri.parse(
          "${AppUrl.childNotificationURL}/Notification/Cases/Counted/Incoming/${username}"));
      switch (response.statusCode) {
        case 200:
          apiResponse.Data =
              IncomingCasesDto.fromJson(json.decode(response.body));
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
