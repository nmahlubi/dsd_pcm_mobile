import '../intake/compliance_dto.dart';

class VisitationOutcomeDto{
   VisitationOutcomeDto({
    int? hBVisitaionOutcomeId,
    int? homeBasedSupervisionId,
    int? intakeAssessmentId,
    String? conatactNumber,
    String? processNotes,
    String? visitaionRegister,
    int? complianceId,
    int? createdBy,
    String? dateCreated,
    int? modifiedBy,
    String? dateModified,
    ComplianceDto? complianceDto,
  }) {
    _hBVisitaionOutcomeId=hBVisitaionOutcomeId;
    _homeBasedSupervisionId = homeBasedSupervisionId;
    _intakeAssessmentId = intakeAssessmentId;
    _conatactNumber=conatactNumber;
    _processNotes=processNotes;
    _visitaionRegister=visitaionRegister;
    _complianceId = complianceId;
    _createdBy= createdBy;
    _dateCreated =dateCreated;
    _modifiedBy=modifiedBy;
    _dateModified=dateModified;
    _complianceDto=complianceDto;
    
  }
  VisitationOutcomeDto.fromJson(dynamic json) {
   
    _hBVisitaionOutcomeId = json['hBVisitaionOutcomeId'];
    _homeBasedSupervisionId= json['homeBasedSupervisionId'];
    _intakeAssessmentId = json['intakeAssessmentId'];
    _conatactNumber= json['conatactNumber'];
    _processNotes = json['processNotes'];
    _visitaionRegister = json['visitaionRegister'];
    _complianceId= json['complianceId'];
    _createdBy = json['createdBy'];
    _dateCreated= json['dateCreated'];
    _modifiedBy = json['modifiedBy'];
    _dateModified =json['_dateModified'];

    _complianceDto = json['complianceDto'] != null
        ?ComplianceDto.fromJson(json['complianceDto'])
        : null;
 
  }
  int? _hBVisitaionOutcomeId;
  int? _homeBasedSupervisionId;
  int? _intakeAssessmentId;
  String? _conatactNumber;
  String? _processNotes;
   String? _visitaionRegister;
  int? _complianceId;
  int? _createdBy;
  String? _dateCreated;
  int? _modifiedBy;
  String? _dateModified;
  ComplianceDto? _complianceDto;
  

  int? get hBVisitaionOutcomeId => _hBVisitaionOutcomeId;
  int? get homeBasedSupervisionId => _homeBasedSupervisionId;
  int? get intakeAssessmentId => _intakeAssessmentId;
  String? get conatactNumber => _conatactNumber;
  String? get processNotes => _processNotes;
  String? get visitaionRegister => _visitaionRegister;
  int? get complianceId => _complianceId;
  int? get createdBy => _createdBy;
  String? get dateCreated => _dateCreated;
  int? get modifiedBy => _modifiedBy;
  String? get dateModified => _dateModified;
  ComplianceDto? get complianceDto => _complianceDto;
  
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
     map['hBVisitaionOutcomeId'] = _hBVisitaionOutcomeId;
    map['homeBasedSupervisionId'] = _homeBasedSupervisionId;
    map['intakeAssessmentId'] = _intakeAssessmentId;
    map['conatactNumber'] = _conatactNumber;
    map['processNotes'] = _processNotes;
    map['visitaionRegister'] = _visitaionRegister;
    map['homeBasedSupervisionId'] = _homeBasedSupervisionId;
    map['complianceId'] = _complianceId;
    map['dateCreated'] = _dateCreated;
    map['modifiedBy'] = _modifiedBy;
    map['dateModified'] = _dateModified;
    if (_complianceDto != null) {
      map['complianceDto'] = _complianceDto?.toJson();
    }
    return map;
  }
}