import 'disability_type_dto.dart';
import 'gender_dto.dart';
import 'identification_type_dto.dart';
import 'language_dto.dart';
import 'marital_status_dto.dart';
import 'nationality_dto.dart';
import 'person_address_dto.dart';

class PersonDto {
  PersonDto({
    int? personId,
    String? firstName,
    String? lastName,
    String? knownAs,
    int? identificationTypeId,
    String? identificationNumber,
    bool? isPivaValidated,
    String? pivaTransactionId,
    String? dateOfBirth,
    int? age,
    bool? isEstimatedAge,
    int? sexualOrientationId,
    int? languageId,
    int? genderId,
    int? maritalStatusId,
    int? preferredContactTypeId,
    int? religionId,
    String? phoneNumber,
    String? mobilePhoneNumber,
    String? emailAddress,
    int? populationGroupId,
    int? nationalityId,
    int? disabilityTypeId,
    int? citizenshipId,
    String? dateLastModified,
    String? modifiedBy,
    String? createdBy,
    DisabilityTypeDto? disabilityTypeDto,
    GenderDto? genderDto,
    LanguageDto? languageDto,
    MaritalStatusDto? maritalStatusDto,
    IdentificationTypeDto? identificationTypeDto,
    List<PersonAddressDto>? personAddressDto,
    PersonAddressDto? currentAddress,
    List<PersonAddressDto>? previousAddress,
  }) {
    _personId = personId;
    _firstName = firstName;
    _lastName = lastName;
    _knownAs = knownAs;
    _identificationTypeId = identificationTypeId;
    _identificationNumber = identificationNumber;
    _isPivaValidated = isPivaValidated;
    _pivaTransactionId = pivaTransactionId;
    _dateOfBirth = dateOfBirth;
    _age = age;
    _isEstimatedAge = isEstimatedAge;
    _sexualOrientationId = sexualOrientationId;
    _languageId = languageId;
    _genderId = genderId;
    _maritalStatusId = maritalStatusId;
    _preferredContactTypeId = preferredContactTypeId;
    _religionId = religionId;
    _phoneNumber = phoneNumber;
    _mobilePhoneNumber = mobilePhoneNumber;
    _emailAddress = emailAddress;
    _populationGroupId = populationGroupId;
    _nationalityId = nationalityId;
    _disabilityTypeId = disabilityTypeId;
    _citizenshipId = citizenshipId;
    _dateLastModified = dateLastModified;
    _modifiedBy = modifiedBy;
    _createdBy = createdBy;
    _disabilityTypeDto = disabilityTypeDto;
    _genderDto = genderDto;
    _languageDto = languageDto;
    _maritalStatusDto = maritalStatusDto;
    _identificationTypeDto = identificationTypeDto;
    _personAddressDto = personAddressDto;
    _currentAddress = currentAddress;
    _previousAddress = previousAddress;
  }

  PersonDto.fromJson(dynamic json) {
    _personId = json['personId'];
    _firstName = json['firstName'];
    _lastName = json['lastName'];
    _knownAs = json['knownAs'];
    _identificationTypeId = json['identificationTypeId'];
    _identificationNumber = json['identificationNumber'];
    _isPivaValidated = json['isPivaValidated'];
    _pivaTransactionId = json['pivaTransactionId'];
    _dateOfBirth = json['dateOfBirth'];
    _age = json['age'];
    _isEstimatedAge = json['isEstimatedAge'];
    _sexualOrientationId = json['sexualOrientationId'];
    _languageId = json['languageId'];
    _genderId = json['genderId'];
    _maritalStatusId = json['maritalStatusId'];
    _preferredContactTypeId = json['preferredContactTypeId'];
    _religionId = json['religionId'];
    _phoneNumber = json['phoneNumber'];
    _mobilePhoneNumber = json['mobilePhoneNumber'];
    _emailAddress = json['emailAddress'];
    _populationGroupId = json['populationGroupId'];
    _nationalityId = json['nationalityId'];
    _disabilityTypeId = json['disabilityTypeId'];
    _citizenshipId = json['citizenshipId'];
    _dateLastModified = json['dateLastModified'];
    _modifiedBy = json['modifiedBy'];
    _createdBy = json['createdBy'];
    _disabilityTypeDto = json['disabilityTypeDto'] != null
        ? DisabilityTypeDto.fromJson(json['disabilityTypeDto'])
        : null;
    _genderDto = json['genderDto'] != null
        ? GenderDto.fromJson(json['genderDto'])
        : null;
    _languageDto = json['languageDto'] != null
        ? LanguageDto.fromJson(json['languageDto'])
        : null;
    _nationalityDto = json['nationalityDto'] != null
        ? NationalityDto.fromJson(json['nationalityDto'])
        : null;
    _maritalStatusDto = json['maritalStatusDto'] != null
        ? MaritalStatusDto.fromJson(json['maritalStatusDto'])
        : null;
    _identificationTypeDto = json['identificationTypeDto'] != null
        ? IdentificationTypeDto.fromJson(json['identificationTypeDto'])
        : null;

    if (json['personAddressDto'] != null) {
      _personAddressDto = [];
      json['personAddressDto'].forEach((v) {
        _personAddressDto?.add(PersonAddressDto.fromJson(v));
      });
    }

    _currentAddress = json['currentAddress'] != null
        ? PersonAddressDto.fromJson(json['currentAddress'])
        : null;

    if (json['previousAddress'] != null) {
      _previousAddress = [];
      json['previousAddress'].forEach((v) {
        _previousAddress?.add(PersonAddressDto.fromJson(v));
      });
    }
  }

