import 'dart:io';
import 'package:flutter/foundation.dart';

import '../../../../util/shared/apiresponse.dart';
import '../../../domain/repository/assessment/development_assessment_repository.dart';
import '../../../model/pcm/development_assessment_dto.dart';
import '../../../service/pcm/development_assessment_service.dart';

class DevelopmentAssessmentSync {
  final _developmentAssessmentRepository = DevelopmentAssessmentRepository();
  final _developmentAssessmentServiceClient = DevelopmentAssessmentService();
  late ApiResponse apiResponse = ApiResponse();

  Future<void> syncDevelopmentAssessment(int? assessmentId) async {
    var offlineDevelopmentAssessmentDto = _developmentAssessmentRepository
        .getDevelopmentAssessmentById(assessmentId!);
    if (offlineDevelopmentAssessmentDto != null) {
      try {
        apiResponse = await _developmentAssessmentServiceClient
            .addUpdateDevelopmentAssessmentOnline(
                offlineDevelopmentAssessmentDto);
        _developmentAssessmentRepository
            .deleteDevelopmentAssessmentByAssessmentId(assessmentId);
      } on SocketException catch (_) {
        if (kDebugMode) {
          print(
              'Unable to access _developmentAssessmentServiceClient.syncDevelopmentAssessment endpoint');
        }
      }
    }
    //Repopulate offline box with latest data retrieve from end point
    await syncDevelopmentAssessmentOnlineToOffline(assessmentId);
  }

  Future<void> syncDevelopmentAssessmentOnlineToOffline(
      int? assessmentId) async {
    try {
      apiResponse = await _developmentAssessmentServiceClient
          .getDevelopmentAssessmentByIntakeAssessmentId(assessmentId);
      if ((apiResponse.ApiError) == null) {
        DevelopmentAssessmentDto developmentAssessmentDtoResponse =
            apiResponse.Data as DevelopmentAssessmentDto;
        _developmentAssessmentRepository
            .saveDevelopmentAssessment(developmentAssessmentDtoResponse);
      }
    } on SocketException catch (_) {
      if (kDebugMode) {
        print(
            'Unable to access _developmentAssessmentServiceClient.syncDevelopmentAssessmentOnlineToOffline endpoint');
      }
    }
  }
}
