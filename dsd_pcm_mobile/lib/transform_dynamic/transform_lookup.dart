import 'package:dsd_pcm_mobile/model/intake/cyca_facility_dto.dart';
import 'package:dsd_pcm_mobile/model/intake/disability_dto.dart';
import 'package:dsd_pcm_mobile/model/intake/pcm_order_dto.dart';
import 'package:dsd_pcm_mobile/model/intake/program_module_sessions_dto.dart';
import 'package:dsd_pcm_mobile/model/pcm/preliminaryStatus_dto.dart';
import 'package:dsd_pcm_mobile/model/intake/program_module_dto.dart';
import '../model/intake/address_type_dto.dart';
import '../model/intake/admission_type.dart';
import '../model/intake/compliance_dto.dart';
import '../model/intake/country_dto.dart';
import '../model/intake/disability_type_dto.dart';
import '../model/intake/district_dto.dart';
import '../model/intake/form_of_notification_dto.dart';
import '../model/intake/gender_dto.dart';
import '../model/intake/grade_dto.dart';
import '../model/intake/health_status_dto.dart';
import '../model/intake/identification_type_dto.dart';
import '../model/intake/language_dto.dart';
import '../model/intake/local_municipality_dto.dart';
import '../model/intake/marital_status_dto.dart';
import '../model/intake/nationality_dto.dart';
import '../model/intake/organization_dto.dart';
import '../model/intake/organization_type_dto.dart';
import '../model/intake/person_address_dto.dart';
import '../model/intake/placement_type_dto.dart';
import '../model/intake/preferred_contact_type_dto.dart';
import '../model/intake/province_dto.dart';
import '../model/intake/recommendation_type_dto.dart';
import '../model/intake/relationship_type_dto.dart';
import '../model/pcm/programmes_dto.dart';
import '../service/intake/look_up_service.dart';
import '../util/shared/apiresponse.dart';

class LookupTransform {
  final _lookUpServiceClient = LookUpService();
  late ApiResponse apiResponse = ApiResponse();
  late List<IdentificationTypeDto> identificationTypesDto = [];
  late List<DisabilityTypeDto> disabilityTypesDto = [];
  late List<DisabilityDto> disabilitiesDto = [];
  late List<GenderDto> gendersDto = [];
  late List<PreferredContactTypeDto> preferredContactTypesDto = [];
  late List<LanguageDto> languagesDto = [];
  late List<NationalityDto> nationalitiesDto = [];
  late List<MaritalStatusDto> maritalStatusesDto = [];
  late List<PersonAddressDto> previousAddressDto = [];
  late List<AddressTypeDto> addressTypesDto = [];
  late List<HealthStatusDto> healthStatusesDto = [];
  late List<RelationshipTypeDto> relationshipTypesDto = [];
  late List<PlacementTypeDto> placementTypesDto = [];
  late List<RecommendationTypeDto> recommendationTypesDto = [];
  late List<GradeDto> gradesDto = [];
  late List<FormOfNotificationDto> formOfNotificationsDto = [];
  late List<PreliminaryStatusDto> preliminayStatusDto = [];
  late List<ComplianceDto> complianceDto = [];
  late List<ProgrammesDto> programmesDto = [];
  late List<ProgramModuleDto> programModuleDto = [];
  late List<ProgramModuleSessionDto> programModuleSessionDto = [];
  late List<AdmissionTypeDto> admissionTypeDto = [];
  late List<CycaFacilityDto> cycaFacilityDto = [];
  late List<ProvinceDto> provinceDto = [];
  late List<PcmCountryDto> pcmCountryDto = [];
  late List<DistrictDto> districtDto = [];
  late List<LocalMunicipalityDto> localMunicipalityDto = [];
  late List<OrganizationTypeDto> organizationTypeDto = [];
  late List<OrganizationDto> organizationDto = [];
  late List<PcmOrderDto> pcmOrderDto = [];

