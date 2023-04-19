class GeneralDetailDto {
  GeneralDetailDto({
    int? generalDetailsId,
    int? intakeAssessmentId,
    String? consultedSources,
    String? traceEfforts,
    String? assessmentDate,
    String? assessmentTime,
    String? additionalInfo,
    int? isVerifiedBySupervisor,
    String? commentsBySupervisor,
    int? createdBy,
    int? modifiedBy,
    String? dateCreated,
    String? dateModified,
  }) {
    _generalDetailsId = generalDetailsId;
    _intakeAssessmentId = intakeAssessmentId;
    _consultedSources = consultedSources;
    _traceEfforts = traceEfforts;
    _assessmentDate = assessmentDate;
    _assessmentTime = assessmentTime;
    _additionalInfo = additionalInfo;
    _isVerifiedBySupervisor = isVerifiedBySupervisor;
    _commentsBySupervisor = commentsBySupervisor;
    _createdBy = createdBy;
    _modifiedBy = modifiedBy;
    _dateCreated = dateCreated;
    _dateModified = dateModified;
  }

  GeneralDetailDto.fromJson(dynamic json) {
    _generalDetailsId = json['generalDetailsId'];
    _intakeAssessmentId = json['intakeAssessmentId'];
    _consultedSources = json['consultedSources'];
    _traceEfforts = json['traceEfforts'];
    _assessmentDate = json['assessmentDate'];
    _assessmentTime = json['assessmentTime'];
    _additionalInfo = json['additionalInfo'];
    _isVerifiedBySupervisor = json['isVerifiedBySupervisor'];
    _commentsBySupervisor = json['commentsBySupervisor'];
    _createdBy = json['createdBy'];
    _modifiedBy = json['modifiedBy'];
    _dateCreated = json['dateCreated'];
    _dateModified = json['dateModified'];
  }

  int? _generalDetailsId;
  int? _intakeAssessmentId;
  String? _consultedSources;
  String? _traceEfforts;
  String? _assessmentDate;
  String? _assessmentTime;
  String? _additionalInfo;
  int? _isVerifiedBySupervisor;
  String? _commentsBySupervisor;
  int? _createdBy;
  int? _modifiedBy;
  String? _dateCreated;
  String? _dateModified;

  int? get generalDetailsId => _generalDetailsId;
  int? get intakeAssessmentId => _intakeAssessmentId;
  String? get consultedSources => _consultedSources;
  String? get traceEfforts => _traceEfforts;
  String? get assessmentDate => _assessmentDate;
  String? get assessmentTime => _assessmentTime;
  String? get additionalInfo => _additionalInfo;
  int? get isVerifiedBySupervisor => _isVerifiedBySupervisor;
  String? get commentsBySupervisor => _commentsBySupervisor;
  int? get createdBy => _createdBy;
  int? get modifiedBy => _modifiedBy;
  String? get dateCreated => _dateCreated;
  String? get dateModified => _dateModified;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['generalDetailsId'] = _generalDetailsId;
    map['intakeAssessmentId'] = _intakeAssessmentId;
    map['consultedSources'] = _consultedSources;
    map['traceEfforts'] = _traceEfforts;
    map['assessmentDate'] = _assessmentDate;
    map['assessmentTime'] = _assessmentTime;
    map['additionalInfo'] = _additionalInfo;
    map['isVerifiedBySupervisor'] = _isVerifiedBySupervisor;
    map['commentsBySupervisor'] = _commentsBySupervisor;
    map['createdBy'] = _createdBy;
    map['modifiedBy'] = _modifiedBy;
    map['dateCreated'] = _dateCreated;
    map['dateModified'] = _dateModified;
    return map;
  }
}
