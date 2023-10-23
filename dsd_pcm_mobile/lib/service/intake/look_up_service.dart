import 'dart:convert';
import 'dart:io';
import 'package:dsd_pcm_mobile/domain/repository/lookup/disability_repository.dart';
import 'package:dsd_pcm_mobile/model/intake/country_dto.dart';
import 'package:dsd_pcm_mobile/model/intake/disability_dto.dart';
import 'package:dsd_pcm_mobile/model/intake/pcm_order_dto.dart';
import 'package:dsd_pcm_mobile/model/intake/program_module_sessions_dto.dart';
import 'package:dsd_pcm_mobile/model/intake/program_module_dto.dart';
import 'package:http_interceptor/http/intercepted_client.dart';

import '../../domain/repository/lookup/disability_type_repository.dart';
import '../../domain/repository/lookup/form_of_notification_repository.dart';
import '../../domain/repository/lookup/gender_repository.dart';
import '../../domain/repository/lookup/health_status_repository.dart';
import '../../domain/repository/lookup/identification_type_repository.dart';
import '../../domain/repository/lookup/language_repository.dart';
import '../../domain/repository/lookup/marital_status_repository.dart';
import '../../domain/repository/lookup/nationality_repository.dart';
import '../../domain/repository/lookup/pcm_order_repository.dart';
import '../../domain/repository/lookup/placement_type_repository.dart';
import '../../domain/repository/lookup/preferred_contact_type_repository.dart';
import '../../domain/repository/lookup/recommendation_type_repository.dart';
import '../../domain/repository/lookup/relationship_type_repository.dart';
import '../../model/intake/admission_type.dart';
import '../../model/intake/compliance_dto.dart';
import '../../model/intake/cyca_facility_dto.dart';
import '../../model/intake/disability_type_dto.dart';
import '../../model/intake/form_of_notification_dto.dart';
import '../../model/intake/gender_dto.dart';
import '../../model/intake/health_status_dto.dart';
import '../../model/intake/identification_type_dto.dart';
import '../../model/intake/language_dto.dart';
import '../../model/intake/marital_status_dto.dart';
import '../../model/intake/nationality_dto.dart';
import '../../model/intake/organization_dto.dart';
import '../../model/intake/preferred_contact_type_dto.dart';
import '../../model/intake/province_dto.dart';
import '../../model/intake/recommendation_type_dto.dart';
import '../../model/intake/relationship_type_dto.dart';
import '../../model/intake/placement_type_dto.dart';
import '../../model/pcm/preliminaryStatus_dto.dart';
import '../../model/pcm/programmes_dto.dart';
import '../../util/app_url.dart';
import '../../util/auth_intercept/authorization_interceptor.dart';
import '../../util/shared/apierror.dart';
import '../../util/shared/apiresponse.dart';

class LookUpService {
  final client =
      InterceptedClient.build(interceptors: [AuthorizationInterceptor()]);
  final genderRepository = GenderRepository();
  final relationshipTypeRepository = RelationshipTypeRepository();
  final healthStatusRepository = HealthStatusRepository();
  final disabilityRepository = DisabilityRepository();
  final disabilityTypeRepository = DisabilityTypeRepository();
  final languageRepository = LanguageRepository();
  final nationalityRepository = NationalityRepository();
  final maritalStatusRepository = MaritalStatusRepository();
  final identificationTypeRepository = IdentificationTypeRepository();
  final preferredContactTypeRepository = PreferredContactTypeRepository();
  final placementTypeRepository = PlacementTypeRepository();
  final recommendationTypeRepository = RecommendationTypeRepository();
  final formOfNotificationRepository = FormOfNotificationRepository();
  final pcmOrderDetailRepository = PcmOrderDetailRepository();

  Future<ApiResponse> getGendersOnline() async {
    ApiResponse apiResponse = ApiResponse();
    final response =
        await client.get(Uri.parse("${AppUrl.intakeURL}/LookUp/Gender"));
    switch (response.statusCode) {
      case 200:
        apiResponse.Data = (json.decode(response.body) as List)
            .map((data) => GenderDto.fromJson(data))
            .toList();
        break;
      default:
        apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
        break;
    }
    return apiResponse;
  }

