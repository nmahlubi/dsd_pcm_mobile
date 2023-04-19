import 'dart:convert';
import 'dart:io';
import 'package:http_interceptor/http/intercepted_client.dart';

import '../../model/pcm/general_detail_dto.dart';
import '../../util/app_url.dart';
import '../../util/auth_intercept/authorization_interceptor.dart';
import '../../util/shared/apierror.dart';
import '../../util/shared/apiresponse.dart';
import '../../util/shared/apiresults.dart';

class GeneralDetailService {
  final client =
      InterceptedClient.build(interceptors: [AuthorizationInterceptor()]);

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

  Future<ApiResponse> getGeneralDetailByIntakeAssessmentId(
      int? intakeAssessmentId) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final response = await client.get(Uri.parse(
          "${AppUrl.pcmURL}/GeneralDetail/GetAll/$intakeAssessmentId"));
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
    } on SocketException {
      apiResponse.ApiError = ApiError(error: "Connection Error. Please retry");
    }
    return apiResponse;
  }

  Future<ApiResponse> addGeneralDetail(
      GeneralDetailDto generalDetailDto) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final response = await client.post(
          Uri.parse("${AppUrl.pcmURL}/GeneralDetail/Add"),
          body: json.encode(generalDetailDto),
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
