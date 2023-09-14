import 'dart:convert';
import 'dart:io';
import 'package:dsd_pcm_mobile/model/pcm/previousInvolvement_detail_dto.dart';
import 'package:http_interceptor/http/intercepted_client.dart';
import '../../util/app_url.dart';
import '../../util/auth_intercept/authorization_interceptor.dart';
import '../../util/http_client_service.dart';
import '../../util/shared/apierror.dart';
import '../../util/shared/apiresponse.dart';
import '../../util/shared/apiresults.dart';

class PreviousInvolvementDetailService {
  final client =
      InterceptedClient.build(interceptors: [AuthorizationInterceptor()]);
  final _httpClientService = HttpClientService();
  // final _previousInvolvementDetailRepository = PreviousInvolvementDetailRepository();

  Future<ApiResponse> getPreviousInvolvementDetailByInvolvementId(
      int? involvementId) async {
    ApiResponse apiResponse = ApiResponse();
    final response = await client.get(
        Uri.parse("${AppUrl.pcmURL}/PreviousInvolvementDetail/$involvementId"));
    switch (response.statusCode) {
      case 200:
        apiResponse.Data =
            PreviousInvolvementDetailDto.fromJson(json.decode(response.body));
        break;
      default:
        apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
        break;
    }
    return apiResponse;
  }

  Future<ApiResponse> getPreviousInvolvementDetailByIntakeAssessmentIdOnline(
      int? intakeAssessmentId) async {
    ApiResponse apiResponse = ApiResponse();
    final response = await client.get(Uri.parse(
        "${AppUrl.pcmURL}/PreviousInvolvementDetail/Get/$intakeAssessmentId"));
    switch (response.statusCode) {
      case 200:
        apiResponse.Data = (json.decode(response.body) as List)
            .map((data) => PreviousInvolvementDetailDto.fromJson(data))
            .toList();
        break;
      default:
        apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
        break;
    }
    return apiResponse;
  }

  Future<ApiResponse> getPreviousInvolvementDetailByIntakeAssessmentId(
      int? intakeAssessmentId) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      apiResponse =
          await getPreviousInvolvementDetailByIntakeAssessmentIdOnline(
              intakeAssessmentId);
      if (apiResponse.ApiError == null) {
        List<PreviousInvolvementDetailDto> careGiverDetailsDtoResponse =
            apiResponse.Data as List<PreviousInvolvementDetailDto>;
        apiResponse.Data = careGiverDetailsDtoResponse;
        // _careGiverDetailRepository
        //     .saveCareGiverDetailItems(careGiverDetailsDtoResponse);
      }
    } on SocketException {
      apiResponse.ApiError = ApiError(error: "Connection Error. Please retry");

      // apiResponse.Data = _careGiverDetailRepository
      //     .getAllCareGiverDetailsByClientId(clientId!);
    }
    return apiResponse;
  }

  Future<ApiResponse> addPreviousInvolvementDetailOnline(
      PreviousInvolvementDetailDto previousInvolvementDetailDto) async {
    return await _httpClientService.httpClientPost(
        "${AppUrl.pcmURL}/PreviousInvolvementDetail/Add",
        previousInvolvementDetailDto);
  }

  Future<ApiResponse> addPreviousInvolvementDetail(
      PreviousInvolvementDetailDto previousInvolvementDetailDto) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      apiResponse = await addPreviousInvolvementDetailOnline(
          previousInvolvementDetailDto);
      if (apiResponse.ApiError == null) {
        ApiResults apiResults = (apiResponse.Data as ApiResults);
        PreviousInvolvementDetailDto previousInvolvementDetailDtoResponse =
            PreviousInvolvementDetailDto.fromJson(apiResults.data);
        apiResponse.Data = previousInvolvementDetailDtoResponse;
      }
    } on SocketException {
      apiResponse.ApiError = ApiError(error: "Connection Error. Please retry");
    }
    return apiResponse;
  }

  Future<ApiResponse> addUpdatePreviousInvolvementDetailOnline(
      PreviousInvolvementDetailDto previousInvolvementDetailDto) async {
    return await _httpClientService.httpClientPost(
        "${AppUrl.pcmURL}/PreviousInvolvementDetail/AddUpdate",
        previousInvolvementDetailDto);
  }

  Future<ApiResponse> addUpdatePreviousInvolvementDetail(
      PreviousInvolvementDetailDto previousInvolvementDetailDto) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      apiResponse = await addUpdatePreviousInvolvementDetailOnline(
          previousInvolvementDetailDto);
      if (apiResponse.ApiError == null) {
        ApiResults apiResults = (apiResponse.Data as ApiResults);
        PreviousInvolvementDetailDto previousInvolvementDetailDtoResponse =
            PreviousInvolvementDetailDto.fromJson(apiResults.data);
        apiResponse.Data = previousInvolvementDetailDtoResponse;
      }
    } on SocketException {
      apiResponse.ApiError = ApiError(error: "Connection Error. Please retry");
    }
    return apiResponse;
  }
}