  Future<ApiResponse> getGenders() async {
    ApiResponse apiResponse = ApiResponse();
    try {
      if (genderRepository.getAllGenders().isNotEmpty) {
        apiResponse.Data = genderRepository.getAllGenders();
        return apiResponse;
      }
      apiResponse = await getGendersOnline();
      if (apiResponse.ApiError == null) {
        List<GenderDto> gendersDtoResponse =
            apiResponse.Data as List<GenderDto>;
        apiResponse.Data = gendersDtoResponse;
        genderRepository.saveGenderItems(gendersDtoResponse);
      }
    } on SocketException {
      apiResponse.Data = genderRepository.getAllGenders();
    }
    return apiResponse;
  }

  Future<ApiResponse> getRelationshipTypesOnline() async {
    ApiResponse apiResponse = ApiResponse();
    final response = await client
        .get(Uri.parse("${AppUrl.intakeURL}/LookUp/RelationshipType"));
    switch (response.statusCode) {
      case 200:
        apiResponse.Data = (json.decode(response.body) as List)
            .map((data) => RelationshipTypeDto.fromJson(data))
            .toList();
        break;
      default:
        apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
        break;
    }
    return apiResponse;
  }

  Future<ApiResponse> getRelationshipTypes() async {
    ApiResponse apiResponse = ApiResponse();
    try {
      if (relationshipTypeRepository.getAllRelationshipTypes().isNotEmpty) {
        apiResponse.Data = relationshipTypeRepository.getAllRelationshipTypes();
        return apiResponse;
      }
      apiResponse = await getRelationshipTypesOnline();
      if (apiResponse.ApiError == null) {
        List<RelationshipTypeDto> relationshipTypesDtoResponse =
            apiResponse.Data as List<RelationshipTypeDto>;
        apiResponse.Data = relationshipTypesDtoResponse;
        relationshipTypeRepository
            .saveRelationshipTypeItems(relationshipTypesDtoResponse);
      }
    } on SocketException {
      apiResponse.Data = relationshipTypeRepository.getAllRelationshipTypes();
    }
    return apiResponse;
  }

  Future<ApiResponse> getHealthStatusesOnline() async {
    ApiResponse apiResponse = ApiResponse();
    final response =
        await client.get(Uri.parse("${AppUrl.intakeURL}/LookUp/HealthStatus"));
    switch (response.statusCode) {
      case 200:
        apiResponse.Data = (json.decode(response.body) as List)
            .map((data) => HealthStatusDto.fromJson(data))
            .toList();
        break;
      default:
        apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
        break;
    }
    return apiResponse;
  }

  Future<ApiResponse> getHealthStatuses() async {
    ApiResponse apiResponse = ApiResponse();
    try {
      if (healthStatusRepository.getAllHealthStatuses().isNotEmpty) {
        apiResponse.Data = healthStatusRepository.getAllHealthStatuses();
        return apiResponse;
      }
      apiResponse = await getHealthStatusesOnline();
      if (apiResponse.ApiError == null) {
        List<HealthStatusDto> healthStatusDtoResponse =
            apiResponse.Data as List<HealthStatusDto>;
        apiResponse.Data = healthStatusDtoResponse;
        healthStatusRepository.saveHealthStatusItems(healthStatusDtoResponse);
      }
    } on SocketException {
      apiResponse.Data = healthStatusRepository.getAllHealthStatuses();
    }
    return apiResponse;
  }

  Future<ApiResponse> getDisabilityTypesOnline() async {
    ApiResponse apiResponse = ApiResponse();
    final response = await client
        .get(Uri.parse("${AppUrl.intakeURL}/LookUp/DisabilityType"));
    switch (response.statusCode) {
      case 200:
        apiResponse.Data = (json.decode(response.body) as List)
            .map((data) => DisabilityTypeDto.fromJson(data))
            .toList();
        break;
      default:
        apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
        break;
    }
    return apiResponse;
  }

  Future<ApiResponse> getDisabilityTypes() async {
    ApiResponse apiResponse = ApiResponse();
    try {
      if (disabilityTypeRepository.getAllDisabilityTypes().isNotEmpty) {
        apiResponse.Data = disabilityTypeRepository.getAllDisabilityTypes();
        return apiResponse;
      }
      apiResponse = await getDisabilityTypesOnline();
      if (apiResponse.ApiError == null) {
        List<DisabilityTypeDto> disabilityTypeDtoResponse =
            apiResponse.Data as List<DisabilityTypeDto>;
        apiResponse.Data = disabilityTypeDtoResponse;
        disabilityTypeRepository
            .saveDisabilityTypeItems(disabilityTypeDtoResponse);
      }
    } on SocketException {
      apiResponse.Data = disabilityTypeRepository.getAllDisabilityTypes();
    }
    return apiResponse;
  }

