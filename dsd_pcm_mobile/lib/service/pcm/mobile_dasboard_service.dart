import 'dart:convert';
import 'dart:io';
import 'package:http_interceptor/http/intercepted_client.dart';

import '../../domain/repository/dashboard/dashboard_repository.dart';
import '../../model/pcm/mobile_dashboard_dto.dart';
import '../../util/app_url.dart';
import '../../util/auth_intercept/authorization_interceptor.dart';
import '../../util/shared/apierror.dart';
import '../../util/shared/apiresponse.dart';

class MobileDashboardService {
  final client =
      InterceptedClient.build(interceptors: [AuthorizationInterceptor()]);
  final dasboardRepository = DashboardRepository();

  Future<ApiResponse> getMobileDashboardByUserOnline(int? userId) async {
    ApiResponse apiResponse = ApiResponse();
    final response =
        await client.get(Uri.parse("${AppUrl.pcmURL}/MobileDashboard/$userId"));
    switch (response.statusCode) {
      case 200:
        apiResponse.Data =
            MobileDashboardDto.fromJson(json.decode(response.body));
        break;
      default:
        apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
        break;
    }
    return apiResponse;
  }

  Future<ApiResponse> getMobileDashboardByUser(int? userId) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      apiResponse = await getMobileDashboardByUserOnline(userId);
      if (apiResponse.ApiError == null) {
        MobileDashboardDto mobileDashboardDtoResponse =
            apiResponse.Data as MobileDashboardDto;
        apiResponse.Data = mobileDashboardDtoResponse;
        dasboardRepository.saveMobileDashboard(
            mobileDashboardDtoResponse, userId!);
      }
    } on SocketException {
      apiResponse.Data = dasboardRepository.getMobileDashboardById(userId!);
    }
    return apiResponse;
  }

  /*
   Future<ApiResponse> getMobileDashboardByUser(int? userId) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      apiResponse = await getMobileDashboardByUserOnline(userId);
      if(apiResponse.ApiError == null)
      {
       MobileDashboardDto mobileDashboardDtoResponse =
              MobileDashboardDto.fromJson(json.decode(response.body));
          apiResponse.Data = mobileDashboardDtoResponse;
          dasboardRepository.saveMobileDashboard(
              mobileDashboardDtoResponse, userId!);
      }
      /*final response = await client
          .get(Uri.parse("${AppUrl.pcmURL}/MobileDashboard/$userId"));
      switch (response.statusCode) {
        case 200:
          MobileDashboardDto mobileDashboardDtoResponse =
              MobileDashboardDto.fromJson(json.decode(response.body));
          apiResponse.Data = mobileDashboardDtoResponse;
          dasboardRepository.saveMobileDashboard(
              mobileDashboardDtoResponse, userId!);
          break;
        default:
          apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
          break;
      }*/
    } on SocketException {
      apiResponse.Data = dasboardRepository.getMobileDashboardById(userId!);
    }
    return apiResponse;
  }

  */

/*
  Future<ApiResponse> getMobileDashboardByUser(int? userId) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final response = await client
          .get(Uri.parse("${AppUrl.pcmURL}/MobileDashboard/$userId"));
      switch (response.statusCode) {
        case 200:
          MobileDashboardDto mobileDashboardDtoResponse =
              MobileDashboardDto.fromJson(json.decode(response.body));
          apiResponse.Data = mobileDashboardDtoResponse;
          dasboardRepository.saveMobileDashboard(
              mobileDashboardDtoResponse, userId!);
          break;
        default:
          apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
          break;
      }
    } on SocketException {
      apiResponse.Data = dasboardRepository.getMobileDashboardById(userId!);
    }
    return apiResponse;
  }*/
}
