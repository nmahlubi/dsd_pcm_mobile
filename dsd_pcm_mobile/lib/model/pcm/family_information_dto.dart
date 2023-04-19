class FamilyInformationDto {
  FamilyInformationDto({
    int? familyInformationId,
    int? intakeAssessmentId,
    String? familyBackground,
    int? createdBy,
    String? dateCreated,
    int? modifiedBy,
    String? dateModified,
  }) {
    _familyInformationId = familyInformationId;
    _intakeAssessmentId = intakeAssessmentId;
    _familyBackground = familyBackground;
    _createdBy = createdBy;
    _dateCreated = dateCreated;
    _modifiedBy = modifiedBy;
    _dateModified = dateModified;
  }
  FamilyInformationDto.fromJson(dynamic json) {
    _familyInformationId = json['familyInformationId'];
    _intakeAssessmentId = json['intakeAssessmentId'];
    _familyBackground = json['familyBackground'];
    _createdBy = json['createdBy'];
    _dateCreated = json['dateCreated'];
    _modifiedBy = json['modifiedBy'];
    _dateModified = json['dateModified'];
  }
  int? _familyInformationId;
  int? _intakeAssessmentId;
  String? _familyBackground;
  int? _createdBy;
  String? _dateCreated;
  int? _modifiedBy;
  String? _dateModified;

  int? get familyInformationId => _familyInformationId;
  int? get intakeAssessmentId => _intakeAssessmentId;
  String? get familyBackground => _familyBackground;
  int? get createdBy => _createdBy;
  String? get dateCreated => _dateCreated;
  int? get modifiedBy => _modifiedBy;
  String? get dateModified => _dateModified;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['familyInformationId'] = _familyInformationId;
    map['intakeAssessmentId'] = _intakeAssessmentId;
    map['familyBackground'] = _familyBackground;
    map['createdBy'] = _createdBy;
    map['dateCreated'] = _dateCreated;
    map['modifiedBy'] = _modifiedBy;
    map['dateModified'] = _dateModified;
    return map;
  }
}
