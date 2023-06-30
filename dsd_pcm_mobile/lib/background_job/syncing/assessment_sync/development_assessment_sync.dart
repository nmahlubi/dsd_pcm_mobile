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
  late List<DevelopmentAssessmentDto> developmentAssessmentsDto = [];

  Future<void> syncDevelopmentAssessment(int? assessmentId) async {
    var offlineDevelopmentAssessmentDto = await _developmentAssessmentRepository
        .getAllDevelopmentAssessmentsByAssessmentId(assessmentId!);
    if (offlineDevelopmentAssessmentDto.isNotEmpty) {
      for (var developmentAssessment in offlineDevelopmentAssessmentDto) {
        try {
          apiResponse = await _developmentAssessmentServiceClient
              .addUpdateDevelopmentAssessmentOnline(developmentAssessment);
          _developmentAssessmentRepository.deleteDevelopmentAssessment(
              developmentAssessment.developmentId!);
        } on SocketException catch (_) {
          if (kDebugMode) {
            print(
                'Unable to access _developmentAssessmentServiceClient.syncDevelopmentAssessment endpoint');
          }
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
          .getDevelopmentAssessmentsByIntakeAssessmentIdOnline(assessmentId);
      if ((apiResponse.ApiError) == null) {
        developmentAssessmentsDto =
            (apiResponse.Data as List<DevelopmentAssessmentDto>);
        if (developmentAssessmentsDto.isNotEmpty) {
          await _developmentAssessmentRepository
              .saveDevelopmentAssessmentItems(developmentAssessmentsDto);
        }
      }
    } on SocketException catch (_) {
      if (kDebugMode) {
        print(
            'Unable to access _developmentAssessmentServiceClient.syncDevelopmentAssessmentOnlineToOffline endpoint');
      }
    }
  }
}