  Future<ApiResponse> getDisabilitiesOnline() async {
    ApiResponse apiResponse = ApiResponse();
    final response =
        await client.get(Uri.parse("${AppUrl.intakeURL}/LookUp/Disability"));
    switch (response.statusCode) {
      case 200:
        apiResponse.Data = (json.decode(response.body) as List)
            .map((data) => DisabilityDto.fromJson(data))
            .toList();
        break;
      default:
        apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
        break;
    }
    return apiResponse;
  }

  Future<ApiResponse> getDisabilities() async {
    ApiResponse apiResponse = ApiResponse();
    try {
      if (disabilityRepository.getAllDisabilities().isNotEmpty) {
        apiResponse.Data = disabilityRepository.getAllDisabilities();
        return apiResponse;
      }
      apiResponse = await getDisabilitiesOnline();
      if (apiResponse.ApiError == null) {
        List<DisabilityDto> disabilityDtoResponse =
            apiResponse.Data as List<DisabilityDto>;
        apiResponse.Data = disabilityDtoResponse;
        disabilityRepository.saveDisabilityItems(disabilityDtoResponse);
      }
    } on SocketException {
      apiResponse.Data = disabilityRepository.getAllDisabilities();
    }
    return apiResponse;
  }

  Future<ApiResponse> getLanguagesOnline() async {
    ApiResponse apiResponse = ApiResponse();
    final response =
        await client.get(Uri.parse("${AppUrl.intakeURL}/LookUp/Language"));
    switch (response.statusCode) {
      case 200:
        apiResponse.Data = (json.decode(response.body) as List)
            .map((data) => LanguageDto.fromJson(data))
            .toList();
        break;
      default:
        apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
        break;
    }
    return apiResponse;
  }

  Future<ApiResponse> getLanguages() async {
    ApiResponse apiResponse = ApiResponse();
    try {
      if (languageRepository.getAllLanguages().isNotEmpty) {
        apiResponse.Data = languageRepository.getAllLanguages();
        return apiResponse;
      }
      apiResponse = await getLanguagesOnline();
      if (apiResponse.ApiError == null) {
        List<LanguageDto> languageDtoResponse =
            apiResponse.Data as List<LanguageDto>;
        apiResponse.Data = languageDtoResponse;
        languageRepository.saveLanguageItems(languageDtoResponse);
      }
    } on SocketException {
      apiResponse.Data = languageRepository.getAllLanguages();
    }
    return apiResponse;
  }

  Future<ApiResponse> getNationalitiesOnline() async {
    ApiResponse apiResponse = ApiResponse();
    final response =
        await client.get(Uri.parse("${AppUrl.intakeURL}/LookUp/Nationality"));
    switch (response.statusCode) {
      case 200:
        apiResponse.Data = (json.decode(response.body) as List)
            .map((data) => NationalityDto.fromJson(data))
            .toList();
        break;
      default:
        apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
        break;
    }
    return apiResponse;
  }

  Future<ApiResponse> getNationalities() async {
    ApiResponse apiResponse = ApiResponse();
    try {
      if (nationalityRepository.getAllNationalities().isNotEmpty) {
        apiResponse.Data = nationalityRepository.getAllNationalities();
        return apiResponse;
      }
      apiResponse = await getNationalitiesOnline();
      if (apiResponse.ApiError == null) {
        List<NationalityDto> nationalityDtoResponse =
            apiResponse.Data as List<NationalityDto>;
        apiResponse.Data = nationalityDtoResponse;
        nationalityRepository.saveNationalityItems(nationalityDtoResponse);
      }
    } on SocketException {
      apiResponse.Data = nationalityRepository.getAllNationalities();
    }
    return apiResponse;
  }

  Future<ApiResponse> getMaritalStatusOnline() async {
    ApiResponse apiResponse = ApiResponse();
    final response =
        await client.get(Uri.parse("${AppUrl.intakeURL}/LookUp/MaritalStatus"));
    switch (response.statusCode) {
      case 200:
        apiResponse.Data = (json.decode(response.body) as List)
            .map((data) => MaritalStatusDto.fromJson(data))
            .toList();
        break;
      default:
        apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
        break;
    }
    return apiResponse;
  }

