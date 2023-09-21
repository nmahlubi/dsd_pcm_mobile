import 'dart:convert';
import 'dart:io';
import 'package:http_interceptor/http/intercepted_client.dart';
import '../../model/pcm/facility_bed_space.dart';
import '../../util/app_url.dart';
import '../../util/auth_intercept/authorization_interceptor.dart';
import '../../util/http_client_service.dart';
import '../../util/shared/apierror.dart';
import '../../util/shared/apiresponse.dart';
import '../../util/shared/apiresults.dart';

class FacilityBedSpaceService {
  final client =
      InterceptedClient.build(interceptors: [AuthorizationInterceptor()]);
  final _httpClientService = HttpClientService();
 
  Future<ApiResponse> getFacilityBedSpaceByProvinceIdOnline(
      int? provinceId) async {
    ApiResponse apiResponse = ApiResponse();
    final response = await client.get(Uri.parse(
        "${AppUrl.pcmURL}/FacilitySpaceInboxRequest/GetAll/$provinceId"));
    switch (response.statusCode) {
      case 200:
        apiResponse.Data = (json.decode(response.body) as List)
            .map((data) => FacilityBedSpaceDto.fromJson(data))
            .toList();
        break;
      default:
        apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
        break;
    }
    return apiResponse;
  }

  Future<ApiResponse> getFacilityBedSpaceByProvinceId(
      int? provinceId) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      apiResponse =
          await getFacilityBedSpaceByProvinceIdOnline(provinceId);
      if (apiResponse.ApiError == null) {
        List<FacilityBedSpaceDto> facilityBedSpcaeDtoResponse =
            apiResponse.Data as List<FacilityBedSpaceDto>;
        apiResponse.Data = facilityBedSpcaeDtoResponse;

      }
    } on SocketException {
      apiResponse.ApiError = ApiError(error: "Connection Error. Please retry");
    }
    return apiResponse;
  }
 
 Future<ApiResponse> getFacilityBedSpaceByIntakeAssessmentIdOnline(
      int? intakeAssessmentId) async {
    ApiResponse apiResponse = ApiResponse();
    final response = await client.get(Uri.parse(
        "${AppUrl.pcmURL}/FacilitySpaceInboxRequest/Get/$intakeAssessmentId"));
    switch (response.statusCode) {
      case 200:
        apiResponse.Data = (json.decode(response.body) as List)
            .map((data) => FacilityBedSpaceDto.fromJson(data))
            .toList();
        break;
      default:
        apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
        break;
    }
    return apiResponse;
  }

  Future<ApiResponse> getFacilityBedSpaceByIntakeAssessmentId(
      int? provinceId) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      apiResponse =
          await getFacilityBedSpaceByIntakeAssessmentIdOnline(provinceId);
      if (apiResponse.ApiError == null) {
        List<FacilityBedSpaceDto> facilityBedSpcaeDtoResponse =
            apiResponse.Data as List<FacilityBedSpaceDto>;
        apiResponse.Data = facilityBedSpcaeDtoResponse;

      }
    } on SocketException {
      apiResponse.ApiError = ApiError(error: "Connection Error. Please retry");
    }
    return apiResponse;
  }
 
 Future<ApiResponse> addFacilityBedSpaceOnline(
      FacilityBedSpaceDto facilityBedSpaceDto) async {
    return await _httpClientService.httpClientPost(
        "${AppUrl.pcmURL}/FacilitySpaceInboxRequest/Add", facilityBedSpaceDto);
  }

  Future<ApiResponse> addFacilityBedSpace(
      FacilityBedSpaceDto facilityBedSpaceDto) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      apiResponse = await addFacilityBedSpaceOnline(facilityBedSpaceDto);
      if (apiResponse.ApiError == null) {
        ApiResults apiResults = (apiResponse.Data as ApiResults);
        FacilityBedSpaceDto famcilityBedSpaceDtoResponse =
            FacilityBedSpaceDto.fromJson(apiResults.data);
        apiResponse.Data = famcilityBedSpaceDtoResponse;
     
      }
    } on SocketException {
        apiResponse.ApiError = ApiError(error: "Connection Error. Please retry");
    }
    return apiResponse;
  }

  Future<ApiResponse> addUpdateFacilityBedSpaceOnline(
      FacilityBedSpaceDto facilityBedSpaceDto) async {
    return await _httpClientService.httpClientPost(
        "${AppUrl.pcmURL}/FacilitySpaceInboxRequest/AddUpdate", facilityBedSpaceDto);
  }

Future<ApiResponse> addUpdateFacilityBedSpace(
      FacilityBedSpaceDto facilityBedSpaceDto) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      apiResponse = await addUpdateFacilityBedSpaceOnline(facilityBedSpaceDto);
      if (apiResponse.ApiError == null) {
        ApiResults apiResults = (apiResponse.Data as ApiResults);
        FacilityBedSpaceDto facilityBedSpaceDtoResponse =
            FacilityBedSpaceDto.fromJson(apiResults.data);
        apiResponse.Data = facilityBedSpaceDtoResponse;
       
      }
    } on SocketException {
    apiResponse.ApiError = ApiError(error: "Connection Error. Please retry");
    }
    return apiResponse;
  }
}