import 'dart:convert';
import 'dart:io';
import 'package:http_interceptor/http/intercepted_client.dart';

import '../../domain/repository/assessment/victim_organisation_repository.dart';
import '../../model/pcm/victim_detail_dto.dart';
import '../../model/pcm/victim_organisation_detail_dto.dart';
import '../../util/app_url.dart';
import '../../util/auth_intercept/authorization_interceptor.dart';
import '../../util/http_client_service.dart';
import '../../util/shared/apierror.dart';
import '../../util/shared/apiresponse.dart';
import '../../util/shared/apiresults.dart';
import '../intake/person_service.dart';

class VictimService {
  final client =
      InterceptedClient.build(interceptors: [AuthorizationInterceptor()]);
  final _personServiceClient = PersonService();
  final _victimOrganisationDetailRepository =
      VictimOrganisationDetailRepository();
  //final _familyMemberRepository = FamilyMemberRepository();
  final _httpClientService = HttpClientService();

  Future<ApiResponse> getVictimDetailById(int? victimId) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final response =
          await client.get(Uri.parse("${AppUrl.pcmURL}/Victim/$victimId"));
      switch (response.statusCode) {
        case 200:
          apiResponse.Data =
              VictimDetailDto.fromJson(json.decode(response.body));
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

  Future<ApiResponse> getVictimDetailByIntakeAssessmentId(
      int? intakeAssessmentId) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final response = await client
          .get(Uri.parse("${AppUrl.pcmURL}/Victim/GetAll/$intakeAssessmentId"));
      switch (response.statusCode) {
        case 200:
          apiResponse.Data = (json.decode(response.body) as List)
              .map((data) => VictimDetailDto.fromJson(data))
              .toList();
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

  Future<ApiResponse> addVictimDetail(VictimDetailDto victimDetailDto) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final response = await client.post(
          Uri.parse("${AppUrl.pcmURL}/Victim/Add"),
          body: json.encode(victimDetailDto),
          headers: {'Content-Type': 'application/json'});
      switch (response.statusCode) {
        case 200:
          ApiResults apiResults =
              ApiResults.fromJson(json.decode(response.body));
          apiResponse.Data = apiResults;
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

  Future<ApiResponse> getVictimOrganisationDetailById(
      int? victimOrganisationId) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final response = await client.get(Uri.parse(
          "${AppUrl.pcmURL}/Victim/Organisation/$victimOrganisationId"));
      switch (response.statusCode) {
        case 200:
          apiResponse.Data =
              VictimOrganisationDetailDto.fromJson(json.decode(response.body));
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

  Future<ApiResponse> getVictimOrganisationDetailByIntakeAssessmentIdOnline(
      int? intakeAssessmentId) async {
    ApiResponse apiResponse = ApiResponse();

    final response = await client.get(Uri.parse(
        "${AppUrl.pcmURL}/Victim/Organisation/GetAll/$intakeAssessmentId"));
    switch (response.statusCode) {
      case 200:
        apiResponse.Data = (json.decode(response.body) as List)
            .map((data) => VictimOrganisationDetailDto.fromJson(data))
            .toList();
        break;
      default:
        apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
        break;
    }
    return apiResponse;
  }

  Future<ApiResponse> getVictimOrganisationDetailByIntakeAssessmentId(
      int? intakeAssessmentId) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      apiResponse = await getVictimOrganisationDetailByIntakeAssessmentIdOnline(
          intakeAssessmentId);
      if (apiResponse.ApiError == null) {
        List<VictimOrganisationDetailDto> victimOrganisationDetailDtoResponse =
            apiResponse.Data as List<VictimOrganisationDetailDto>;
        apiResponse.Data = victimOrganisationDetailDtoResponse;
        _victimOrganisationDetailRepository.saveVictimOrganisationDetailItems(
            victimOrganisationDetailDtoResponse);
      }
    } on SocketException {
      apiResponse.Data = _victimOrganisationDetailRepository
          .getAllVictimOrganisationDetailsByAssessmentId(intakeAssessmentId!);
    }
    return apiResponse;
  }

  Future<ApiResponse> addVictimOrganisationOnline(
      VictimOrganisationDetailDto victimOrganisationDetailDto) async {
    return await _httpClientService.httpClientPost(
        "${AppUrl.pcmURL}/Victim/Organisation/Add",
        victimOrganisationDetailDto);
  }

  Future<ApiResponse> addVictimOrganisation(
      VictimOrganisationDetailDto victimOrganisationDetailDto) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      apiResponse =
          await addVictimOrganisationOnline(victimOrganisationDetailDto);
      if (apiResponse.ApiError == null) {
        ApiResults apiResults = (apiResponse.Data as ApiResults);
        VictimOrganisationDetailDto victimOrganisationDetailDtoResponse =
            VictimOrganisationDetailDto.fromJson(apiResults.data);
        apiResponse.Data = victimOrganisationDetailDtoResponse;
        _victimOrganisationDetailRepository
            .saveVictimOrganisationDetailNewRecord(victimOrganisationDetailDto,
                victimOrganisationDetailDtoResponse.victimOrganisationId);
      }
    } on SocketException {
      _victimOrganisationDetailRepository
          .saveVictimOrganisationDetail(victimOrganisationDetailDto);
      apiResponse.Data =
          _victimOrganisationDetailRepository.getVictimOrganisationDetailById(
              victimOrganisationDetailDto.victimOrganisationId!);
    }
    return apiResponse;
  }

  Future<ApiResponse> addUpdateVictimOrganisationOnline(
      VictimOrganisationDetailDto victimOrganisationDetailDto) async {
    return await _httpClientService.httpClientPost(
        "${AppUrl.pcmURL}/Victim/Organisation/AddUpdate",
        victimOrganisationDetailDto);
  }
}
