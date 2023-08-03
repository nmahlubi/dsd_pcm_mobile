import 'conditions_dto.dart';

class HBSConditionsDto {
  HBSConditionsDto({
    int? hBConditionId,
    int? intakeAssessmentId,
    int? homeBasedSupervisionId,
    int? conditionsId,
    int? createdBy,
    String? dateCreated,
    int? modifiedBy,
    String? dateModified,
     ConditionsDto? conditionsDto,
  }) {
    _hBConditionId = hBConditionId;
    _intakeAssessmentId = intakeAssessmentId;
    _homeBasedSupervisionId = homeBasedSupervisionId;
    _conditionsId = conditionsId;
    _createdBy = createdBy;
    _dateCreated = dateCreated;
    _modifiedBy = modifiedBy;
    _dateModified = dateModified;
    _conditionsDto = conditionsDto; 
  }
  HBSConditionsDto.fromJson(dynamic json) {
    _hBConditionId = json['hBConditionId'];
    _intakeAssessmentId = json['intakeAssessmentId'];
    _homeBasedSupervisionId = json['homeBasedSupervisionId'];
    _conditionsId = json['conditionsId'];
    _createdBy = json['createdBy'];
    _dateCreated = json['dateCreated'];
    _modifiedBy = json['modifiedBy'];
    _dateModified = json['dateModified'];
    _conditionsDto = json['conditionsDto'] != null
        ? ConditionsDto.fromJson(json['conditionsDto'])
        : null;
  }
  int? _hBConditionId;
  int? _intakeAssessmentId;
  int? _homeBasedSupervisionId;
  int? _conditionsId;
  int? _createdBy;
  String? _dateCreated;
  int? _modifiedBy;
  String? _dateModified;
  ConditionsDto? _conditionsDto;

  int? get hBConditionId => _hBConditionId;
  int? get intakeAssessmentId => _intakeAssessmentId;
  int? get homeBasedSupervisionId => _homeBasedSupervisionId;
  int? get conditionsId => _conditionsId;
  int? get createdBy => _createdBy;
  String? get dateCreated => _dateCreated;
  int? get modifiedBy => _modifiedBy;
  String? get dateModified => _dateModified;
  ConditionsDto? get conditionsDto => _conditionsDto;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['hBConditionId'] = _hBConditionId;
    map['intakeAssessmentId'] = _intakeAssessmentId;
    map['homeBasedSupervisionId'] = _homeBasedSupervisionId;
    map['conditionsId'] = _conditionsId;
    map['createdBy'] = _createdBy;
    map['dateCreated'] = _dateCreated;
    map['modifiedBy'] = _modifiedBy;
    map['dateModified'] = _dateModified;
    if (_conditionsDto != null) {
      map['conditionsDto'] = _conditionsDto?.toJson();
    }
    return map;
  }
}
