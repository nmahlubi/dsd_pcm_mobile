import '../intake/person_dto.dart';

class VictimDetailDto {
  VictimDetailDto({
    int? victimId,
    int? intakeAssessmentId,
    String? isVictimIndividual,
    int? personId,
    String? victimOccupation,
    String? victimCareGiverNames,
    String? addressLine1,
    String? addressLine2,
    int? townId,
    String? postalCode,
    int? createdBy,
    String? dateCreated,
    int? modifiedBy,
    String? dateModified,
    PersonDto? personDto,
  }) {
    _victimId = victimId;
    _intakeAssessmentId = intakeAssessmentId;
    _isVictimIndividual = isVictimIndividual;
    _personId = personId;
    _victimOccupation = victimOccupation;
    _victimCareGiverNames = victimCareGiverNames;
    _addressLine1 = addressLine1;
    _addressLine2 = addressLine2;
    _townId = townId;
    _postalCode = postalCode;
    _createdBy = createdBy;
    _dateCreated = dateCreated;
    _modifiedBy = modifiedBy;
    _dateModified = dateModified;
    _personDto = personDto;
  }

  VictimDetailDto.fromJson(dynamic json) {
    _victimId = json['victimId'];
    _intakeAssessmentId = json['intakeAssessmentId'];
    _isVictimIndividual = json['isVictimIndividual'];
    _personId = json['personId'];
    _victimOccupation = json['victimOccupation'];
    _victimCareGiverNames = json['victimCareGiverNames'];
    _addressLine1 = json['addressLine1'];
    _addressLine2 = json['addressLine2'];
    _townId = json['townId'];
    _postalCode = json['postalCode'];
    _createdBy = json['createdBy'];
    _dateCreated = json['dateCreated'];
    _modifiedBy = json['modifiedBy'];
    _dateModified = json['dateModified'];
    _personDto = json['personDto'] != null
        ? PersonDto.fromJson(json['personDto'])
        : null;
  }

  int? _victimId;
  int? _intakeAssessmentId;
  String? _isVictimIndividual;
  int? _personId;
  String? _victimOccupation;
  String? _victimCareGiverNames;
  String? _addressLine1;
  String? _addressLine2;
  int? _townId;
  String? _postalCode;
  int? _createdBy;
  String? _dateCreated;
  int? _modifiedBy;
  String? _dateModified;
  PersonDto? _personDto;

  int? get victimId => _victimId;
  int? get intakeAssessmentId => _intakeAssessmentId;
  String? get isVictimIndividual => _isVictimIndividual;
  int? get personId => _personId;
  String? get victimOccupation => _victimOccupation;
  String? get victimCareGiverNames => _victimCareGiverNames;
  String? get addressLine1 => _addressLine1;
  String? get addressLine2 => _addressLine2;
  int? get townId => _townId;
  String? get postalCode => _postalCode;
  int? get createdBy => _createdBy;
  String? get dateCreated => _dateCreated;
  int? get modifiedBy => _modifiedBy;
  String? get dateModified => _dateModified;
  PersonDto? get personDto => _personDto;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['victimId'] = _victimId;
    map['intakeAssessmentId'] = _intakeAssessmentId;
    map['isVictimIndividual'] = _isVictimIndividual;
    map['personId'] = _personId;
    map['victimOccupation'] = _victimOccupation;
    map['victimCareGiverNames'] = _victimCareGiverNames;
    map['addressLine1'] = _addressLine1;
    map['addressLine2'] = _addressLine2;
    map['townId'] = _townId;
    map['postalCode'] = _postalCode;
    map['createdBy'] = _createdBy;
    map['dateCreated'] = _dateCreated;
    map['modifiedBy'] = _modifiedBy;
    map['dateModified'] = _dateModified;
    if (_personDto != null) {
      map['personDto'] = _personDto?.toJson();
    }
    return map;
  }
}
