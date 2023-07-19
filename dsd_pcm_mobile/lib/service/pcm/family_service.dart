import 'dart:convert';
import 'dart:io';
import 'package:http_interceptor/http/intercepted_client.dart';

import '../../domain/repository/assessment/family_information_repository.dart';
import '../../domain/repository/assessment/family_member_repository.dart';
import '../../model/intake/person_dto.dart';
import '../../model/pcm/family_information_dto.dart';
import '../../model/pcm/family_member_dto.dart';
import '../../util/app_url.dart';
import '../../util/auth_intercept/authorization_interceptor.dart';
import '../../util/http_client_service.dart';
import '../../util/shared/apierror.dart';
import '../../util/shared/apiresponse.dart';

import '../../util/shared/apiresults.dart';
import '../intake/person_service.dart';

class FamilyService {
  final client =
      InterceptedClient.build(interceptors: [AuthorizationInterceptor()]);
  final _personServiceClient = PersonService();
  final _familyInformationRepository = FamilyInformationRepository();
  final _familyMemberRepository = FamilyMemberRepository();
  final _httpClientService = HttpClientService();

  Future<ApiResponse> getFamilyInformationByAssessmentIdOnline(
      int? intakeAssessmentId) async {
    ApiResponse apiResponse = ApiResponse();
    final response = await client.get(Uri.parse(
        "${AppUrl.pcmURL}/Family/Information/GetAll/$intakeAssessmentId"));
    switch (response.statusCode) {
      case 200:
        apiResponse.Data = (json.decode(response.body) as List)
            .map((data) => FamilyInformationDto.fromJson(data))
            .toList();
        break;
      default:
        apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
        break;
    }
    return apiResponse;
  }

