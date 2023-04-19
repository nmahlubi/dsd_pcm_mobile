import 'country_dto.dart';
import 'gender_dto.dart';
import 'identity_type_dto.dart';
import 'language_dto.dart';
import 'race_dto.dart';

class ChildInformationDto {
  ChildInformationDto({
    int? childInformationId,
    int? personId,
    String? personName,
    String? personLastName,
    String? personDateOfBirth,
    int? personAge,
    String? personIDNumber,
    String? personFingerprintReference,
    String? personArrestDateTime,
    String? personReleasedDate,
    int? personGenderCodeId,
    int? personLanguageCodeId,
    int? raceId,
    int? identityTypeId,
    int? countyId,
    String? childName,
    String? childNameAbbr,
    GenderDto? genderDto,
    IdentityTypeDto? identityTypeDto,
    LanguageDto? languageDto,
    RaceDto? raceDto,
    CountryDto? countryDto,
  }) {
    _childInformationId = childInformationId;
    _personId = personId;
    _personName = personName;
    _personLastName = personLastName;
    _personDateOfBirth = personDateOfBirth;
    _personAge = personAge;
    _personIDNumber = personIDNumber;
    _personFingerprintReference = personFingerprintReference;
    _personArrestDateTime = personArrestDateTime;
    _personReleasedDate = personReleasedDate;
    _personGenderCodeId = personGenderCodeId;
    _personLanguageCodeId = personLanguageCodeId;
    _raceId = raceId;
    _identityTypeId = identityTypeId;
    _countyId = countyId;
    _childName = childName;
    _childNameAbbr = childNameAbbr;

    _genderDto = genderDto;
    _identityTypeDto = identityTypeDto;
    _languageDto = languageDto;
    _raceDto = raceDto;
    _countryDto = countryDto;
  }

  ChildInformationDto.fromJson(dynamic json) {
    _childInformationId = json['childInformationId'];
    _personId = json['personId'];
    _personName = json['personName'];
    _personLastName = json['personLastName'];
    _personDateOfBirth = json['personDateOfBirth'];
    _personAge = json['personAge'];
    _personIDNumber = json['personIDNumber'];
    _personFingerprintReference = json['personFingerprintReference'];
    _personArrestDateTime = json['personArrestDateTime'];
    _personReleasedDate = json['personReleasedDate'];
    _personGenderCodeId = json['personGenderCodeId'];
    _personLanguageCodeId = json['personLanguageCodeId'];
    _raceId = json['raceId'];
    _identityTypeId = json['identityTypeId'];
    _countyId = json['countyId'];
    _childName = json['childName'];
    _childNameAbbr = json['childNameAbbr'];

    _genderDto = json['genderDto'] != null
        ? GenderDto.fromJson(json['genderDto'])
        : null;
    _identityTypeDto = json['identityTypeDto'] != null
        ? IdentityTypeDto.fromJson(json['identityTypeDto'])
        : null;
    _languageDto = json['languageDto'] != null
        ? LanguageDto.fromJson(json['languageDto'])
        : null;
    _raceDto =
        json['raceDto'] != null ? RaceDto.fromJson(json['raceDto']) : null;
    _countryDto = json['countryDto'] != null
        ? CountryDto.fromJson(json['countryDto'])
        : null;
  }
  int? _childInformationId;
  int? _personId;
  String? _personName;
  String? _personLastName;
  String? _personDateOfBirth;
  int? _personAge;
  String? _personIDNumber;
  String? _personFingerprintReference;
  String? _personArrestDateTime;
  String? _personReleasedDate;
  int? _personGenderCodeId;
  int? _personLanguageCodeId;
  int? _raceId;
  int? _identityTypeId;
  int? _countyId;
  String? _childName;
  String? _childNameAbbr;
  GenderDto? _genderDto;
  IdentityTypeDto? _identityTypeDto;
  LanguageDto? _languageDto;
  RaceDto? _raceDto;
  CountryDto? _countryDto;

  int? get childInformationId => _childInformationId;
  int? get personId => _personId;
  String? get personName => _personName;
  String? get personLastName => _personLastName;
  String? get personDateOfBirth => _personDateOfBirth;
  int? get personAge => _personAge;
  String? get personIDNumber => _personIDNumber;
  String? get personFingerprintReference => _personFingerprintReference;
  String? get personArrestDateTime => _personArrestDateTime;
  String? get personReleasedDate => _personReleasedDate;
  int? get personGenderCodeId => _personGenderCodeId;
  int? get personLanguageCodeId => _personLanguageCodeId;
  int? get raceId => _raceId;
  int? get identityTypeId => _identityTypeId;
  int? get countyId => _countyId;
  String? get childName => _childName;
  String? get childNameAbbr => _childNameAbbr;
  GenderDto? get genderDto => _genderDto;
  IdentityTypeDto? get identityTypeDto => _identityTypeDto;
  LanguageDto? get languageDto => _languageDto;
  RaceDto? get raceDto => _raceDto;
  CountryDto? get countryDto => _countryDto;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['childInformationId'] = _childInformationId;
    map['personId'] = _personId;
    map['personName'] = _personName;
    map['personLastName'] = _personLastName;
    map['personDateOfBirth'] = _personDateOfBirth;
    map['personAge'] = _personAge;
    map['personIDNumber'] = _personIDNumber;
    map['personFingerprintReference'] = _personFingerprintReference;
    map['personArrestDateTime'] = _personArrestDateTime;
    map['personReleasedDate'] = _personReleasedDate;
    map['personGenderCodeId'] = _personGenderCodeId;
    map['personLanguageCodeId'] = _personLanguageCodeId;
    map['raceId'] = _raceId;
    map['identityTypeId'] = _identityTypeId;
    map['countyId'] = _countyId;
    map['childName'] = _childName;
    map['childNameAbbr'] = _childNameAbbr;
    if (_genderDto != null) {
      map['genderDto'] = _genderDto?.toJson();
    }
    if (_genderDto != null) {
      map['genderDto'] = _genderDto?.toJson();
    }
    if (_identityTypeDto != null) {
      map['identityTypeDto'] = _identityTypeDto?.toJson();
    }
    if (_languageDto != null) {
      map['languageDto'] = _languageDto?.toJson();
    }
    if (_raceDto != null) {
      map['raceDto'] = _raceDto?.toJson();
    }
    if (_countryDto != null) {
      map['countryDto'] = _countryDto?.toJson();
    }
    return map;
  }
}
