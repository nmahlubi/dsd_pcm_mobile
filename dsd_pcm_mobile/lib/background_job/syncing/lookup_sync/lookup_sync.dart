import 'dart:io';

import 'package:dsd_pcm_mobile/domain/repository/lookup/disability_repository.dart';
import 'package:dsd_pcm_mobile/model/intake/disability_dto.dart';
import 'package:flutter/foundation.dart';

import '../../../domain/repository/lookup/disability_type_repository.dart';
import '../../../domain/repository/lookup/form_of_notification_repository.dart';
import '../../../domain/repository/lookup/gender_repository.dart';
import '../../../domain/repository/lookup/health_status_repository.dart';
import '../../../domain/repository/lookup/identification_type_repository.dart';
import '../../../domain/repository/lookup/language_repository.dart';
import '../../../domain/repository/lookup/marital_status_repository.dart';
import '../../../domain/repository/lookup/nationality_repository.dart';
import '../../../domain/repository/lookup/placement_type_repository.dart';
import '../../../domain/repository/lookup/preferred_contact_type_repository.dart';
import '../../../domain/repository/lookup/recommendation_type_repository.dart';
import '../../../domain/repository/lookup/relationship_type_repository.dart';
import '../../../model/intake/address_type_dto.dart';
import '../../../model/intake/disability_type_dto.dart';
import '../../../model/intake/form_of_notification_dto.dart';
import '../../../model/intake/gender_dto.dart';
import '../../../model/intake/health_status_dto.dart';
import '../../../model/intake/identification_type_dto.dart';
import '../../../model/intake/language_dto.dart';
import '../../../model/intake/marital_status_dto.dart';
import '../../../model/intake/nationality_dto.dart';
import '../../../model/intake/person_address_dto.dart';
import '../../../model/intake/placement_type_dto.dart';
import '../../../model/intake/preferred_contact_type_dto.dart';
import '../../../model/intake/recommendation_type_dto.dart';
import '../../../model/intake/relationship_type_dto.dart';
import '../../../service/intake/look_up_service.dart';
import '../../../util/shared/apiresponse.dart';

class LookupSync {
  final _lookUpService = LookUpService();
  final _genderRepository = GenderRepository();
  final _relationshipTypeRepository = RelationshipTypeRepository();
  final _healthStatusRepository = HealthStatusRepository();
  final _disabilityTypeRepository = DisabilityTypeRepository();
  final _disabilityRepository = DisabilityRepository();
  final _languageRepository = LanguageRepository();
  final _nationalityRepository = NationalityRepository();
  final _maritalStatusRepository = MaritalStatusRepository();
  final _identificationTypeRepository = IdentificationTypeRepository();
  final _preferredContactTypeRepository = PreferredContactTypeRepository();
  final _placementTypeRepository = PlacementTypeRepository();
  final _recommendationTypeRepository = RecommendationTypeRepository();
  final _formOfNotificationRepository = FormOfNotificationRepository();
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
  late List<RecommendationTypeDto> recommendationTypeDto = [];
  late List<PlacementTypeDto> placementTypeDto = [];
  late List<FormOfNotificationDto> formOfNotificationsDto = [];

  Future<void> syncGender() async {
    try {
      apiResponse = await _lookUpService.getGendersOnline();
      if ((apiResponse.ApiError) == null) {
        gendersDto = (apiResponse.Data as List<GenderDto>);
        await _genderRepository.deleteAllGenders();
        await _genderRepository.saveGenderItems(gendersDto);
      }
    } on SocketException catch (_) {
      if (kDebugMode) {
        print('Unable to access _lookUpService.syncGender endpoint');
      }
    }
  }

  Future<void> syncRelationshipType() async {
    try {
      apiResponse = await _lookUpService.getRelationshipTypesOnline();
      if ((apiResponse.ApiError) == null) {
        relationshipTypesDto = (apiResponse.Data as List<RelationshipTypeDto>);
        await _relationshipTypeRepository.deleteAllRelationshipTypes();
        await _relationshipTypeRepository
            .saveRelationshipTypeItems(relationshipTypesDto);
      }
    } on SocketException catch (_) {
      if (kDebugMode) {
        print('Unable to access _lookUpService.syncRelationshipType endpoint');
      }
    }
  }

  Future<void> syncHealthStatuses() async {
    try {
      apiResponse = await _lookUpService.getHealthStatusesOnline();
      if ((apiResponse.ApiError) == null) {
        healthStatusesDto = (apiResponse.Data as List<HealthStatusDto>);
        await _healthStatusRepository.deleteAllHealthStatuses();
        await _healthStatusRepository.saveHealthStatusItems(healthStatusesDto);
      }
    } on SocketException catch (_) {
      if (kDebugMode) {
        print('Unable to access _lookUpService.syncHealthStatuses endpoint');
      }
    }
  }

  Future<void> syncDisabilityType() async {
    try {
      apiResponse = await _lookUpService.getDisabilityTypesOnline();
      if ((apiResponse.ApiError) == null) {
        disabilityTypesDto = (apiResponse.Data as List<DisabilityTypeDto>);
        await _disabilityTypeRepository.deleteAllDisabilityTypes();
        await _disabilityTypeRepository
            .saveDisabilityTypeItems(disabilityTypesDto);
      }
    } on SocketException catch (_) {
      if (kDebugMode) {
        print('Unable to access _lookUpService.syncDisabilityType endpoint');
      }
    }
  }

