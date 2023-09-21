import 'dart:convert';
import 'dart:io';
import 'package:dsd_pcm_mobile/model/pcm/order_dto.dart';
import 'package:http_interceptor/http/intercepted_client.dart';

import '../../domain/repository/assessment/recommandation_repository.dart';
import '../../model/pcm/diversion_recommendation_dto.dart';
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

 Future<ApiResponse> getDiversionRecommendationByRecommendationIdOnline(
      int? recomendationId) async {
    ApiResponse apiResponse = ApiResponse();
    final response = await client.get(
        Uri.parse("${AppUrl.pcmURL}/Recommendations/DiversionRecommendation/Get/$recomendationId"));
    switch (response.statusCode) {
      case 200:
        apiResponse.Data =
           apiResponse.Data = (json.decode(response.body) as List)
            .map((data) => DiversionRecommendationDto.fromJson(data))
            .toList();
        break;
      default:
        apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
        break;
    }
    return apiResponse;
  }

  Future<ApiResponse> getDiversionRecommendationByRecommendationId(
      int? recomendationId) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      apiResponse =
          await getDiversionRecommendationByRecommendationIdOnline(recomendationId);
      if (apiResponse.ApiError == null) {
        List<DiversionRecommendationDto> diversionRecommendationDtoResponse =
            apiResponse.Data as List<DiversionRecommendationDto>;
        apiResponse.Data = diversionRecommendationDtoResponse;
      
      }
    } on SocketException {
      apiResponse.ApiError = ApiError(error: "Connection Error. Please retry");
    }
    return apiResponse;
  }

  Future<ApiResponse> addDiversionRecommendationOnline(
      DiversionRecommendationDto diversionRecommendationDto) async {
    return await _httpClientService.httpClientPost(
        "${AppUrl.pcmURL}/Recommendations/DiversionRecommendation/Add", diversionRecommendationDto);
  }

  Future<ApiResponse> addDiversionRecommendation(
      DiversionRecommendationDto diversionRecommendationDto) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      apiResponse = await addDiversionRecommendationOnline(diversionRecommendationDto);
      if (apiResponse.ApiError == null) {
        ApiResults apiResults = (apiResponse.Data as ApiResults);
        DiversionRecommendationDto diversionRecommendationDtoResponse =
            DiversionRecommendationDto.fromJson(apiResults.data);
        apiResponse.Data = diversionRecommendationDtoResponse;
   
      }
    } on SocketException {
       apiResponse.ApiError = ApiError(error: "Connection Error. Please retry");
    }
    return apiResponse;
  }

  Future<ApiResponse> addUpdateDiversionRecommendationOnline(
      DiversionRecommendationDto diversionRecommendationDto) async {
    return await _httpClientService.httpClientPost(
        "${AppUrl.pcmURL}/Recommendations/DiversionRecommendation/Add", diversionRecommendationDto);
  }

  Future<ApiResponse> addUpdateDiversionRecommendation(
      DiversionRecommendationDto diversionRecommendationDto) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      apiResponse = await addUpdateDiversionRecommendationOnline(diversionRecommendationDto);
      if (apiResponse.ApiError == null) {
        ApiResults apiResults = (apiResponse.Data as ApiResults);
        DiversionRecommendationDto diversionRecommendationDtoResponse =
            DiversionRecommendationDto.fromJson(apiResults.data);
        apiResponse.Data = diversionRecommendationDtoResponse;
    
      }
    } on SocketException {
     apiResponse.ApiError = ApiError(error: "Connection Error. Please retry");
    }
    return apiResponse;
  }

Future<ApiResponse> getOrderByRecommendationIdOnline(
      int? recommendationId) async {
    ApiResponse apiResponse = ApiResponse();
    final response = await client.get(Uri.parse(
        "${AppUrl.pcmURL}/Recommendations/Order/Get/$recommendationId"));
    switch (response.statusCode) {
      case 200:
        apiResponse.Data = (json.decode(response.body) as List)
            .map((data) => OrderDto.fromJson(data))
            .toList();
        break;
      default:
        apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
        break;
    }
    return apiResponse;
  }

  Future<ApiResponse> getOrderByRecommendationId(
      int? recommendationId) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      apiResponse = await getOrderByRecommendationIdOnline(recommendationId);
      if (apiResponse.ApiError == null) {
        List<OrderDto> recommendationDtoResponse =
            apiResponse.Data as List<OrderDto>;
        apiResponse.Data = recommendationDtoResponse;
      }
    } on SocketException {
      apiResponse.ApiError = ApiError(error: "Connection Error. Please retry");
    }
    return apiResponse;
  }

  Future<ApiResponse> addOrderOnline(OrderDto orderDto) async {
    return await _httpClientService.httpClientPost(
        "${AppUrl.pcmURL}/Recommendations/Order/Add", orderDto);
  }

  Future<ApiResponse> addOrder(OrderDto orderDto) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      apiResponse = await addOrderOnline(orderDto);
      if (apiResponse.ApiError == null) {
        ApiResults apiResults = (apiResponse.Data as ApiResults);
        OrderDto orderDtoResponse = OrderDto.fromJson(apiResults.data);
        apiResponse.Data = orderDtoResponse;
      }
    } on SocketException {
      apiResponse.ApiError = ApiError(error: "Connection Error. Please retry");
    }
    return apiResponse;
  }

  Future<ApiResponse> addUpdateOrderOnline(OrderDto orderDto) async {
    return await _httpClientService.httpClientPost(
        "${AppUrl.pcmURL}/Recommendations/Order/AddUpdate", orderDto);
  }

  Future<ApiResponse> addUpdateOrder(OrderDto orderDto) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      apiResponse = await addUpdateOrderOnline(orderDto);
      if (apiResponse.ApiError == null) {
        ApiResults apiResults = (apiResponse.Data as ApiResults);
        OrderDto orderDtoResponse = OrderDto.fromJson(apiResults.data);
        apiResponse.Data = orderDtoResponse;
      }
    } on SocketException {
      apiResponse.ApiError = ApiError(error: "Connection Error. Please retry");
    }
    return apiResponse;
  }

   Future<ApiResponse> deleteDiversionRecommendationOnline(DiversionRecommendationDto diversionRecommendationDto) async {
    return await _httpClientService.httpClientDelete(
        "${AppUrl.pcmURL}/Recommendations/DiversionRecommendation/Delete", diversionRecommendationDto);
  }

  Future<ApiResponse> deleteDiversionRecommendation(DiversionRecommendationDto diversionRecommendationDto) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      apiResponse = await deleteDiversionRecommendationOnline(diversionRecommendationDto);
      if (apiResponse.ApiError == null) {
        ApiResults apiResults = (apiResponse.Data as ApiResults);
        OrderDto orderDtoResponse = OrderDto.fromJson(apiResults.data);
        apiResponse.Data = orderDtoResponse;
      }
    } on SocketException {
      apiResponse.ApiError = ApiError(error: "Connection Error. Please retry");
    }
    return apiResponse;
  }
}

