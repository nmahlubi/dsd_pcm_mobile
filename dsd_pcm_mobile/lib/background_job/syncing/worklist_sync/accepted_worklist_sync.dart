import 'dart:io';

import 'package:flutter/foundation.dart';

import '../../../domain/repository/worklist/accepted_worklist_repository.dart';
import '../../../model/pcm/accepted_worklist_dto.dart';
import '../../../service/pcm/worklist_service.dart';
import '../../../util/shared/apiresponse.dart';

class AcceptedWorklistSync {
  final _acceptedWorklistRepository = AcceptedWorklistRepository();
  final _worklistService = WorklistService();
  late ApiResponse apiResponse = ApiResponse();
  late List<AcceptedWorklistDto> acceptedWorklistDto = [];

  Future<List<AcceptedWorklistDto>> syncAcceptedWorklist(
      int? probationOfficerId) async {
    List<AcceptedWorklistDto> acceptedWorklist = [];
    try {
      apiResponse = await _worklistService
          .getAcceptedWorklistByProbationOfficerOnline(probationOfficerId);
      if ((apiResponse.ApiError) == null) {
        acceptedWorklistDto = (apiResponse.Data as List<AcceptedWorklistDto>);
        await _acceptedWorklistRepository.deleteAllAcceptedWorklists();
        await _acceptedWorklistRepository.saveAcceptedWorklist(
            acceptedWorklistDto, probationOfficerId!);
        acceptedWorklist = acceptedWorklistDto;
      }
    } on SocketException catch (_) {
      if (kDebugMode) {
        print(
            'Unable to access _worklistService.getAcceptedWorklistByProbationOfficerOnline endpoint');
      }
    }
    return acceptedWorklist;
  }
}
