class CoAccusedDetailsQueryDto {
  CoAccusedDetailsQueryDto({
    int? coAccusedId,
    int? personId,
    String? cubacc,
    int? intakeAssessmentId,
    int? modifiedBy,
    String? dateModified,
    int? createdBy,
    String? dateCreated,
    String? coAccusedFullName,
    String? dateOfBirth,
  }) {
    _coAccusedId = coAccusedId;
    _personId = personId;
    _cubacc = cubacc;
    _intakeAssessmentId = intakeAssessmentId;
    _modifiedBy = modifiedBy;
    _dateModified = dateModified;
    _createdBy = createdBy;
    _dateCreated = dateCreated;
    _coAccusedFullName = coAccusedFullName;
    _dateOfBirth = dateOfBirth;
  }

  CoAccusedDetailsQueryDto.fromJson(dynamic json) {
    _coAccusedId = json['coAccusedId'];
    _personId = json['personId'];
    _cubacc = json['cubacc'];
    _intakeAssessmentId = json['intakeAssessmentId'];
    _modifiedBy = json['modifiedBy'];
    _dateModified = json['dateModified'];
    _createdBy = json['createdBy'];
    _dateCreated = json['dateCreated'];
    _coAccusedFullName = json['coAccusedFullName'];
    _dateOfBirth = json['dateOfBirth'];
  }

  int? _coAccusedId;
  int? _personId;
  String? _cubacc;
  int? _intakeAssessmentId;
  int? _modifiedBy;
  String? _dateModified;
  int? _createdBy;
  String? _dateCreated;
  String? _coAccusedFullName;
  String? _dateOfBirth;

  int? get coAccusedId => _coAccusedId;
  int? get personId => _personId;
  String? get cubacc => _cubacc;
  int? get intakeAssessmentId => _intakeAssessmentId;
  int? get modifiedBy => _modifiedBy;
  String? get dateModified => _dateModified;
  int? get createdBy => _createdBy;
  String? get dateCreated => _dateCreated;
  String? get coAccusedFullName => _coAccusedFullName;
  String? get dateOfBirth => _dateOfBirth;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['coAccusedId'] = _coAccusedId;
    map['personId'] = _personId;
    map['cubacc'] = _cubacc;
    map['intakeAssessmentId'] = _intakeAssessmentId;
    map['modifiedBy'] = _modifiedBy;
    map['dateModified'] = _dateModified;
    map['createdBy'] = _createdBy;
    map['dateCreated'] = _dateCreated;
    map['coAccusedFullName'] = _coAccusedFullName;
    map['dateOfBirth'] = _dateOfBirth;
    return map;
  }
}
