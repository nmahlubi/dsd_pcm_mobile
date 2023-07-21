class DiversionDto {
  DiversionDto({
    int? diversionId,
    int? intakeAssessmentId,
    int? sourceReferralId,
    int? provinceId,
    int? serviceProviderCategory,
    int? servicesProviderId,
    int? programmeCategoryId,
    int? programmeid,
    String? programmeStartDate,
    String? programmeEndDate,
    int? courtTypeId,
    int? pCMCourtOutcomeId,
    int? noModules,
    int? programmeLevelId,
    int? programmeAgeGroupId,
    int? pCMPreliminaryId,
    int? formalCourtcomeId,
    int? childrensCourtOutcomeId,
    int? createdBy,
    String? dateCreated,
    int? modifiedBy,
    String? dateModified,
  }) {
    _diversionId = diversionId;
    _intakeAssessmentId = intakeAssessmentId;
    _sourceReferralId = sourceReferralId;
    _provinceId = provinceId;
    _serviceProviderCategory = serviceProviderCategory;
    _servicesProviderId = servicesProviderId;
    _programmeCategoryId = programmeCategoryId;
    _programmeid = programmeid;
    _programmeStartDate = programmeStartDate;
    _programmeEndDate = programmeEndDate;
    _courtTypeId = courtTypeId;
    _pCMCourtOutcomeId = pCMCourtOutcomeId;
    _noModules = noModules;
    _programmeLevelId = programmeLevelId;
    _programmeAgeGroupId = programmeAgeGroupId;
    _pCMPreliminaryId = pCMPreliminaryId;
    _formalCourtcomeId = formalCourtcomeId;
    _childrensCourtOutcomeId = childrensCourtOutcomeId;
    _createdBy = createdBy;
    _dateCreated = dateCreated;
    _modifiedBy = modifiedBy;
    _dateModified = dateModified;
  }

  DiversionDto.fromJson(dynamic json) {
    _diversionId = json['diversionId'];
    _intakeAssessmentId = json['intakeAssessmentId'];
    _sourceReferralId = json['sourceReferralId'];
    _provinceId = json['provinceId'];
    _serviceProviderCategory = json['serviceProviderCategory'];
    _servicesProviderId = json['servicesProviderId'];
    _programmeCategoryId = json['programmeCategoryId'];
    _programmeid = json['programmeid'];
    _programmeStartDate = json['programmeStartDate'];
    _programmeEndDate = json['programmeEndDate'];
    _courtTypeId = json['courtTypeId'];
    _pCMCourtOutcomeId = json['pcmCourtOutcomeId'];
    _noModules = json['noModules'];
    _programmeLevelId = json['programmeLevelId'];
    _programmeAgeGroupId = json['programmeAgeGroupId'];
    _pCMPreliminaryId = json['pcmPreliminaryId'];
    _formalCourtcomeId = json['formalCourtcomeId'];
    _childrensCourtOutcomeId = json['childrensCourtOutcomeId'];
    _createdBy = json['createdBy'];
    _dateCreated = json['dateCreated'];
    _modifiedBy = json['modifiedBy'];
    _dateModified = json['dateModified'];
  }
  int? _diversionId;
  int? _intakeAssessmentId;
  int? _sourceReferralId;
  int? _provinceId;
  int? _serviceProviderCategory;
  int? _servicesProviderId;
  int? _programmeCategoryId;
  int? _programmeid;
  String? _programmeStartDate;
  String? _programmeEndDate;
  int? _courtTypeId;
  int? _pCMCourtOutcomeId;
  int? _noModules;
  int? _programmeLevelId;
  int? _programmeAgeGroupId;
  int? _pCMPreliminaryId;
  int? _formalCourtcomeId;
  int? _childrensCourtOutcomeId;
  int? _createdBy;
  String? _dateCreated;
  int? _modifiedBy;
  String? _dateModified;

  int? get diversionId => _diversionId;
  int? get intakeAssessmentId => _intakeAssessmentId;
  int? get sourceReferralId => _sourceReferralId;
  int? get provinceId => _provinceId;
  int? get serviceProviderCategory => _serviceProviderCategory;
  int? get servicesProviderId => _servicesProviderId;
  int? get programmeCategoryId => _programmeCategoryId;
  int? get programmeid => _programmeid;
  String? get programmeStartDate => _programmeStartDate;
  String? get programmeEndDate => _programmeEndDate;
  int? get courtTypeId => _courtTypeId;
  int? get pCMCourtOutcomeId => _pCMCourtOutcomeId;
  int? get noModules => _noModules;
  int? get programmeLevelId => _programmeLevelId;
  int? get programmeAgeGroupId => _programmeAgeGroupId;
  int? get pCMPreliminaryId => _pCMPreliminaryId;
  int? get formalCourtcomeId => _formalCourtcomeId;
  int? get childrensCourtOutcomeId => _childrensCourtOutcomeId;
  int? get createdBy => _createdBy;
  String? get dateCreated => _dateCreated;
  int? get modifiedBy => _modifiedBy;
  String? get dateModified => _dateModified;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['diversionId'] = _diversionId;
    map['intakeAssessmentId'] = _intakeAssessmentId;
    map['sourceReferralId'] = _sourceReferralId;
    map['provinceId'] = _provinceId;
    map['serviceProviderCategory'] = _serviceProviderCategory;
    map['servicesProviderId'] = _servicesProviderId;
    map['programmeCategoryId'] = _programmeCategoryId;
    map['programmeid'] = _programmeid;
    map['programmeStartDate'] = _programmeStartDate;
    map['programmeEndDate'] = _programmeEndDate;
    map['courtTypeId'] = _courtTypeId;
    map['pcmCourtOutcomeId'] = _pCMCourtOutcomeId;
    map['noModules'] = _noModules;
    map['programmeLevelId'] = _programmeLevelId;
    map['programmeAgeGroupId'] = _programmeAgeGroupId;
    map['pcmPreliminaryId'] = _pCMPreliminaryId;
    map['formalCourtcomeId'] = _formalCourtcomeId;
    map['childrensCourtOutcomeId'] = _childrensCourtOutcomeId;
    map['createdBy'] = _createdBy;
    map['dateCreated'] = _dateCreated;
    map['modifiedBy'] = _modifiedBy;
    map['dateModified'] = _dateModified;

    return map;
  }
}