  Future<ApiResponse> getMaritalStatus() async {
    ApiResponse apiResponse = ApiResponse();
    try {
      if (maritalStatusRepository.getAllMaritalStatuses().isNotEmpty) {
        apiResponse.Data = maritalStatusRepository.getAllMaritalStatuses();
        return apiResponse;
      }
      apiResponse = await getMaritalStatusOnline();
      if (apiResponse.ApiError == null) {
        List<MaritalStatusDto> maritalStatusDtoResponse =
            apiResponse.Data as List<MaritalStatusDto>;
        apiResponse.Data = maritalStatusDtoResponse;
        maritalStatusRepository
            .saveMaritalStatusItems(maritalStatusDtoResponse);
      }
    } on SocketException {
      apiResponse.Data = maritalStatusRepository.getAllMaritalStatuses();
    }
    return apiResponse;
  }

  Future<ApiResponse> getIdentificationTypesOnline() async {
    ApiResponse apiResponse = ApiResponse();
    final response = await client
        .get(Uri.parse("${AppUrl.intakeURL}/LookUp/IdentificationType"));
    switch (response.statusCode) {
      case 200:
        apiResponse.Data = (json.decode(response.body) as List)
            .map((data) => IdentificationTypeDto.fromJson(data))
            .toList();
        break;
      default:
        apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
        break;
    }
    return apiResponse;
  }

  Future<ApiResponse> getIdentificationTypes() async {
    ApiResponse apiResponse = ApiResponse();
    try {
      if (identificationTypeRepository.getAllIdentificationTypes().isNotEmpty) {
        apiResponse.Data =
            identificationTypeRepository.getAllIdentificationTypes();
        return apiResponse;
      }
      apiResponse = await getIdentificationTypesOnline();
      if (apiResponse.ApiError == null) {
        List<IdentificationTypeDto> identificationTypeDtoResponse =
            apiResponse.Data as List<IdentificationTypeDto>;
        apiResponse.Data = identificationTypeDtoResponse;
        identificationTypeRepository
            .saveIdentificationTypeItems(identificationTypeDtoResponse);
      }
    } on SocketException {
      apiResponse.Data =
          identificationTypeRepository.getAllIdentificationTypes();
    }
    return apiResponse;
  }

  Future<ApiResponse> getPreferredContactTypesOnline() async {
    ApiResponse apiResponse = ApiResponse();
    final response = await client
        .get(Uri.parse("${AppUrl.intakeURL}/LookUp/PreferredContactType"));
    switch (response.statusCode) {
      case 200:
        apiResponse.Data = (json.decode(response.body) as List)
            .map((data) => PreferredContactTypeDto.fromJson(data))
            .toList();
        break;
      default:
        apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
        break;
    }
    return apiResponse;
  }

  Future<ApiResponse> getPreferredContactTypes() async {
    ApiResponse apiResponse = ApiResponse();
    try {
      if (preferredContactTypeRepository
          .getAllPreferredContactTypes()
          .isNotEmpty) {
        apiResponse.Data =
            preferredContactTypeRepository.getAllPreferredContactTypes();
        return apiResponse;
      }
      apiResponse = await getPreferredContactTypesOnline();
      if (apiResponse.ApiError == null) {
        List<PreferredContactTypeDto> preferredContactTypeDtoResponse =
            apiResponse.Data as List<PreferredContactTypeDto>;
        apiResponse.Data = preferredContactTypeDtoResponse;
        preferredContactTypeRepository
            .savePreferredContactTypeItems(preferredContactTypeDtoResponse);
      }
    } on SocketException {
      apiResponse.Data =
          preferredContactTypeRepository.getAllPreferredContactTypes();
    }
    return apiResponse;
  }

  Future<ApiResponse> getRecommendationTypesOnline() async {
    ApiResponse apiResponse = ApiResponse();
    final response = await client
        .get(Uri.parse("${AppUrl.intakeURL}/LookUp/RecommendationType"));
    switch (response.statusCode) {
      case 200:
        apiResponse.Data = (json.decode(response.body) as List)
            .map((data) => RecommendationTypeDto.fromJson(data))
            .toList();
        break;
      default:
        apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
        break;
    }
    return apiResponse;
  }

