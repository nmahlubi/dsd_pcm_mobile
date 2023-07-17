import 'dart:io';
import 'package:flutter/foundation.dart';

import '../../../domain/repository/assessment/assesment_register_repository.dart';
import '../../../model/pcm/assesment_register_dto.dart';
import '../../../service/pcm/assessment_service.dart';
import '../../../util/shared/apiresponse.dart';

class AssessmentRegisterSync {
  final _assesmentRegisterRepository = AssesmentRegisterRepository();
  final _assessmentService = AssessmentService();
  late ApiResponse apiResponse = ApiResponse();
  late AssesmentRegisterDto assesmentRegisterDto;

  Future<void> syncAssesmentRegister(int? assessmentId, int? caseId) async {
    var offlineAssessmentRegisterDto = _assesmentRegisterRepository
        .getAssesmentRegisterByAssessmentId(assessmentId!);
    try {
      if (offlineAssessmentRegisterDto != null) {
        apiResponse = await _assessmentService
            .addUpdateAssesmentRegisterOnline(offlineAssessmentRegisterDto);
      } else {
        apiResponse = await _assessmentService
            .getAssesmentRegisterByAssessmentIdOnline(assessmentId, caseId);
        if ((apiResponse.ApiError) == null) {
          assesmentRegisterDto = (apiResponse.Data as AssesmentRegisterDto);
          await _assesmentRegisterRepository
              .saveAssesmentRegister(assesmentRegisterDto);
        }
      }
    } on SocketException catch (_) {
      if (kDebugMode) {
        print(
            'Unable to access _assessmentService.syncAssesmentRegister endpoint');
      }
    }
  }
}
