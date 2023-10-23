import 'package:dsd_pcm_mobile/model/intake/disability_dto.dart';

import '../model/intake/address_type_dto.dart';
import '../model/intake/disability_type_dto.dart';
import '../model/intake/gender_dto.dart';
import '../model/intake/health_status_dto.dart';
import '../model/intake/identification_type_dto.dart';
import '../model/intake/language_dto.dart';
import '../model/intake/marital_status_dto.dart';
import '../model/intake/nationality_dto.dart';
import '../model/intake/person_address_dto.dart';
import '../model/intake/preferred_contact_type_dto.dart';
import '../model/intake/relationship_type_dto.dart';
import '../util/shared/apiresponse.dart';

class PersonTransform {
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
}
