class AssessmentCountQueryDto {
  AssessmentCountQueryDto({
    int? caseDetails,
    int? familyMember,
    int? familyInformation,
    int? recommendation,
    int? coAccusedDetails,
    int? educationInformation,
    int? socioEconomicDetails,
    int? offenceDetails,
    int? victimDetails,
    int? victimOrganizationDetails,
    int? developmentAssessment,
    int? generalDetails,
    bool? canCompleteAssessment,
  }) {
    _caseDetails = caseDetails;
    _familyMember = familyMember;
    _familyInformation = familyInformation;
    _recommendation = recommendation;
    _coAccusedDetails = coAccusedDetails;
    _educationInformation = educationInformation;
    _socioEconomicDetails = socioEconomicDetails;
    _offenceDetails = offenceDetails;
    _victimDetails = victimDetails;
    _victimOrganizationDetails = victimOrganizationDetails;
    _developmentAssessment = developmentAssessment;
    _generalDetails = generalDetails;
    _canCompleteAssessment = canCompleteAssessment;
  }

  AssessmentCountQueryDto.fromJson(dynamic json) {
    _caseDetails = json['caseDetails'];
    _familyMember = json['  familyMember'];
    _familyInformation = json[' familyInformation'];
    _recommendation = json[' recommendation'];
    _coAccusedDetails = json['coAccusedDetails'];
    _educationInformation = json[' educationInformation'];
    _socioEconomicDetails = json['socioEconomicDetails'];
    _offenceDetails = json['  offenceDetails'];
    _victimDetails = json['victimDetails'];
    _victimOrganizationDetails = json['victimOrganizationDetails'];
    _developmentAssessment = json['developmentAssessment'];
    _generalDetails = json['generalDetails'];
    _canCompleteAssessment = json['canCompleteAssessment'];
  }

  int? _caseDetails;
  int? _familyMember;
  int? _familyInformation;
  int? _recommendation;
  int? _coAccusedDetails;
  int? _educationInformation;
  int? _socioEconomicDetails;
  int? _offenceDetails;
  int? _victimDetails;
  int? _victimOrganizationDetails;
  int? _developmentAssessment;
  int? _generalDetails;
  bool? _canCompleteAssessment;

  int? get caseDetails => _caseDetails;
  int? get familyMember => _familyMember;
  int? get familyInformation => _familyInformation;
  int? get recommendation => _recommendation;
  int? get coAccusedDetails => _coAccusedDetails;
  int? get educationInformation => _educationInformation;
  int? get socioEconomicDetails => _socioEconomicDetails;
  int? get offenceDetails => _offenceDetails;
  int? get victimDetails => _victimDetails;
  int? get victimOrganizationDetails => _victimOrganizationDetails;
  int? get developmentAssessment => _developmentAssessment;
  int? get generalDetails => _generalDetails;
  bool? get canCompleteAssessment => _canCompleteAssessment;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['caseDetails'] = _caseDetails;
    map['familyMember'] = _familyMember;
    map['familyInformation'] = _familyInformation;
    map['recommendation'] = _recommendation;
    map['coAccusedDetails'] = _coAccusedDetails;
    map['educationInformation'] = _educationInformation;
    map['socioEconomicDetails'] = _socioEconomicDetails;
    map['offenceDetails'] = _offenceDetails;
    map['victimDetails'] = _victimDetails;
    map['victimOrganizationDetails'] = _victimOrganizationDetails;
    map['developmentAssessment'] = _developmentAssessment;
    map['generalDetails'] = _generalDetails;
    map['canCompleteAssessment'] = _canCompleteAssessment;
    return map;
  }
}
