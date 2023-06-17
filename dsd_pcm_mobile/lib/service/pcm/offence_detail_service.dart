import 'dart:convert';
import 'dart:io';
import 'package:http_interceptor/http/intercepted_client.dart';

import '../../domain/repository/assessment/offence_detail_repository.dart';
import '../../model/pcm/offence_detail_dto.dart';
import '../../util/app_url.dart';
import '../../util/auth_intercept/authorization_interceptor.dart';
import '../../util/http_client_service.dart';
import '../../util/shared/apierror.dart';
import '../../util/shared/apiresponse.dart';
import '../../util/shared/apiresults.dart';

class OffenceDetailService {
  final client =
      InterceptedClient.build(interceptors: [AuthorizationInterceptor()]);
  final _offenceDetailRepository = OffenceDetailRepository();
  final _httpClientService = HttpClientService();

  Future<ApiResponse> getOffenceDetailIntakeAssessmentIdOnline(
      int? intakeAssessmentId) async {
    ApiResponse apiResponse = ApiResponse();
    final response = await client.get(
        Uri.parse("${AppUrl.pcmURL}/OffenceDetail/GetAll/$intakeAssessmentId"));
    switch (response.statusCode) {
      case 200:
        apiResponse.Data = (json.decode(response.body) as List)
            .map((data) => OffenceDetailDto.fromJson(data))
            .toList();
        break;
      default:
        apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
        break;
    }
    return apiResponse;
  }

  Future<ApiResponse> getOffenceDetailIntakeAssessmentId(
      int? intakeAssessmentId) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      apiResponse =
          await getOffenceDetailIntakeAssessmentIdOnline(intakeAssessmentId);
      if (apiResponse.ApiError == null) {
        List<OffenceDetailDto> offenceDetailDtoResponse =
            apiResponse.Data as List<OffenceDetailDto>;
        apiResponse.Data = offenceDetailDtoResponse;
        _offenceDetailRepository
            .saveOffenceDetailItems(offenceDetailDtoResponse);
      }
    } on SocketException {
      apiResponse.Data = _offenceDetailRepository
          .getAllOffenceDetailsByAssessmentId(intakeAssessmentId!);
    }
    return apiResponse;
  }

  Future<ApiResponse> addOffenceDetailOnline(
      OffenceDetailDto offenceDetailDto) async {
    return await _httpClientService.httpClientPost(
        "${AppUrl.pcmURL}/OffenceDetail/Add", offenceDetailDto);
  }

  Future<ApiResponse> addOffenceDetail(
      OffenceDetailDto offenceDetailDto) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      apiResponse = await addOffenceDetailOnline(offenceDetailDto);
      if (apiResponse.ApiError == null) {
        ApiResults apiResults = (apiResponse.Data as ApiResults);
        OffenceDetailDto offenceDetailDtoResponse =
            OffenceDetailDto.fromJson(apiResults.data);
        apiResponse.Data = offenceDetailDtoResponse;
        _offenceDetailRepository.saveOffenceDetailNewRecord(
            offenceDetailDto, offenceDetailDtoResponse.pcmOffenceId);
      }
    } on SocketException {
      _offenceDetailRepository.saveOffenceDetail(offenceDetailDto);
      apiResponse.Data = _offenceDetailRepository
          .getOffenceDetailById(offenceDetailDto.pcmOffenceId!);
    }
    return apiResponse;
  }

  Future<ApiResponse> addUpdateOffenceDetailOnline(
      OffenceDetailDto offenceDetailDto) async {
    return await _httpClientService.httpClientPost(
        "${AppUrl.pcmURL}/OffenceDetail/AddUpdate", offenceDetailDto);
  }
}