  Future<List<IdentificationTypeDto>> transformIdentificationTypeDto() async {
    apiResponse = await _lookUpServiceClient.getIdentificationTypes();
    if ((apiResponse.ApiError) == null) {
      identificationTypesDto =
          (apiResponse.Data as List<IdentificationTypeDto>);
    }
    return identificationTypesDto;
  }

  Future<List<DisabilityTypeDto>> transformDisabilityTypesDto() async {
    apiResponse = await _lookUpServiceClient.getDisabilityTypes();
    if ((apiResponse.ApiError) == null) {
      disabilityTypesDto = (apiResponse.Data as List<DisabilityTypeDto>);
    }
    return disabilityTypesDto;
  }

  Future<List<DisabilityDto>> transformDisabilitiesDto() async {
    apiResponse = await _lookUpServiceClient.getDisabilities();
    if ((apiResponse.ApiError) == null) {
      disabilitiesDto = (apiResponse.Data as List<DisabilityDto>);
    }
    return disabilitiesDto;
  }

  Future<List<GenderDto>> transformGendersDto() async {
    apiResponse = await _lookUpServiceClient.getGenders();
    if ((apiResponse.ApiError) == null) {
      gendersDto = (apiResponse.Data as List<GenderDto>);
    }
    return gendersDto;
  }

  Future<List<PreferredContactTypeDto>>
      transformContactPreferredTypesDto() async {
    apiResponse = await _lookUpServiceClient.getPreferredContactTypes();
    if ((apiResponse.ApiError) == null) {
      preferredContactTypesDto =
          (apiResponse.Data as List<PreferredContactTypeDto>);
    }
    return preferredContactTypesDto;
  }

  Future<List<LanguageDto>> transformLanguageDto() async {
    apiResponse = await _lookUpServiceClient.getLanguages();
    if ((apiResponse.ApiError) == null) {
      languagesDto = (apiResponse.Data as List<LanguageDto>);
    }
    return languagesDto;
  }

  Future<List<NationalityDto>> transformNationalitiesDto() async {
    apiResponse = await _lookUpServiceClient.getNationalities();
    if ((apiResponse.ApiError) == null) {
      nationalitiesDto = (apiResponse.Data as List<NationalityDto>);
    }
    return nationalitiesDto;
  }

  Future<List<MaritalStatusDto>> transformMaritalStatusDto() async {
    apiResponse = await _lookUpServiceClient.getMaritalStatus();
    if ((apiResponse.ApiError) == null) {
      maritalStatusesDto = (apiResponse.Data as List<MaritalStatusDto>);
    }
    return maritalStatusesDto;
  }

  Future<List<HealthStatusDto>> transformHealthStatusesDto() async {
    apiResponse = await _lookUpServiceClient.getHealthStatuses();
    if ((apiResponse.ApiError) == null) {
      healthStatusesDto = (apiResponse.Data as List<HealthStatusDto>);
    }
    return healthStatusesDto;
  }

  Future<List<RelationshipTypeDto>> transformRelationshipTypeDto() async {
    apiResponse = await _lookUpServiceClient.getRelationshipTypes();
    if ((apiResponse.ApiError) == null) {
      relationshipTypesDto = (apiResponse.Data as List<RelationshipTypeDto>);
    }
    return relationshipTypesDto;
  }

  Future<List<PlacementTypeDto>> transformPlacementTypeDto() async {
    apiResponse = await _lookUpServiceClient.getPlacementTypes();
    if ((apiResponse.ApiError) == null) {
      placementTypesDto = (apiResponse.Data as List<PlacementTypeDto>);
    }
    return placementTypesDto;
  }

  Future<List<RecommendationTypeDto>> transformRecommendationTypeDto() async {
    apiResponse = await _lookUpServiceClient.getRecommendationTypes();
    if ((apiResponse.ApiError) == null) {
      recommendationTypesDto =
          (apiResponse.Data as List<RecommendationTypeDto>);
    }
    return recommendationTypesDto;
  }

