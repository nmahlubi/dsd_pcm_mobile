class AcceptedWorklistDto {
  AcceptedWorklistDto({
    String? assessmentStatus,
    int? assessmentRegisterId,
    int? caseId,
    int? worklistId,
    int? intakeAssessmentId,
    int? personId,
    String? childName,
    String? dateAccepted,
    String? childNameAbbr,
    int? clientId,
  }) {
    _assessmentStatus = assessmentStatus;
    _assessmentRegisterId = assessmentRegisterId;
    _caseId = caseId;
    _worklistId = worklistId;
    _intakeAssessmentId = intakeAssessmentId;
    _personId = personId;
    _childName = childName;
    _dateAccepted = dateAccepted;
    _childNameAbbr = childNameAbbr;
    _clientId = clientId;
  }

  AcceptedWorklistDto.fromJson(dynamic json) {
    _assessmentStatus = json['assessmentStatus'];
    _assessmentRegisterId = json['assessmentRegisterId'];
    _caseId = json['caseId'];
    _worklistId = json['worklistId'];
    _intakeAssessmentId = json['intakeAssessmentId'];
    _personId = json['personId'];
    _childName = json['childName'];
    _dateAccepted = json['dateAccepted'];
    _childNameAbbr = json['childNameAbbr'];
    _clientId = json['clientId'];
  }

  String? _assessmentStatus;
  int? _assessmentRegisterId;
  int? _caseId;
  int? _worklistId;
  int? _intakeAssessmentId;
  int? _personId;
  String? _childName;
  String? _dateAccepted;
  String? _childNameAbbr;
  int? _clientId;

  String? get assessmentStatus => _assessmentStatus;
  int? get assessmentRegisterId => _assessmentRegisterId;
  int? get caseId => _caseId;
  int? get worklistId => _worklistId;
  int? get intakeAssessmentId => _intakeAssessmentId;
  int? get personId => _personId;
  String? get childName => _childName;
  String? get dateAccepted => _dateAccepted;
  String? get childNameAbbr => _childNameAbbr;
  int? get clientId => _clientId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['assessmentStatus'] = _assessmentStatus;
    map['assessmentRegisterId'] = _assessmentRegisterId;
    map['caseId'] = _caseId;
    map['worklistId'] = _worklistId;
    map['intakeAssessmentId'] = _intakeAssessmentId;
    map['childName'] = _childName;
    map['personId'] = _personId;
    map['dateAccepted'] = _dateAccepted;
    map['childNameAbbr'] = _childNameAbbr;
    map['clientId'] = _clientId;
    return map;
  }
}