  Future<ApiResponse> getFamilyInformationByAssessmentId(
      int? intakeAssessmentId) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      apiResponse =
          await getFamilyInformationByAssessmentIdOnline(intakeAssessmentId);
      if (apiResponse.ApiError == null) {
        List<FamilyInformationDto> familyInformationsDtoResponse =
            apiResponse.Data as List<FamilyInformationDto>;
        apiResponse.Data = familyInformationsDtoResponse;
        _familyInformationRepository
            .saveFamilyInformationItems(familyInformationsDtoResponse);
      }
    } on SocketException {
      apiResponse.Data = _familyInformationRepository
          .getAllFamilyInformationsByAssessmentId(intakeAssessmentId!);
    }
    return apiResponse;
  }

  Future<ApiResponse> addFamilyInformationOnline(
      FamilyInformationDto familyInformationDto) async {
    return await _httpClientService.httpClientPost(
        "${AppUrl.pcmURL}/Family/Information/Add", familyInformationDto);
  }

  Future<ApiResponse> addFamilyInformation(
      FamilyInformationDto familyInformationDto) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      apiResponse = await addFamilyInformationOnline(familyInformationDto);
      if (apiResponse.ApiError == null) {
        ApiResults apiResults = (apiResponse.Data as ApiResults);
        FamilyInformationDto familyInformationDtoResponse =
            FamilyInformationDto.fromJson(apiResults.data);
        apiResponse.Data = familyInformationDtoResponse;
        _familyInformationRepository
            .saveFamilyInformation(familyInformationDtoResponse);
      }
    } on SocketException {
      _familyInformationRepository.saveFamilyInformation(familyInformationDto);
      apiResponse.Data = _familyInformationRepository
          .getFamilyInformationById(familyInformationDto.familyInformationId!);
    }
    return apiResponse;
  }

  Future<ApiResponse> addUpdateFamilyInformation(
      FamilyInformationDto familyInformationDto) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      apiResponse =
          await addUpdateFamilyInformationOnline(familyInformationDto);
      if (apiResponse.ApiError == null) {
        ApiResults apiResults = (apiResponse.Data as ApiResults);
        FamilyInformationDto familyInformationDtoResponse =
            FamilyInformationDto.fromJson(apiResults.data);
        apiResponse.Data = familyInformationDtoResponse;
        _familyInformationRepository
            .saveFamilyInformation(familyInformationDtoResponse);
      }
    } on SocketException {
      _familyInformationRepository.saveFamilyInformation(familyInformationDto);
      apiResponse.Data = _familyInformationRepository
          .getFamilyInformationById(familyInformationDto.familyInformationId!);
    }
    return apiResponse;
  }

  Future<ApiResponse> addUpdateFamilyInformationOnline(
      FamilyInformationDto familyInformationDto) async {
    return await _httpClientService.httpClientPost(
        "${AppUrl.pcmURL}/Family/Information/AddUpdate", familyInformationDto);
  }

  Future<ApiResponse> getFamilyMembersByAssesmentIdOnline(
      int? intakeAssessmentId) async {
    ApiResponse apiResponse = ApiResponse();
    final response = await client.get(
        Uri.parse("${AppUrl.pcmURL}/Family/Member/GetAll/$intakeAssessmentId"));
    switch (response.statusCode) {
      case 200:
        apiResponse.Data = (json.decode(response.body) as List)
            .map((data) => FamilyMemberDto.fromJson(data))
            .toList();
        break;
      default:
        apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
        break;
    }
    return apiResponse;
  }

  Future<ApiResponse> getFamilyMembersByAssesmentId(
      int? intakeAssessmentId) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      apiResponse =
          await getFamilyMembersByAssesmentIdOnline(intakeAssessmentId);
      if (apiResponse.ApiError == null) {
        List<FamilyMemberDto> familyMemberResponse =
            apiResponse.Data as List<FamilyMemberDto>;
        apiResponse.Data = familyMemberResponse;
        _familyMemberRepository.saveFamilyMemberItems(familyMemberResponse);
      }
    } on SocketException {
      apiResponse.Data = _familyMemberRepository
          .getAllFamilyMembersByAssessmentId(intakeAssessmentId!);
    }
    return apiResponse;
  }

  Future<ApiResponse> addFamilyMemberOnline(
      FamilyMemberDto familyMemberDto, int? personId) async {
    return await _httpClientService.httpClientPost(
        "${AppUrl.pcmURL}/Family/Member/Add/$personId", familyMemberDto);
  }

  Future<ApiResponse> addFamilyMember(FamilyMemberDto familyMemberDto) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      apiResponse = await _personServiceClient
          .searchAddUdatePersonOnline(familyMemberDto.personDto!);
      if (apiResponse.ApiError == null) {
        ApiResults apiResults = (apiResponse.Data as ApiResults);
        PersonDto personResponse = PersonDto.fromJson(apiResults.data);
        //Family Member
        apiResponse = await addFamilyMemberOnline(
            familyMemberDto, personResponse.personId);
        if (apiResponse.ApiError == null) {
          ApiResults apiResults = (apiResponse.Data as ApiResults);
          FamilyMemberDto familyMemberDtoResponse =
              FamilyMemberDto.fromJson(apiResults.data);
          apiResponse.Data = familyMemberDtoResponse;
          _familyMemberRepository.saveFamilyMemberAfterOnline(
              familyMemberDto,
              personResponse.personId!,
              familyMemberDtoResponse.familyMemberId!);
        }
      }
    } on SocketException {
      _familyMemberRepository.saveFamilyMember(familyMemberDto);
      apiResponse.Data = _familyMemberRepository
          .getFamilyMemberById(familyMemberDto.familyMemberId!);
    }
    return apiResponse;
  }

  Future<ApiResponse> addUpdateFamilyMemberOnline(
      FamilyMemberDto familyMemberDto) async {
    return await _httpClientService.httpClientPost(
        "${AppUrl.pcmURL}/Family/Member/AddUpdate", familyMemberDto);
  }

  Future<ApiResponse> addUpdateFamilyMember(
      FamilyMemberDto familyMemberDto) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      apiResponse = await addUpdateFamilyMemberOnline(familyMemberDto);
      if (apiResponse.ApiError == null) {
        ApiResults apiResults = (apiResponse.Data as ApiResults);
        FamilyMemberDto familyMemberDtoResponse =
            FamilyMemberDto.fromJson(apiResults.data);
        apiResponse.Data = familyMemberDtoResponse;
        _familyMemberRepository.saveFamilyMemberAfterOnline(
            familyMemberDto,
            familyMemberDtoResponse.personId!,
            familyMemberDtoResponse.familyMemberId!);
      }
    } on SocketException {
      _familyMemberRepository.saveFamilyMember(familyMemberDto);
      apiResponse.Data = _familyInformationRepository
          .getFamilyInformationById(familyMemberDto.familyMemberId!);
    }
    return apiResponse;
  }
}
