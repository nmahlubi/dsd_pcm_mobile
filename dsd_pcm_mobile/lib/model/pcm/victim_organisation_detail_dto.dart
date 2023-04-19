class VictimOrganisationDetailDto {
  VictimOrganisationDetailDto({
    int? victimOrganisationId,
    int? intakeAssessmentId,
    String? organisationName,
    String? contactPersonFirstName,
    String? contactPersonLastName,
    String? telephone,
    String? cellNo,
    String? interventionserviceReferrals,
    String? otherContacts,
    String? contactPersonOccupation,
    String? addressLine1,
    String? addressLine2,
    int? townId,
    String? postalCode,
    int? createdBy,
    String? dateCreated,
    int? modifiedBy,
    String? dateModified,
  }) {
    _victimOrganisationId = victimOrganisationId;
    _intakeAssessmentId = intakeAssessmentId;
    _organisationName = organisationName;
    _contactPersonFirstName = contactPersonFirstName;
    _contactPersonLastName = contactPersonLastName;
    _telephone = telephone;
    _cellNo = cellNo;
    _interventionserviceReferrals = interventionserviceReferrals;
    _otherContacts = otherContacts;
    _contactPersonOccupation = contactPersonOccupation;
    _addressLine1 = addressLine1;
    _addressLine2 = addressLine2;
    _townId = townId;
    _postalCode = postalCode;
    _createdBy = createdBy;
    _dateCreated = dateCreated;
    _modifiedBy = modifiedBy;
    _dateModified = dateModified;
  }

  VictimOrganisationDetailDto.fromJson(dynamic json) {
    _victimOrganisationId = json['victimOrganisationId'];
    _intakeAssessmentId = json['intakeAssessmentId'];
    _organisationName = json['organisationName'];
    _contactPersonFirstName = json['contactPersonFirstName'];
    _contactPersonLastName = json['contactPersonLastName'];
    _telephone = json['telephone'];
    _cellNo = json['cellNo'];
    _interventionserviceReferrals = json['interventionserviceReferrals'];
    _otherContacts = json['otherContacts'];
    _contactPersonOccupation = json['contactPersonOccupation'];
    _addressLine1 = json['addressLine1'];
    _addressLine2 = json['addressLine2'];
    _townId = json['townId'];
    _postalCode = json['postalCode'];
    _createdBy = json['createdBy'];
    _dateCreated = json['dateCreated'];
    _modifiedBy = json['modifiedBy'];
    _dateModified = json['dateModified'];
  }

  int? _victimOrganisationId;
  int? _intakeAssessmentId;
  String? _organisationName;
  String? _contactPersonFirstName;
  String? _contactPersonLastName;
  String? _telephone;
  String? _cellNo;
  String? _interventionserviceReferrals;
  String? _otherContacts;
  String? _contactPersonOccupation;
  String? _addressLine1;
  String? _addressLine2;
  int? _townId;
  String? _postalCode;
  int? _createdBy;
  String? _dateCreated;
  int? _modifiedBy;
  String? _dateModified;

  int? get victimOrganisationId => _victimOrganisationId;
  int? get intakeAssessmentId => _intakeAssessmentId;
  String? get organisationName => _organisationName;
  String? get contactPersonFirstName => _contactPersonFirstName;
  String? get contactPersonLastName => _contactPersonLastName;
  String? get telephone => _telephone;
  String? get cellNo => _cellNo;
  String? get interventionserviceReferrals => _interventionserviceReferrals;
  String? get otherContacts => _otherContacts;
  String? get contactPersonOccupation => _contactPersonOccupation;
  String? get addressLine1 => _addressLine1;
  String? get addressLine2 => _addressLine2;
  int? get townId => _townId;
  String? get postalCode => _postalCode;
  int? get createdBy => _createdBy;
  String? get dateCreated => _dateCreated;
  int? get modifiedBy => _modifiedBy;
  String? get dateModified => _dateModified;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['victimOrganisationId'] = _victimOrganisationId;
    map['intakeAssessmentId'] = _intakeAssessmentId;
    map['organisationName'] = _organisationName;
    map['contactPersonFirstName'] = _contactPersonFirstName;
    map['contactPersonLastName'] = _contactPersonLastName;
    map['telephone'] = _telephone;
    map['cellNo'] = _cellNo;
    map['interventionserviceReferrals'] = _interventionserviceReferrals;
    map['otherContacts'] = _otherContacts;
    map['contactPersonOccupation'] = _contactPersonOccupation;
    map['addressLine1'] = _addressLine1;
    map['addressLine2'] = _addressLine2;
    map['townId'] = _townId;
    map['postalCode'] = _postalCode;
    map['createdBy'] = _createdBy;
    map['dateCreated'] = _dateCreated;
    map['modifiedBy'] = _modifiedBy;
    map['dateModified'] = _dateModified;
    return map;
  }
}
