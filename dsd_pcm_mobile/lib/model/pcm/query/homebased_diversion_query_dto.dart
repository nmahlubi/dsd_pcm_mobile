class HomebasedDiversionQueryDto {
  HomebasedDiversionQueryDto({
    int? preliminaryId,
    int? homeBasedSupervisionId,
    int? diversionId,
    int? probationOfficerId,
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
    _preliminaryId = preliminaryId;
    _probationOfficerId = probationOfficerId;
    _homeBasedSupervisionId = homeBasedSupervisionId;
    _diversionId = diversionId;
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

  HomebasedDiversionQueryDto.fromJson(dynamic json) {
    _preliminaryId = json['preliminaryId'];
    _probationOfficerId = json['probationOfficerId'];
    _homeBasedSupervisionId = json['homeBasedSupervisionId'];
     _diversionId = json['diversionId'];
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

  int? _preliminaryId;
  int? _probationOfficerId;
  int? _homeBasedSupervisionId;
  int? _diversionId;
  int? _assessmentRegisterId;
  int? _caseId;
  int? _worklistId;
  int? _intakeAssessmentId;
  int? _personId;
  String? _childName;
  String? _dateAccepted;
  String? _childNameAbbr;
  int? _clientId;

  int? get preliminaryId => _preliminaryId;
  int? get probationOfficerId => _probationOfficerId;
  int? get homeBasedSupervisionId => _homeBasedSupervisionId;
   int? get diversionId => _diversionId;
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
    map['preliminaryId'] = _preliminaryId;
    map['probationOfficerId'] = _probationOfficerId;
    map['homeBasedSupervisionId'] = _homeBasedSupervisionId;
    map['diversionId'] = _diversionId;
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

