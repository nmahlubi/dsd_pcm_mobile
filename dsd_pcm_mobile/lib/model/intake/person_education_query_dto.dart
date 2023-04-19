class PersonEducationQueryDto {
  PersonEducationQueryDto({
    int? personEducationId,
    int? personId,
    int? gradeCompletedId,
    String? gradeName,
    int? schoolId,
    String? schoolName,
    String? yearCompleted,
    String? dateLastAttended,
    String? additionalInformation,
    String? dateCreated,
    String? createdBy,
    String? dateLastModified,
    String? modifiedBy,
  }) {
    _personEducationId = personEducationId;
    _personId = personId;
    _gradeCompletedId = gradeCompletedId;
    _gradeName = gradeName;
    _schoolId = schoolId;
    _schoolName = schoolName;
    _yearCompleted = yearCompleted;
    _dateLastAttended = dateLastAttended;
    _additionalInformation = additionalInformation;
    _dateCreated = dateCreated;
    _createdBy = createdBy;
    _dateLastModified = dateLastModified;
    _modifiedBy = modifiedBy;
  }

  PersonEducationQueryDto.fromJson(dynamic json) {
    _personEducationId = json['personEducationId'];
    _personId = json['personId'];
    _gradeCompletedId = json['gradeCompletedId'];
    _gradeName = json['gradeName'];
    _schoolId = json['schoolId'];
    _schoolName = json['schoolName'];
    _yearCompleted = json['yearCompleted'];
    _dateLastAttended = json['dateLastAttended'];
    _additionalInformation = json['additionalInformation'];
    _dateCreated = json['dateCreated'];
    _createdBy = json['createdBy'];
    _dateLastModified = json['dateLastModified'];
    _modifiedBy = json['modifiedBy'];
  }
  int? _personEducationId;
  int? _personId;
  int? _gradeCompletedId;
  String? _gradeName;
  int? _schoolId;
  String? _schoolName;
  String? _yearCompleted;
  String? _dateLastAttended;
  String? _additionalInformation;
  String? _dateCreated;
  String? _createdBy;
  String? _dateLastModified;
  String? _modifiedBy;

  int? get personEducationId => _personEducationId;
  int? get personId => _personId;
  int? get gradeCompletedId => _gradeCompletedId;
  String? get gradeName => _gradeName;
  int? get schoolId => _schoolId;
  String? get schoolName => _schoolName;
  String? get yearCompleted => _yearCompleted;
  String? get dateLastAttended => _dateLastAttended;
  String? get additionalInformation => _additionalInformation;
  String? get dateCreated => _dateCreated;
  String? get createdBy => _createdBy;
  String? get dateLastModified => _dateLastModified;
  String? get modifiedBy => _modifiedBy;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    map['personEducationId'] = _personEducationId;
    map['personId'] = _personId;
    map['gradeCompletedId'] = _gradeCompletedId;
    map['gradeName'] = _gradeName;
    map['schoolId'] = _schoolId;
    map['schoolName'] = _schoolName;
    map['yearCompleted'] = _yearCompleted;
    map['dateLastAttended'] = _dateLastAttended;
    map['additionalInformation'] = _additionalInformation;
    map['dateCreated'] = _dateCreated;
    map['createdBy'] = _createdBy;
    map['dateLastModified'] = _dateLastModified;
    map['modifiedBy'] = _modifiedBy;
    return map;
  }
}
