import '../intake/court_type_dto.dart';

class HomeBasedSupervionDto {
  HomeBasedSupervionDto({
    int? homeBasedSupervisionId,
    int? intakeAssessmentId,
    int? outcomeId,
    int? formalCourtOutcomeId,
    int? pCMPreliminaryId,
    int? pCMCourtOutcomeId,
    int? courtTypeId,
    int? conditionsId,
    String? visitationPeriod,
    String? visitationPeriodTo,
    int? numberOfVisit,
    String? placementDate,
    int? supervisorId,
    String? placementConfirmed,
    String? dateCreated,
    int? createdBy,
    int? modifiedBy,
    String? dateModified,
    CourtTypeDto? courtTypeDto,
  }) {
    _homeBasedSupervisionId = homeBasedSupervisionId;
    _intakeAssessmentId = intakeAssessmentId;
    _outcomeId = outcomeId;
    _formalCourtOutcomeId = formalCourtOutcomeId;
    _pCMPreliminaryId = pCMPreliminaryId;
    _courtTypeId = courtTypeId;
    _conditionsId = conditionsId;
    _visitationPeriod = visitationPeriod;
    _visitationPeriodTo = visitationPeriodTo;
    _placementDate = placementDate;
    _numberOfVisits = numberOfVisit;
    _supervisorId = supervisorId;
    _placementConfirmed = placementConfirmed;
    _createdBy = createdBy;
    _dateCreated = dateCreated;
    _modifiedBy = modifiedBy;
    _dateModified = dateModified;
    _courtTypeDto = courtTypeDto;
  }
  HomeBasedSupervionDto.fromJson(dynamic json) {
    _homeBasedSupervisionId = json['homeBasedSupervisionId'];
    _intakeAssessmentId = json['intakeAssessmentId'];
    _outcomeId = json['outcomeId'];
    _formalCourtOutcomeId = json['formalCourtOutcomeId'];
    _pCMPreliminaryId = json['pCMPreliminaryId'];
    _courtTypeId = json['courtTypeId'];
    _conditionsId = json['conditionsId'];
    _visitationPeriod = json['visitationPeriod'];
    _visitationPeriodTo = json['visitationPeriodTo'];
    _numberOfVisits = json['numberOfVisits'];
    _placementDate = json['placementDate'];
    _supervisorId = json['supervisorId'];
    _placementConfirmed = json['placementConfirmed'];
    _createdBy = json['createdBy'];
    _dateCreated = json['dateCreated'];
    _modifiedBy = json['modifiedBy'];
    _dateModified = json['dateModified'];
    _courtTypeDto = json['courtTypeDto'] != null
        ? CourtTypeDto.fromJson(json['courtTypeDto'])
        : null;
  }
  int? _homeBasedSupervisionId;
  int? _intakeAssessmentId;
  int? _outcomeId;
  int? _formalCourtOutcomeId;
  int? _pCMPreliminaryId;
  int? _courtTypeId;
  int? _conditionsId;
  String? _visitationPeriod;
  String? _visitationPeriodTo;
  int? _numberOfVisits;
  String? _placementDate;
  int? _supervisorId;
  String? _placementConfirmed;
  int? _createdBy;
  String? _dateCreated;
  int? _modifiedBy;
  String? _dateModified;
  CourtTypeDto? _courtTypeDto;

  int? get homeBasedSupervisionId => _homeBasedSupervisionId;
  int? get intakeAssessmentId => _intakeAssessmentId;
  int? get coutcomeId => _outcomeId;
  int? get formalCourtOutcomeId => _formalCourtOutcomeId;
  int? get pCMPreliminaryId => _pCMPreliminaryId;
  int? get courtTypeId => _courtTypeId;
  int? get conditionsId => _conditionsId;
  String? get visitationPeriod => _visitationPeriod;
  String? get visitationPeriodTo => _visitationPeriodTo;
  int? get numberOfVisits => _numberOfVisits;
  String? get placementDate => _placementDate;
  int? get supervisorId => _supervisorId;
  String? get placementConfirmed => _placementConfirmed;
  int? get createdBy => _createdBy;
  String? get dateCreated => _dateCreated;
  int? get modifiedBy => _modifiedBy;
  String? get dateModified => _dateModified;
  CourtTypeDto? get courtTypeDto => _courtTypeDto;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['homeBasedSupervisionId'] = _homeBasedSupervisionId;
    map['intakeAssessmentId'] = _intakeAssessmentId;
    map['outcomeId'] = _outcomeId;
    map['formalCourtOutcomeId'] = _formalCourtOutcomeId;
    map['pCMPreliminaryId'] = _pCMPreliminaryId;
    map['courtTypeId'] = _courtTypeId;
    map['conditionsId'] = _conditionsId;
    map['visitationPeriod'] = _visitationPeriod;
    map['visitationPeriodTo'] = _visitationPeriodTo;
    map['numberOfVisits'] = _numberOfVisits;
    map['placementDate'] = _placementDate;
    map['supervisorId'] = _supervisorId;
    map['createdBy'] = _createdBy;
    map['dateCreated'] = _dateCreated;
    map['modifiedBy'] = _modifiedBy;
    map['dateModified'] = _dateModified;
    if (_courtTypeDto != null) {
      map['courtTypeDto'] = _courtTypeDto?.toJson();
    }

    return map;
  }
}
