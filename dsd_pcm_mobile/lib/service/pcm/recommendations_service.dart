import 'dart:convert';
import 'dart:io';
import 'package:http_interceptor/http/intercepted_client.dart';

import '../../domain/repository/assessment/recommandation_repository.dart';
import '../../model/pcm/recommendations_dto.dart';
import '../../util/app_url.dart';
import '../../util/auth_intercept/authorization_interceptor.dart';
import '../../util/shared/apierror.dart';
import '../../util/shared/apiresponse.dart';
import '../../util/shared/apiresults.dart';

class RecommendationsService {
  final client =
      InterceptedClient.build(interceptors: [AuthorizationInterceptor()]);
  final _recommendationRepository = RecommendationRepository();

  Future<ApiResponse> getRecommendationsByIntakeAssessmentId(
      int? intakeAssessmentId) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final response = await client.get(Uri.parse(
          "${AppUrl.pcmURL}/Recommendations/GetAll/$intakeAssessmentId"));
      switch (response.statusCode) {
        case 200:
          /*
          apiResponse.Data = (json.decode(response.body) as List)
              .map((data) => RecommendationDto.fromJson(data))
              .toList();*/
          apiResponse.Data =
              _recommendationRepository.getAllRecommendations(); // =

          /*List<RecommendationDto> recommendationDtoResponse =
              (json.decode(response.body) as List)
                  .map((data) => RecommendationDto.fromJson(data))
                  .toList();
          apiResponse.Data = recommendationDtoResponse;
          _recommendationRepository
              .saveRecommendationItems(recommendationDtoResponse);*/
          break;
        default:
          apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
          break;
      }
    } on SocketException {
      apiResponse.Data = _recommendationRepository
          .getAllRecommendations(); // = ApiError(error: "Connection Error. Please retry");
    }
    return apiResponse;
  }

  Future<ApiResponse> addRecommendations(
      RecommendationDto recommendationDto) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final response = await client.post(
          Uri.parse("${AppUrl.pcmURL}/Recommendations/Add"),
          body: json.encode(recommendationDto),
          headers: {'Content-Type': 'application/json'});
      switch (response.statusCode) {
        case 200:
          ApiResults apiResults =
              ApiResults.fromJson(json.decode(response.body));
          apiResponse.Data = apiResults;
          //_recommendationRepository.saveRecommendation(
          //   RecommendationDto.fromJson(json.decode(apiResults.data)));
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
