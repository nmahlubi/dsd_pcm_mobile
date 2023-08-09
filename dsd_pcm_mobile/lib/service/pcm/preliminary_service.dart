import 'dart:convert';
import 'dart:io';

import 'package:http_interceptor/http/intercepted_client.dart';

import '../../model/pcm/preliminary_detail_dto.dart';
import '../../util/app_url.dart';
import '../../util/auth_intercept/authorization_interceptor.dart';
import '../../util/http_client_service.dart';
import '../../util/shared/apierror.dart';
import '../../util/shared/apiresponse.dart';
import '../../util/shared/apiresults.dart';

class PreliminaryDetailService {
  final client =
      InterceptedClient.build(interceptors: [AuthorizationInterceptor()]);

  final _httpClientService = HttpClientService();

  Future<ApiResponse> getPreliminaryDetailByPreliminaryIdOnline(
      int? preliminaryDetailsId) async {
    ApiResponse apiResponse = ApiResponse();
    final response = await client.get(
        Uri.parse("${AppUrl.pcmURL}/PreliminaryDetails/$preliminaryDetailsId"));
    switch (response.statusCode) {
      case 200:
        apiResponse.Data =
            PreliminaryDetailDto.fromJson(json.decode(response.body));
        break;
      default:
        apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
        break;
    }
    return apiResponse;
  }

  Future<ApiResponse> getPreliminaryByPreliminaryId(
      int? preliminaryDetailsId) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      apiResponse =
          await getPreliminaryDetailByPreliminaryIdOnline(preliminaryDetailsId);
      if (apiResponse.ApiError == null) {
        PreliminaryDetailDto preliminaryDtoResponse =
            apiResponse.Data as PreliminaryDetailDto;
        apiResponse.Data = preliminaryDtoResponse;
      }
    } on SocketException {
      apiResponse.ApiError = ApiError(error: "Connection Error. Please retry");
    }
    return apiResponse;
  }

  Future<ApiResponse> AddUpdatePreliminaryDetail(
      PreliminaryDetailDto preliminaryDetailDto) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final response = await client.post(
          Uri.parse("${AppUrl.pcmURL}/PreliminaryDetails/AddUpdate"),
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

  Future<ApiResponse> addUpdatePreliminaryOnline(
      PreliminaryDetailDto preliminaryDetailDto) async {
    return await _httpClientService.httpClientPost(
        "${AppUrl.pcmURL}/Preliminarydetails/AddUpdate", preliminaryDetailDto);
  }

  Future<ApiResponse> addUpdatePreliminary(
      PreliminaryDetailDto preliminaryDetailDto) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      apiResponse = await addUpdatePreliminaryOnline(preliminaryDetailDto);
      if (apiResponse.ApiError == null) {
        ApiResults apiResults = (apiResponse.Data as ApiResults);
        PreliminaryDetailDto preliminaryDetailDtoResponse =
            PreliminaryDetailDto.fromJson(apiResults.data);
        apiResponse.Data = preliminaryDetailDtoResponse;
      }
    } on SocketException {
      apiResponse.ApiError = ApiError(error: "Connection Error. Please retry");
    }
    return apiResponse;
  }
}
