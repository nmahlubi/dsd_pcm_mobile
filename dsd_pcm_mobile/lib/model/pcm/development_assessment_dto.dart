class DevelopmentAssessmentDto {
  DevelopmentAssessmentDto({
    int? developmentId,
    int? intakeAssessmentId,
    String? belonging,
    String? mastery,
    String? independence,
    String? generosity,
    String? evaluation,
    int? createdBy,
    int? modifiedBy,
    String? dateCreated,
    String? dateModified,
  }) {
    _developmentId = developmentId;
    _intakeAssessmentId = intakeAssessmentId;
    _belonging = belonging;
    _mastery = mastery;
    _independence = independence;
    _generosity = generosity;
    _evaluation = evaluation;
    _createdBy = createdBy;
    _modifiedBy = modifiedBy;
    _dateCreated = dateCreated;
    _dateModified = dateModified;
  }

  DevelopmentAssessmentDto.fromJson(dynamic json) {
    _developmentId = json['developmentId'];
    _intakeAssessmentId = json['intakeAssessmentId'];
    _belonging = json['belonging'];
    _mastery = json['mastery'];
    _independence = json['independence'];
    _generosity = json['generosity'];
    _evaluation = json['evaluation'];
    _createdBy = json['createdBy'];
    _modifiedBy = json['modifiedBy'];
    _dateCreated = json['dateCreated'];
    _dateModified = json['dateModified'];
  }

  int? _developmentId;
  int? _intakeAssessmentId;
  String? _belonging;
  String? _mastery;
  String? _independence;
  String? _generosity;
  String? _evaluation;
  int? _createdBy;
  int? _modifiedBy;
  String? _dateCreated;
  String? _dateModified;

  int? get developmentId => _developmentId;
  int? get intakeAssessmentId => _intakeAssessmentId;
  String? get belonging => _belonging;
  String? get mastery => _mastery;
  String? get independence => _independence;
  String? get generosity => _generosity;
  String? get evaluation => _evaluation;
  int? get createdBy => _createdBy;
  int? get modifiedBy => _modifiedBy;
  String? get dateCreated => _dateCreated;
  String? get dateModified => _dateModified;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['developmentId'] = _developmentId;
    map['intakeAssessmentId'] = _intakeAssessmentId;
    map['belonging'] = _belonging;
    map['mastery'] = _mastery;
    map['independence'] = _independence;
    map['generosity'] = _generosity;
    map['evaluation'] = _evaluation;
    map['createdBy'] = _createdBy;
    map['modifiedBy'] = _modifiedBy;
    map['dateCreated'] = _dateCreated;
    map['dateModified'] = _dateModified;
    return map;
  }
}
