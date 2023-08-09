class AssessmentCountQueryDto {
  AssessmentCountQueryDto({
    int? intakeAssessmentId,
    int? childDetails,
    int? assesmentDetails,
    int? medicalInformation,
    int? educationInformation,
    int? careGiverDetail,
    int? familyMember,
    int? familyInformation,
    int? socioEconomicDetails,
    int? offenceDetails,
    int? victimDetails,
    int? victimOrganizationDetails,
    int? developmentAssessment,
    int? recommendation,
    int? generalDetails,
  }) {
    _intakeAssessmentId = intakeAssessmentId;
    _childDetails = childDetails;
    _assesmentDetails = assesmentDetails;
    _medicalInformation = medicalInformation;
    _educationInformation = educationInformation;
    _careGiverDetail = careGiverDetail;
    _familyMember = familyMember;
    _familyInformation = familyInformation;
    _socioEconomicDetails = socioEconomicDetails;
    _offenceDetails = offenceDetails;
    _victimDetails = victimDetails;
    _victimOrganizationDetails = victimOrganizationDetails;
    _developmentAssessment = developmentAssessment;
    _recommendation = recommendation;
    _generalDetails = generalDetails;
  }

  AssessmentCountQueryDto.fromJson(dynamic json) {
    _intakeAssessmentId = json['intakeAssessmentId'];
    _childDetails = json['childDetails'];
    _assesmentDetails = json['assesmentDetails'];
    _medicalInformation = json['medicalInformation'];
    _educationInformation = json['educationInformation'];
    _careGiverDetail = json['careGiverDetail'];
    _familyMember = json['familyMember'];
    _familyInformation = json['familyInformation'];
    _socioEconomicDetails = json['socioEconomicDetails'];
    _offenceDetails = json['offenceDetails'];
    _victimDetails = json['victimDetails'];
    _victimOrganizationDetails = json['victimOrganizationDetails'];
    _developmentAssessment = json['developmentAssessment'];
    _recommendation = json['recommendation'];
    _generalDetails = json['generalDetails'];
  }

  int? _intakeAssessmentId;
  int? _childDetails;
  int? _assesmentDetails;
  int? _medicalInformation;
  int? _educationInformation;
  int? _careGiverDetail;
  int? _familyMember;
  int? _familyInformation;
  int? _socioEconomicDetails;
  int? _offenceDetails;
  int? _victimDetails;
  int? _victimOrganizationDetails;
  int? _developmentAssessment;
  int? _recommendation;
  int? _generalDetails;

  int? get intakeAssessmentId => _intakeAssessmentId;
  int? get childDetails => _childDetails;
  int? get assesmentDetails => _assesmentDetails;
  int? get medicalInformation => _medicalInformation;
  int? get educationInformation => _educationInformation;
  int? get careGiverDetail => _careGiverDetail;
  int? get familyMember => _familyMember;
  int? get familyInformation => _familyInformation;
  int? get socioEconomicDetails => _socioEconomicDetails;
  int? get offenceDetails => _offenceDetails;
  int? get victimDetails => _victimDetails;
  int? get victimOrganizationDetails => _victimOrganizationDetails;
  int? get developmentAssessment => _developmentAssessment;
  int? get recommendation => _recommendation;
  int? get generalDetails => _generalDetails;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['intakeAssessmentId'] = _intakeAssessmentId;
    map['childDetails'] = _childDetails;
    map['assesmentDetails'] = _assesmentDetails;
    map['medicalInformation'] = _medicalInformation;
    map['educationInformation'] = _educationInformation;
    map['careGiverDetail'] = _careGiverDetail;
    map['familyMember'] = _familyMember;
    map['familyInformation'] = _familyInformation;
    map['socioEconomicDetails'] = _socioEconomicDetails;
    map['offenceDetails'] = _offenceDetails;
    map['victimDetails'] = _victimDetails;
    map['victimOrganizationDetails'] = _victimOrganizationDetails;
    map['developmentAssessment'] = _developmentAssessment;
    map['recommendation'] = _recommendation;
    map['generalDetails'] = _generalDetails;
    return map;
  }
}
