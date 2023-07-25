import 'dart:io';
import 'package:flutter/foundation.dart';

import '../../../../util/shared/apiresponse.dart';
import '../../../domain/repository/assessment/recommandation_repository.dart';
import '../../../model/pcm/recommendations_dto.dart';
import '../../../service/pcm/recommendations_service.dart';

class RecommandationSync {
  final _recommendationRepository = RecommendationRepository();
  final _recommendationsServiceClient = RecommendationsService();
  late ApiResponse apiResponse = ApiResponse();

  Future<void> syncRecommandationByAssessment(int? assessmentId) async {
    var offlineRecemmandationDto =
        _recommendationRepository.getRecommendationById(assessmentId!);
    if (offlineRecemmandationDto != null) {
      try {
        apiResponse = await _recommendationsServiceClient
            .addUpdateRecommendationOnline(offlineRecemmandationDto);
        _recommendationRepository.deleteRecommendationByAssessmentId(
            offlineRecemmandationDto.intakeAssessmentId!);
      } on SocketException catch (_) {
        if (kDebugMode) {
          print(
              'Unable to access _victimServiceClient.syncVictimOrganisationDetail endpoint');
        }
      }
    }
    //Repopulate offline box with latest data retrieve from end point
    await syncRecommandationOnlineToOffline(assessmentId);
  }

  Future<void> syncRecommandationOnlineToOffline(int? assessmentId) async {
    try {
      apiResponse = await _recommendationsServiceClient
          .getRecommendationByIntakeAssessmentIdOnline(assessmentId);
      if (apiResponse.ApiError == null) {
        RecommendationDto recommendationDtoResponse =
            apiResponse.Data as RecommendationDto;
        apiResponse.Data = recommendationDtoResponse;
        _recommendationRepository.saveRecommendation(recommendationDtoResponse);
      }
    } on SocketException catch (_) {
      if (kDebugMode) {
        print(
            'Unable to access _victimServiceClient.syncVictimOrganisationDetailOnlineToOffline endpoint');
      }
    }
  }
}
