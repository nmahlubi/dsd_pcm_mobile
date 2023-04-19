import 'dart:convert';
import 'dart:io';
import 'package:http_interceptor/http/intercepted_client.dart';

import '../../model/intake/probation_officer_dto.dart';
import '../../model/intake/request/forget_user_password.dart';
import '../../model/intake/user_dto.dart';
import '../../util/app_url.dart';
import '../../util/auth_intercept/authorization_interceptor.dart';
import '../../util/shared/apierror.dart';
import '../../util/shared/apiresponse.dart';

class UserService {
  final client =
      InterceptedClient.build(interceptors: [AuthorizationInterceptor()]);

  Future<ApiResponse> getUserById(int? userId) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final response = await client
          .get(Uri.parse("${AppUrl.intakeURL}/User/details/$userId"));

      switch (response.statusCode) {
        case 200:
          UserDto userDtoResponse =
              UserDto.fromJson(json.decode(response.body));
          apiResponse.Data = userDtoResponse;
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

  Future<ApiResponse> getProbationOfficerById(int? probationOfficerId) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final response = await client.get(Uri.parse(
          "${AppUrl.intakeURL}/User/ProbationOfficer/Get/$probationOfficerId"));

      switch (response.statusCode) {
        case 200:
          ProbationOfficerDto probationOfficerDtoResponse =
              ProbationOfficerDto.fromJson(json.decode(response.body));
          apiResponse.Data = probationOfficerDtoResponse;

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

  Future<ApiResponse> getProbationOfficersBySupervisorId(
      int? supervisorId) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final response = await client.get(Uri.parse(
          "${AppUrl.intakeURL}/User/ProbationOfficers/$supervisorId"));

      switch (response.statusCode) {
        case 200:
          List<ProbationOfficerDto> probationOfficersDtoResponse =
              (json.decode(response.body) as List)
                  .map((data) => ProbationOfficerDto.fromJson(data))
                  .toList();
          apiResponse.Data = probationOfficersDtoResponse;
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

  Future<ApiResponse> forgetPassword(
      ForgetUserPassword forgetUserPassword) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final response = await client.put(
          Uri.parse("${AppUrl.intakeURL}/User/forgetPassword"),
          body: json.encode(forgetUserPassword));

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
}
