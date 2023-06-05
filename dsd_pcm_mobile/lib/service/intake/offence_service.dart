// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:convert';
import 'dart:io';
import 'package:http_interceptor/http/intercepted_client.dart';

import '../../model/intake/offence_category_dto.dart';
import '../../model/intake/offence_schedule_dto.dart';
import '../../model/intake/offence_type_dto.dart';
import '../../util/app_url.dart';
import '../../util/auth_intercept/authorization_interceptor.dart';
import '../../util/shared/apierror.dart';
import '../../util/shared/apiresponse.dart';

class OffenceService {
  final client =
      InterceptedClient.build(interceptors: [AuthorizationInterceptor()]);

  Future<ApiResponse> getOffenceTypes() async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final response = await client
          .get(Uri.parse("${AppUrl.intakeURL}/Offence/Type/GetAll"));

      switch (response.statusCode) {
        case 200:
          apiResponse.Data = (json.decode(response.body) as List)
              .map((data) => OffenceTypeDto.fromJson(data))
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

  Future<ApiResponse> getOffenceTypesByCategorySchedule(
      int? offenceCategoryId, int? offenceScheduleId) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final response = await client.get(Uri.parse(
          "${AppUrl.intakeURL}/Offence/Type/Category/Schedule/${offenceCategoryId}/${offenceScheduleId}"));

      switch (response.statusCode) {
        case 200:
          apiResponse.Data = (json.decode(response.body) as List)
              .map((data) => OffenceTypeDto.fromJson(data))
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

  Future<ApiResponse> getOffenceCategories() async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final response = await client
          .get(Uri.parse("${AppUrl.intakeURL}/Offence/Category/GetAll"));

      switch (response.statusCode) {
        case 200:
          apiResponse.Data = (json.decode(response.body) as List)
              .map((data) => OffenceCategoryDto.fromJson(data))
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

  Future<ApiResponse> getOffenceSchedules() async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final response = await client
          .get(Uri.parse("${AppUrl.intakeURL}/Offence/Schedule/GetAll"));

      switch (response.statusCode) {
        case 200:
          apiResponse.Data = (json.decode(response.body) as List)
              .map((data) => OffenceScheduleDto.fromJson(data))
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
}
