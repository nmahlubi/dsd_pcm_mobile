import 'dart:convert';
import 'dart:io';

import 'package:http_interceptor/http/intercepted_client.dart';

import '../../model/pcm/preliminary_detail_dto.dart';
import '../../util/app_url.dart';
import '../../util/auth_intercept/authorization_interceptor.dart';
import '../../util/shared/apierror.dart';
import '../../util/shared/apiresponse.dart';
import '../../util/shared/apiresults.dart';

class PreliminaryDetailService {
  final client =
      InterceptedClient.build(interceptors: [AuthorizationInterceptor()]);

  Future<ApiResponse> getPreliminaryDetailByAssessmentId(
      int? intakeAssessmentId) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final response = await client.get(Uri.parse(
          "${AppUrl.pcmURL}/PreliminaryDetails/GetAll/$intakeAssessmentId"));

      switch (response.statusCode) {
        case 200:
          apiResponse.Data = (json.decode(response.body) as List)
              .map((data) => PreliminaryDetailDto.fromJson(data))
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

  Future<ApiResponse> addPreliminaryDetail(
      PreliminaryDetailDto preliminaryDetailDto) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final response = await client.post(
          Uri.parse("${AppUrl.pcmURL}/PreliminaryDetails/Add"),
          body: json.encode(preliminaryDetailDto),
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
