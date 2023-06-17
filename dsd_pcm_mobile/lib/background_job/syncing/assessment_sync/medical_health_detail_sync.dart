import 'dart:io';
import 'package:flutter/foundation.dart';

import '../../../domain/repository/assessment/medical_health_detail_repository.dart';
import '../../../model/pcm/medical_health_detail_dto.dart';
import '../../../service/pcm/medical_health_details_service.dart';
import '../../../util/shared/apiresponse.dart';

class MedicalHealthDetailSync {
  final _medicalHealthDetailRepository = MedicalHealthDetailRepository();
  final _medicalHealthDetailsService = MedicalHealthDetailsService();
  late ApiResponse apiResponse = ApiResponse();
  late List<MedicalHealthDetailDto> medicalHealthDetailsDto = [];

  Future<void> syncMedicalDetailHealth(int? assessmentId) async {
    var offlineMedicalDetailHealthDto = await _medicalHealthDetailRepository
        .getAllMedicalHealthDetailsByAssessmentId(assessmentId!);
    if (offlineMedicalDetailHealthDto.isNotEmpty) {
      for (var medicalHealth in offlineMedicalDetailHealthDto) {
        try {
          apiResponse = await _medicalHealthDetailsService
              .addMedicalHealthDetailOnline(medicalHealth);
          _medicalHealthDetailRepository
              .deleteMedicalHealthDetails(medicalHealth.healthDetailsId!);
        } on SocketException catch (_) {
          if (kDebugMode) {
            print(
                'Unable to access _medicalHealthDetailsService.syncMedicalDetailHealth endpoint');
          }
        }
      }
    }
    //Repopulate offline box with latest data retrieve from end point
    await syncMedicalDetailHealthOnlineToOffline(assessmentId);
  }

  Future<void> syncMedicalDetailHealthOnlineToOffline(int? assessmentId) async {
    try {
      apiResponse = await _medicalHealthDetailsService
          .getMedicalHealthDetailsByAssessmentIdOnline(assessmentId);
      if ((apiResponse.ApiError) == null) {
        medicalHealthDetailsDto =
            (apiResponse.Data as List<MedicalHealthDetailDto>);
        if (medicalHealthDetailsDto.isNotEmpty) {
          await _medicalHealthDetailRepository
              .saveMedicalHealthDetailItems(medicalHealthDetailsDto);
        }
      }
    } on SocketException catch (_) {
      if (kDebugMode) {
        print(
            'Unable to access _medicalHealthDetailsService.syncMedicalDetailHealthOnlineToOffline endpoint');
      }
    }
  }
}
