import 'dart:convert';
import 'dart:io';
import 'package:http_interceptor/http/intercepted_client.dart';

import '../../domain/repository/assessment/recommandation_repository.dart';
import '../../model/pcm/recommendations_dto.dart';
import '../../util/app_url.dart';
import '../../util/auth_intercept/authorization_interceptor.dart';
import '../../util/http_client_service.dart';
import '../../util/shared/apierror.dart';
import '../../util/shared/apiresponse.dart';
import '../../util/shared/apiresults.dart';

class RecommendationsService {
  final client =
      InterceptedClient.build(interceptors: [AuthorizationInterceptor()]);
  final _httpClientService = HttpClientService();
  final _recommendationRepository = RecommendationRepository();

  Future<ApiResponse> getRecommendationByIntakeAssessmentIdOnline(
      int? intakeAssessmentId) async {
    ApiResponse apiResponse = ApiResponse();
    final response = await client.get(
        Uri.parse("${AppUrl.pcmURL}/Recommendations/Get/$intakeAssessmentId"));
    switch (response.statusCode) {
      case 200:
        apiResponse.Data =
            RecommendationDto.fromJson(json.decode(response.body));
        break;
      default:
        apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
        break;
    }
    return apiResponse;
  }

  Future<ApiResponse> getRecommendationByIntakeAssessmentId(
      int? intakeAssessmentId) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      apiResponse =
          await getRecommendationByIntakeAssessmentIdOnline(intakeAssessmentId);
      if (apiResponse.ApiError == null) {
        RecommendationDto recommendationDtoResponse =
            apiResponse.Data as RecommendationDto;
        apiResponse.Data = recommendationDtoResponse;
        _recommendationRepository.saveRecommendation(recommendationDtoResponse);
      }
    } on SocketException {
      apiResponse.Data =
          _recommendationRepository.getRecommendationById(intakeAssessmentId!);
    }
    return apiResponse;
  }

  Future<ApiResponse> addRecommendationOnline(
      RecommendationDto recommendationDto) async {
    return await _httpClientService.httpClientPost(
        "${AppUrl.pcmURL}/Recommendations/Add", recommendationDto);
  }

  Future<ApiResponse> addRecommendations(
      RecommendationDto recommendationDto) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      apiResponse = await addRecommendationOnline(recommendationDto);
      if (apiResponse.ApiError == null) {
        ApiResults apiResults = (apiResponse.Data as ApiResults);
        RecommendationDto recommendationDtoResponse =
            RecommendationDto.fromJson(apiResults.data);
        apiResponse.Data = recommendationDtoResponse;
        _recommendationRepository.saveRecommendationFromEndpoint(
            recommendationDtoResponse,
            recommendationDtoResponse.recommendationId!);
      }
    } on SocketException {
      _recommendationRepository.saveRecommendation(recommendationDto);
      apiResponse.Data = _recommendationRepository
          .getRecommendationById(recommendationDto.recommendationId!);
    }
    return apiResponse;
  }

  Future<ApiResponse> addUpdateRecommendationOnline(
      RecommendationDto recommendationDto) async {
    return await _httpClientService.httpClientPost(
        "${AppUrl.pcmURL}/Recommendations/AddUpdate", recommendationDto);
  }

  Future<ApiResponse> addUpdateRecommendation(
      RecommendationDto recommendationDto) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      apiResponse = await addUpdateRecommendationOnline(recommendationDto);
      if (apiResponse.ApiError == null) {
        ApiResults apiResults = (apiResponse.Data as ApiResults);
        RecommendationDto recommendationDtoResponse =
            RecommendationDto.fromJson(apiResults.data);
        apiResponse.Data = recommendationDtoResponse;
        _recommendationRepository.saveRecommendationFromEndpoint(
            recommendationDtoResponse,
            recommendationDtoResponse.recommendationId!);
      }
    } on SocketException {
      _recommendationRepository.saveRecommendation(recommendationDto);
      apiResponse.Data = _recommendationRepository
          .getRecommendationById(recommendationDto.recommendationId!);
    }
    return apiResponse;
  }
}
