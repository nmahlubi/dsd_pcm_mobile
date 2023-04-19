class SocioEconomicDto {
  SocioEconomicDto({
    int? socioEconomyid,
    int? intakeAssessmentId,
    String? familyBackgroundComment,
    String? financeWorkRecord,
    String? housing,
    String? socialCircumsances,
    String? previousIntervention,
    String? interPersonalRelationship,
    String? peerPresure,
    String? substanceAbuse,
    String? religiousInvolve,
    String? childBehavior,
    String? other,
    int? createdBy,
    String? dateCreated,
    int? modifiedBy,
    String? dateModified,
  }) {
    _socioEconomyid = socioEconomyid;
    _intakeAssessmentId = intakeAssessmentId;
    _familyBackgroundComment = familyBackgroundComment;
    _financeWorkRecord = financeWorkRecord;
    _housing = housing;
    _socialCircumsances = socialCircumsances;
    _previousIntervention = previousIntervention;
    _interPersonalRelationship = interPersonalRelationship;
    _peerPresure = peerPresure;
    _substanceAbuse = substanceAbuse;
    _religiousInvolve = religiousInvolve;
    _childBehavior = childBehavior;
    _other = other;
    _createdBy = createdBy;
    _dateCreated = dateCreated;
    _modifiedBy = modifiedBy;
    _dateModified = dateModified;
  }

  SocioEconomicDto.fromJson(dynamic json) {
    _socioEconomyid = json['socioEconomyid'];
    _intakeAssessmentId = json['intakeAssessmentId'];
    _familyBackgroundComment = json['familyBackgroundComment'];
    _financeWorkRecord = json['financeWorkRecord'];
    _housing = json['housing'];
    _socialCircumsances = json['socialCircumsances'];
    _previousIntervention = json['previousIntervention'];
    _interPersonalRelationship = json['interPersonalRelationship'];
    _peerPresure = json['peerPresure'];
    _substanceAbuse = json['substanceAbuse'];
    _religiousInvolve = json['religiousInvolve'];
    _childBehavior = json['childBehavior'];
    _other = json['other'];
    _createdBy = json['createdBy'];
    _dateCreated = json['dateCreated'];
    _modifiedBy = json['modifiedBy'];
    _dateModified = json['dateModified'];
  }

  int? _socioEconomyid;
  int? _intakeAssessmentId;
  String? _familyBackgroundComment;
  String? _financeWorkRecord;
  String? _housing;
  String? _socialCircumsances;
  String? _previousIntervention;
  String? _interPersonalRelationship;
  String? _peerPresure;
  String? _substanceAbuse;
  String? _religiousInvolve;
  String? _childBehavior;
  String? _other;
  int? _createdBy;
  String? _dateCreated;
  int? _modifiedBy;
  String? _dateModified;

  int? get socioEconomyid => _socioEconomyid;
  int? get intakeAssessmentId => _intakeAssessmentId;
  String? get familyBackgroundComment => _familyBackgroundComment;
  String? get financeWorkRecord => _financeWorkRecord;
  String? get housing => _housing;
  String? get socialCircumsances => _socialCircumsances;
  String? get previousIntervention => _previousIntervention;
  String? get interPersonalRelationship => _interPersonalRelationship;
  String? get peerPresure => _peerPresure;
  String? get substanceAbuse => _substanceAbuse;
  String? get religiousInvolve => _religiousInvolve;
  String? get childBehavior => _childBehavior;
  String? get other => _other;
  int? get createdBy => _createdBy;
  String? get dateCreated => _dateCreated;
  int? get modifiedBy => _modifiedBy;
  String? get dateModified => _dateModified;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['socioEconomyid'] = _socioEconomyid;
    map['intakeAssessmentId'] = _intakeAssessmentId;
    map['familyBackgroundComment'] = _familyBackgroundComment;
    map['financeWorkRecord'] = _financeWorkRecord;
    map['housing'] = _housing;
    map['socialCircumsances'] = _socialCircumsances;
    map['previousIntervention'] = _previousIntervention;
    map['interPersonalRelationship'] = _interPersonalRelationship;
    map['peerPresure'] = _peerPresure;
    map['substanceAbuse'] = _substanceAbuse;
    map['religiousInvolve'] = _religiousInvolve;
    map['childBehavior'] = _childBehavior;
    map['other'] = _other;
    map['createdBy'] = _createdBy;
    map['dateCreated'] = _dateCreated;
    map['modifiedBy'] = _modifiedBy;
    map['dateModified'] = _dateModified;
    return map;
  }
}