  Future<ApiResponse> getRecommendationTypes() async {
    ApiResponse apiResponse = ApiResponse();
    try {
      if (recommendationTypeRepository.getAllRecommendationTypes().isNotEmpty) {
        apiResponse.Data =
            recommendationTypeRepository.getAllRecommendationTypes();
        return apiResponse;
      }
      apiResponse = await getRecommendationTypesOnline();
      if (apiResponse.ApiError == null) {
        List<RecommendationTypeDto> recommendationTypeDtoResponse =
            apiResponse.Data as List<RecommendationTypeDto>;
        apiResponse.Data = recommendationTypeDtoResponse;
        recommendationTypeRepository
            .saveRecommendationTypeItems(recommendationTypeDtoResponse);
      }
    } on SocketException {
      apiResponse.Data =
          recommendationTypeRepository.getAllRecommendationTypes();
    }
    return apiResponse;
  }

  Future<ApiResponse> getPlacementTypesOnline() async {
    ApiResponse apiResponse = ApiResponse();
    final response =
        await client.get(Uri.parse("${AppUrl.intakeURL}/LookUp/PlacementType"));
    switch (response.statusCode) {
      case 200:
        apiResponse.Data = (json.decode(response.body) as List)
            .map((data) => PlacementTypeDto.fromJson(data))
            .toList();
        break;
      default:
        apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
        break;
    }
    return apiResponse;
  }

  Future<ApiResponse> getPlacementTypes() async {
    ApiResponse apiResponse = ApiResponse();
    try {
      if (placementTypeRepository.getAllPlacementTypes().isNotEmpty) {
        apiResponse.Data = placementTypeRepository.getAllPlacementTypes();
        return apiResponse;
      }
      apiResponse = await getPlacementTypesOnline();
      if (apiResponse.ApiError == null) {
        List<PlacementTypeDto> placementTypeDtoResponse =
            apiResponse.Data as List<PlacementTypeDto>;
        apiResponse.Data = placementTypeDtoResponse;
        placementTypeRepository
            .savePlacementTypeItems(placementTypeDtoResponse);
      }
    } on SocketException {
      apiResponse.Data = placementTypeRepository.getAllPlacementTypes();
    }
    return apiResponse;
  }

  Future<ApiResponse> getFormOfNotificationsOnline() async {
    ApiResponse apiResponse = ApiResponse();
    final response = await client
        .get(Uri.parse("${AppUrl.intakeURL}/LookUp/FormOfNotification"));
    switch (response.statusCode) {
      case 200:
        apiResponse.Data = (json.decode(response.body) as List)
            .map((data) => FormOfNotificationDto.fromJson(data))
            .toList();
        break;
      default:
        apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
        break;
    }
    return apiResponse;
  }

  Future<ApiResponse> getFormOfNotifications() async {
    ApiResponse apiResponse = ApiResponse();
    try {
      if (formOfNotificationRepository.getAllFormOfNotifications().isNotEmpty) {
        apiResponse.Data =
            formOfNotificationRepository.getAllFormOfNotifications();
        return apiResponse;
      }
      apiResponse = await getFormOfNotificationsOnline();
      if (apiResponse.ApiError == null) {
        List<FormOfNotificationDto> formOfNotificationsDtoResponse =
            apiResponse.Data as List<FormOfNotificationDto>;
        apiResponse.Data = formOfNotificationsDtoResponse;
        formOfNotificationRepository
            .saveFormOfNotificationItems(formOfNotificationsDtoResponse);
      }
    } on SocketException {
      apiResponse.Data =
          formOfNotificationRepository.getAllFormOfNotifications();
    }
    return apiResponse;
  }

  Future<ApiResponse> getPreliminaryStatus() async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final response = await client
          .get(Uri.parse("${AppUrl.intakeURL}/LookUp/PreliminaryStatus"));