  int? _personId;
  String? _firstName;
  String? _lastName;
  String? _knownAs;
  int? _identificationTypeId;
  String? _identificationNumber;
  bool? _isPivaValidated;
  String? _pivaTransactionId;
  String? _dateOfBirth;
  int? _age;
  bool? _isEstimatedAge;
  int? _sexualOrientationId;
  int? _languageId;
  int? _genderId;
  int? _maritalStatusId;
  int? _preferredContactTypeId;
  int? _religionId;
  String? _phoneNumber;
  String? _mobilePhoneNumber;
  String? _emailAddress;
  int? _populationGroupId;
  int? _nationalityId;
  int? _disabilityTypeId;
  int? _citizenshipId;
  String? _dateLastModified;
  String? _modifiedBy;
  String? _createdBy;
  DisabilityTypeDto? _disabilityTypeDto;
  GenderDto? _genderDto;
  LanguageDto? _languageDto;
  NationalityDto? _nationalityDto;
  MaritalStatusDto? _maritalStatusDto;
  IdentificationTypeDto? _identificationTypeDto;
  List<PersonAddressDto>? _personAddressDto;
  PersonAddressDto? _currentAddress;
  List<PersonAddressDto>? _previousAddress;

  int? get personId => _personId;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get knownAs => _knownAs;
  int? get identificationTypeId => _identificationTypeId;
  String? get identificationNumber => _identificationNumber;
  bool? get isPivaValidated => _isPivaValidated;
  String? get pivaTransactionId => _pivaTransactionId;
  String? get dateOfBirth => _dateOfBirth;
  int? get age => _age;
  bool? get isEstimatedAge => _isEstimatedAge;
  int? get sexualOrientationId => _sexualOrientationId;
  int? get languageId => _languageId;
  int? get genderId => _genderId;
  int? get maritalStatusId => _maritalStatusId;
  int? get preferredContactTypeId => _preferredContactTypeId;
  int? get religionId => _religionId;
  String? get phoneNumber => _phoneNumber;
  String? get mobilePhoneNumber => _mobilePhoneNumber;
  String? get emailAddress => _emailAddress;
  int? get populationGroupId => _populationGroupId;
  int? get nationalityId => _nationalityId;
  int? get disabilityTypeId => _disabilityTypeId;
  int? get citizenshipId => _citizenshipId;
  String? get dateLastModified => _dateLastModified;
  String? get modifiedBy => _modifiedBy;
  String? get createdBy => _createdBy;
  DisabilityTypeDto? get disabilityTypeDto => _disabilityTypeDto;
  GenderDto? get genderDto => _genderDto;
  LanguageDto? get languageDto => _languageDto;
  NationalityDto? get nationalityDto => _nationalityDto;
  MaritalStatusDto? get maritalStatusDto => _maritalStatusDto;
  IdentificationTypeDto? get identificationTypeDto => _identificationTypeDto;
  List<PersonAddressDto>? get personAddressDto => _personAddressDto;
  PersonAddressDto? get currentAddress => _currentAddress;
  List<PersonAddressDto>? get previousAddress => _previousAddress;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['personId'] = _personId;
    map['firstName'] = _firstName;
    map['lastName'] = _lastName;
    map['knownAs'] = _knownAs;
    map['identificationTypeId'] = _identificationTypeId;
    map['identificationNumber'] = _identificationNumber;
    map['isPivaValidated'] = _isPivaValidated;
    map['pivaTransactionId'] = _pivaTransactionId;
    map['dateOfBirth'] = _dateOfBirth;
    map['age'] = _age;
    map['isEstimatedAge'] = _isEstimatedAge;
    map['sexualOrientationId'] = _sexualOrientationId;
    map['languageId'] = _languageId;
    map['genderId'] = _genderId;
    map['maritalStatusId'] = _maritalStatusId;
    map['preferredContactTypeId'] = _preferredContactTypeId;
    map['religionId'] = _religionId;
    map['phoneNumber'] = _phoneNumber;
    map['mobilePhoneNumber'] = _mobilePhoneNumber;
    map['emailAddress'] = _emailAddress;
    map['populationGroupId'] = _populationGroupId;
    map['nationalityId'] = _nationalityId;
    map['disabilityTypeId'] = _disabilityTypeId;
    map['citizenshipId'] = _citizenshipId;
    map['dateLastModified'] = _dateLastModified;
    map['modifiedBy'] = _modifiedBy;
    map['createdBy'] = _createdBy;
    if (_disabilityTypeDto != null) {
      map['disabilityTypeDto'] = _disabilityTypeDto?.toJson();
    }
    if (_genderDto != null) {
      map['genderDto'] = _genderDto?.toJson();
    }
    if (_languageDto != null) {
      map['languageDto'] = _languageDto?.toJson();
    }
    if (_nationalityDto != null) {
      map['nationalityDto'] = _nationalityDto?.toJson();
    }
    if (_maritalStatusDto != null) {
      map['maritalStatusDto'] = _maritalStatusDto?.toJson();
    }
    if (_identificationTypeDto != null) {
      map['identificationTypeDto'] = _identificationTypeDto?.toJson();
    }
    if (_personAddressDto != null) {
      map['personAddressDto'] =
          _personAddressDto?.map((v) => v.toJson()).toList();
    }

    if (_previousAddress != null) {
      map['previousAddress'] =
          _previousAddress?.map((v) => v.toJson()).toList();
    }

    return map;
  }
}
