import '../intake/form_of_notification_dto.dart';

class AssesmentRegisterDto {
  AssesmentRegisterDto({
    int? assesmentRegisterId,
    int? pcmCaseId,
    int? intakeAssessmentId,
    int? probationOfficerId,
    int? assessedBy,
    String? assessmentDate,
    String? assessmentTime,
    int? formOfNotificationId,
    int? townId,
    int? createdBy,
    int? modifiedBy,
    String? dateCreated,
    String? dateModified,
    FormOfNotificationDto? formOfNotificationDto,
  }) {
    _assesmentRegisterId = assesmentRegisterId;
    _pcmCaseId = pcmCaseId;
    _intakeAssessmentId = intakeAssessmentId;
    _probationOfficerId = probationOfficerId;
    _assessedBy = assessedBy;
    _assessmentDate = assessmentDate;
    _assessmentTime = assessmentTime;
    _formOfNotificationId = formOfNotificationId;
    _townId = townId;
    _createdBy = createdBy;
    _modifiedBy = modifiedBy;
    _dateCreated = dateCreated;
    _dateModified = dateModified;
    _formOfNotificationDto = formOfNotificationDto;
  }
  AssesmentRegisterDto.fromJson(dynamic json) {
    _assesmentRegisterId = json['assesmentRegisterId'];
    _pcmCaseId = json['pcmCaseId'];
    _intakeAssessmentId = json['intakeAssessmentId'];
    _probationOfficerId = json['probationOfficerId'];
    _assessedBy = json['assessedBy'];
    _assessmentDate = json['assessmentDate'];
    _assessmentTime = json['assessmentTime'];
    _formOfNotificationId = json['formOfNotificationId'];
    _townId = json['townId'];
    _createdBy = json['createdBy'];
    _modifiedBy = json['modifiedBy'];
    _dateCreated = json['dateCreated'];
    _dateModified = json['dateModified'];
    _formOfNotificationDto = json['formOfNotificationDto'] != null
        ? FormOfNotificationDto.fromJson(json['formOfNotificationDto'])
        : null;
  }
  int? _assesmentRegisterId;
  int? _pcmCaseId;
  int? _intakeAssessmentId;
  int? _probationOfficerId;
  int? _assessedBy;
  String? _assessmentDate;
  String? _assessmentTime;
  int? _formOfNotificationId;
  int? _townId;
  int? _createdBy;
  int? _modifiedBy;
  String? _dateCreated;
  String? _dateModified;
  FormOfNotificationDto? _formOfNotificationDto;

  int? get assesmentRegisterId => _assesmentRegisterId;
  int? get pcmCaseId => _pcmCaseId;
  int? get intakeAssessmentId => _intakeAssessmentId;
  int? get probationOfficerId => _probationOfficerId;
  int? get assessedBy => _assessedBy;
  String? get assessmentDate => _assessmentDate;
  String? get assessmentTime => _assessmentTime;
  int? get formOfNotificationId => _formOfNotificationId;
  int? get townId => _townId;
  int? get createdBy => _createdBy;
  int? get modifiedBy => _modifiedBy;
  String? get dateCreated => _dateCreated;
  String? get dateModified => _dateModified;
  FormOfNotificationDto? get formOfNotificationDto => _formOfNotificationDto;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['assesmentRegisterId'] = _assesmentRegisterId;
    map['pcmCaseId'] = _pcmCaseId;
    map['intakeAssessmentId'] = _intakeAssessmentId;
    map['probationOfficerId'] = _probationOfficerId;
    map['assessedBy'] = _assessedBy;
    map['assessmentDate'] = _assessmentDate;
    map['assessmentTime'] = _assessmentTime;
    map['formOfNotificationId'] = _formOfNotificationId;
    map['townId'] = _townId;
    map['createdBy'] = _createdBy;
    map['modifiedBy'] = _modifiedBy;
    map['dateCreated'] = _dateCreated;
    map['dateModified'] = _dateModified;
    if (_formOfNotificationDto != null) {
      map['formOfNotificationDto'] = _formOfNotificationDto?.toJson();
    }
    return map;
  }
}
