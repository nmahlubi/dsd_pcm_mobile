
class HomeBasedSupervionDto {
  HomeBasedSupervionDto({
    int? homeBasedSupervisionId,
    int? intakeAssessmentId,
    String? courtType,
    String? placementDate,
    int? supervisorId,
    int? conditionsId,

  }) {
    _homeBasedSupervisionId=homeBasedSupervisionId;
    _courtType = courtType;
    _placementDate = placementDate;
    _supervisorId =supervisorId;
    _intakeAssessmentId=intakeAssessmentId;
    _conditionsId = conditionsId;

  }
  HomeBasedSupervionDto.fromJson(dynamic json) {
    _homeBasedSupervisionId= json['homeBasedSupervisionId'];
    _intakeAssessmentId = json['intakeAssessmentId'];
    _courtType = json['courtType'];
    _placementDate= json['placementDate'];
    _supervisorId = json['supervisorId'];
   _conditionsId = json['conditionsId'];
 
  }
  int? _homeBasedSupervisionId;
  String? _courtType;
  String? _placementDate;
  int? _supervisorId;
  int? _intakeAssessmentId;
  int? _conditionsId;

  int? get homeBasedSupervisionId => _homeBasedSupervisionId;
  String? get courtType => _courtType;
  String? get placementDate => _placementDate;
  int? get supervisorId => _supervisorId;
  int? get intakeAssessmentId => _intakeAssessmentId;
  int? get conditionsId => _conditionsId;
  
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
     map['homeBasedSupervisionId'] = _homeBasedSupervisionId;
    map['courtType'] = _courtType;
    map['placementDate'] = _placementDate;
    map['supervisorId'] = _supervisorId;
    map['intakeAssessmentId'] = _intakeAssessmentId;
   map['conditionsId'] = _conditionsId;
    return map;
  }
}