  Future<void> syncDisability() async {
    try {
      apiResponse = await _lookUpService.getDisabilitiesOnline();
      if ((apiResponse.ApiError) == null) {
        disabilitiesDto = (apiResponse.Data as List<DisabilityDto>);
        await _disabilityRepository.deleteAllDisabilities();
        await _disabilityRepository.saveDisabilityItems(disabilitiesDto);
      }
    } on SocketException catch (_) {
      if (kDebugMode) {
        print('Unable to access _lookUpService.syncDisability endpoint');
      }
    }
  }

  Future<void> syncLanguages() async {
    try {
      apiResponse = await _lookUpService.getLanguagesOnline();
      if ((apiResponse.ApiError) == null) {
        languagesDto = (apiResponse.Data as List<LanguageDto>);
        await _languageRepository.deleteAllLanguages();
        await _languageRepository.saveLanguageItems(languagesDto);
      }
    } on SocketException catch (_) {
      if (kDebugMode) {
        print('Unable to access _lookUpService.syncLanguages endpoint');
      }
    }
  }

  Future<void> syncNationalities() async {
    try {
      apiResponse = await _lookUpService.getNationalitiesOnline();
      if ((apiResponse.ApiError) == null) {
        nationalitiesDto = (apiResponse.Data as List<NationalityDto>);
        await _nationalityRepository.deleteAllNationalities();
        await _nationalityRepository.saveNationalityItems(nationalitiesDto);
      }
    } on SocketException catch (_) {
      if (kDebugMode) {
        print('Unable to access _lookUpService.syncNationalities endpoint');
      }
    }
  }

  Future<void> syncMaritalStatus() async {
    try {
      apiResponse = await _lookUpService.getMaritalStatusOnline();
      if ((apiResponse.ApiError) == null) {
        maritalStatusesDto = (apiResponse.Data as List<MaritalStatusDto>);
        await _maritalStatusRepository.deleteAllMaritalStatuses();
        await _maritalStatusRepository
            .saveMaritalStatusItems(maritalStatusesDto);
      }
    } on SocketException catch (_) {
      if (kDebugMode) {
        print('Unable to access _lookUpService.syncMaritalStatus endpoint');
      }
    }
  }

  Future<void> syncIdentificationTypes() async {
    try {
      apiResponse = await _lookUpService.getIdentificationTypesOnline();
      if ((apiResponse.ApiError) == null) {
        identificationTypesDto =
            (apiResponse.Data as List<IdentificationTypeDto>);
        await _identificationTypeRepository.deleteAllIdentificationTypes();
        await _identificationTypeRepository
            .saveIdentificationTypeItems(identificationTypesDto);
      }
    } on SocketException catch (_) {
      if (kDebugMode) {
        print(
            'Unable to access _lookUpService.syncIdentificationTypes endpoint');
      }
    }
  }

  Future<void> syncPreferredContactTypes() async {
    try {
      apiResponse = await _lookUpService.getPreferredContactTypesOnline();
      if ((apiResponse.ApiError) == null) {
        preferredContactTypesDto =
            (apiResponse.Data as List<PreferredContactTypeDto>);
        await _preferredContactTypeRepository.deleteAllPreferredContactTypes();
        await _preferredContactTypeRepository
            .savePreferredContactTypeItems(preferredContactTypesDto);
      }
    } on SocketException catch (_) {
      if (kDebugMode) {
        print(
            'Unable to access _lookUpService.syncPreferredContactTypes endpoint');
      }
    }
  }

  Future<void> syncRecommendationTypes() async {
    try {
      apiResponse = await _lookUpService.getRecommendationTypesOnline();
      if ((apiResponse.ApiError) == null) {
        recommendationTypeDto =
            (apiResponse.Data as List<RecommendationTypeDto>);
        await _recommendationTypeRepository.deleteAllRecommendationTypes();
        await _recommendationTypeRepository
            .saveRecommendationTypeItems(recommendationTypeDto);
      }
    } on SocketException catch (_) {
      if (kDebugMode) {
        print(
            'Unable to access _lookUpService.syncRecommendationTypes endpoint');
      }
    }
  }

  Future<void> syncPlacementTypes() async {
    try {
      apiResponse = await _lookUpService.getPlacementTypesOnline();
      if ((apiResponse.ApiError) == null) {
        placementTypeDto = (apiResponse.Data as List<PlacementTypeDto>);
        await _placementTypeRepository.deleteAllPlacementTypes();
        await _placementTypeRepository.savePlacementTypeItems(placementTypeDto);
      }
    } on SocketException catch (_) {
      if (kDebugMode) {
        print('Unable to access _lookUpService.syncPlacementTypes endpoint');
      }
    }
  }

  Future<void> syncFormOfNotifications() async {
    try {
      apiResponse = await _lookUpService.getFormOfNotificationsOnline();
      if ((apiResponse.ApiError) == null) {
        formOfNotificationsDto =
            (apiResponse.Data as List<FormOfNotificationDto>);
        await _formOfNotificationRepository.deleteAllFormOfNotifications();
        await _formOfNotificationRepository
            .saveFormOfNotificationItems(formOfNotificationsDto);
      }
    } on SocketException catch (_) {
      if (kDebugMode) {
        print(
            'Unable to access _lookUpService.syncFormOfNotifications endpoint');
      }
    }
  }
}