  Future<List<FormOfNotificationDto>> transformFormOfNotificationDto() async {
    apiResponse = await _lookUpServiceClient.getFormOfNotifications();
    if ((apiResponse.ApiError) == null) {
      formOfNotificationsDto =
          (apiResponse.Data as List<FormOfNotificationDto>);
    }
    return formOfNotificationsDto;
  }

  Future<List<PreliminaryStatusDto>> transformPreliminaryStatusDto() async {
    apiResponse = await _lookUpServiceClient.getPreliminaryStatus();
    if ((apiResponse.ApiError) == null) {
      preliminayStatusDto = (apiResponse.Data as List<PreliminaryStatusDto>);
    }
    return preliminayStatusDto;
  }

  Future<List<ComplianceDto>> transformComplianceDto() async {
    apiResponse = await _lookUpServiceClient.getCompliance();
    if ((apiResponse.ApiError) == null) {
      complianceDto = (apiResponse.Data as List<ComplianceDto>);
    }
    return complianceDto;
  }

  Future<List<ProgrammesDto>> transformProgrammesDto() async {
    apiResponse = await _lookUpServiceClient.getProgrammes();
    if ((apiResponse.ApiError) == null) {
      programmesDto = (apiResponse.Data as List<ProgrammesDto>);
    }
    return programmesDto;
  }

  Future<List<ProgramModuleDto>> transformProgramModuleDto() async {
    apiResponse = await _lookUpServiceClient.getProgramModules();
    if ((apiResponse.ApiError) == null) {
      programModuleDto = (apiResponse.Data as List<ProgramModuleDto>);
    }
    return programModuleDto;
  }

  Future<List<ProgramModuleSessionDto>>
      transformProgrammeModuleSessionDto() async {
    apiResponse = await _lookUpServiceClient.getProgrammeModuleSessions();
    if ((apiResponse.ApiError) == null) {
      programModuleSessionDto =
          (apiResponse.Data as List<ProgramModuleSessionDto>);
    }
    return programModuleSessionDto;
  }

  Future<List<AdmissionTypeDto>> transformAdmissionTypeDto() async {
    apiResponse = await _lookUpServiceClient.getAdmissionTypes();
    if ((apiResponse.ApiError) == null) {
      admissionTypeDto = (apiResponse.Data as List<AdmissionTypeDto>);
    }
    return admissionTypeDto;
  }

  Future<List<CycaFacilityDto>> transformCycaFacilityDto() async {
    apiResponse = await _lookUpServiceClient.getCycaFacility();
    if ((apiResponse.ApiError) == null) {
      cycaFacilityDto = (apiResponse.Data as List<CycaFacilityDto>);
    }
    return cycaFacilityDto;
  }

  Future<List<ProvinceDto>> transformProvinceDto() async {
    apiResponse = await _lookUpServiceClient.getProvinces();
    if ((apiResponse.ApiError) == null) {
      provinceDto = (apiResponse.Data as List<ProvinceDto>);
    }
    return provinceDto;
  }

  Future<List<PcmCountryDto>> transformCountryDto() async {
    apiResponse = await _lookUpServiceClient.getCountries();
    if ((apiResponse.ApiError) == null) {
      pcmCountryDto = (apiResponse.Data as List<PcmCountryDto>);
    }
    return pcmCountryDto;
  }

  Future<List<OrganizationDto>> transformOrganizationDto(
      int? localMunicipalityId) async {
    apiResponse = await _lookUpServiceClient
        .getOrganizationsByLocalMunicipalityId(localMunicipalityId);
    if ((apiResponse.ApiError) == null) {
      organizationDto = (apiResponse.Data as List<OrganizationDto>);
    }
    return organizationDto;
  }

  Future<List<PcmOrderDto>> transformOrderDto() async {
    apiResponse = await _lookUpServiceClient.getPcmOrders();
    if ((apiResponse.ApiError) == null) {
      pcmOrderDto = (apiResponse.Data as List<PcmOrderDto>);
    }
    return pcmOrderDto;
  }
}