      switch (response.statusCode) {
        case 200:
          apiResponse.Data = (json.decode(response.body) as List)
              .map((data) => PreliminaryStatusDto.fromJson(data))
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

  Future<ApiResponse> getCompliance() async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final response =
          await client.get(Uri.parse("${AppUrl.intakeURL}/LookUp/Compliance"));

      switch (response.statusCode) {
        case 200:
          apiResponse.Data = (json.decode(response.body) as List)
              .map((data) => ComplianceDto.fromJson(data))
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

  Future<ApiResponse> getProgrammes() async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final response =
          await client.get(Uri.parse("${AppUrl.intakeURL}/LookUp/Programmes"));

      switch (response.statusCode) {
        case 200:
          apiResponse.Data = (json.decode(response.body) as List)
              .map((data) => ProgrammesDto.fromJson(data))
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

  Future<ApiResponse> getProgramModules() async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final response = await client
          .get(Uri.parse("${AppUrl.intakeURL}/LookUp/Programmemodule"));

      switch (response.statusCode) {
        case 200:
          apiResponse.Data = (json.decode(response.body) as List)
              .map((data) => ProgramModuleDto.fromJson(data))
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

  Future<ApiResponse> getProgrammeModuleSessions() async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final response = await client
          .get(Uri.parse("${AppUrl.intakeURL}/LookUp/ProgrammemoduleSession"));

      switch (response.statusCode) {
        case 200:
          apiResponse.Data = (json.decode(response.body) as List)
              .map((data) => ProgramModuleSessionDto.fromJson(data))
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

  Future<ApiResponse> getAdmissionTypes() async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final response = await client
          .get(Uri.parse("${AppUrl.intakeURL}/LookUp/AdmissionTypes"));

      switch (response.statusCode) {
        case 200:
          apiResponse.Data = (json.decode(response.body) as List)
              .map((data) => AdmissionTypeDto.fromJson(data))
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

  Future<ApiResponse> getCycaFacility() async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final response = await client
          .get(Uri.parse("${AppUrl.intakeURL}/LookUp/CycaFacility"));

      switch (response.statusCode) {
        case 200:
          apiResponse.Data = (json.decode(response.body) as List)
              .map((data) => CycaFacilityDto.fromJson(data))
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

  Future<ApiResponse> getProvinces() async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final response =
          await client.get(Uri.parse("${AppUrl.intakeURL}/LookUp/Provinces"));

      switch (response.statusCode) {
        case 200:
          apiResponse.Data = (json.decode(response.body) as List)
              .map((data) => ProvinceDto.fromJson(data))
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

  Future<ApiResponse> getCountries() async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final response =
          await client.get(Uri.parse("${AppUrl.intakeURL}/LookUp/Countries"));

      switch (response.statusCode) {
        case 200:
          apiResponse.Data = (json.decode(response.body) as List)
              .map((data) => PcmCountryDto.fromJson(data))
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

  Future<ApiResponse> getOrganizationsByLocalMunicipalityId(
      int? localMunicipalityId) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final response = await client.get(Uri.parse(
          "${AppUrl.intakeURL}/LookUp/Organization/Get/$localMunicipalityId"));

      switch (response.statusCode) {
        case 200:
          apiResponse.Data = (json.decode(response.body) as List)
              .map((data) => OrganizationDto.fromJson(data))
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

  Future<ApiResponse> getPcmOrdersOnline() async {
    ApiResponse apiResponse = ApiResponse();

    final response =
        await client.get(Uri.parse("${AppUrl.intakeURL}/LookUp/Orders"));

    switch (response.statusCode) {
      case 200:
        apiResponse.Data = (json.decode(response.body) as List)
            .map((data) => PcmOrderDto.fromJson(data))
            .toList();
        break;
      default:
        apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
        break;
    }
    return apiResponse;
  }

  Future<ApiResponse> getPcmOrders() async {
    ApiResponse apiResponse = ApiResponse();
    try {
      if (pcmOrderDetailRepository.getAllPcmOrderlDetails().isNotEmpty) {
        apiResponse.Data = pcmOrderDetailRepository.getAllPcmOrderlDetails();
        return apiResponse;
      }
      apiResponse = await getPcmOrdersOnline();
      if (apiResponse.ApiError == null) {
        List<PcmOrderDto> pcmOrderDtooResponse =
            apiResponse.Data as List<PcmOrderDto>;
        apiResponse.Data = pcmOrderDtooResponse;
        pcmOrderDetailRepository.savePcmOrderDetailItems(pcmOrderDtooResponse);
      }
    } on SocketException {
      apiResponse.Data = pcmOrderDetailRepository.getAllPcmOrderlDetails();
    }
    return apiResponse;
  }
}
