import 'dart:io';
import 'package:flutter/foundation.dart';

import '../../../domain/repository/assessment/family_member_repository.dart';
import '../../../model/intake/person_dto.dart';
import '../../../model/pcm/family_member_dto.dart';
import '../../../service/intake/person_service.dart';
import '../../../service/pcm/family_service.dart';
import '../../../util/shared/apiresponse.dart';
import '../../../util/shared/apiresults.dart';

class FamilyMemberSync {
  final _familyMemberRepository = FamilyMemberRepository();
  final _familyServiceService = FamilyService();
  final _personService = PersonService();
  late ApiResponse apiResponse = ApiResponse();
  late PersonDto personDto;
  late List<FamilyMemberDto> familyMembersDto = [];

  Future<void> syncFamilyMember(int? assessmentId) async {
    var offlineFamilyMemberDto = _familyMemberRepository
        .getAllFamilyMembersByAssessmentId(assessmentId!);
    if (offlineFamilyMemberDto.isNotEmpty) {
      for (var familyMember in offlineFamilyMemberDto) {
        try {
          if (familyMember.personDto != null) {
            apiResponse = await _personService
                .searchAddUdatePersonOnline(familyMember.personDto!);
            if ((apiResponse.ApiError) == null) {
              ApiResults apiResults = (apiResponse.Data as ApiResults);
              PersonDto personDto = PersonDto.fromJson(apiResults.data);
              apiResponse =
                  await _familyServiceService.addUpdateFamilyMemberOnline(
                      familyMember, personDto.personId);
              _familyMemberRepository
                  .deleteFamilyMember(familyMember.familyMemberId!);
            }
          }
        } on SocketException catch (_) {
          if (kDebugMode) {
            print(
                'Unable to access _familyServiceService.syncFamilyMember endpoint');
          }
        }
      }
    }
    //Repopulate offline box with latest data retrieve from end point
    await syncFamilMemberOnlineToOffline(assessmentId);
  }

  Future<void> syncFamilMemberOnlineToOffline(int? assessmentId) async {
    try {
      apiResponse = await _familyServiceService
          .getFamilyMembersByAssesmentIdOnline(assessmentId);
      if ((apiResponse.ApiError) == null) {
        familyMembersDto = (apiResponse.Data as List<FamilyMemberDto>);
        if (familyMembersDto.isNotEmpty) {
          await _familyMemberRepository.saveFamilyMemberItems(familyMembersDto);
        }
      }
    } on SocketException catch (_) {
      if (kDebugMode) {
        print(
            'Unable to access _familyServiceService.syncFamilMemberOnlineToOffline endpoint');
      }
    }
  }
}
