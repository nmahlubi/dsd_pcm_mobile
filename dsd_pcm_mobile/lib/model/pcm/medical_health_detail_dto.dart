import '../intake/health_status_dto.dart';

class MedicalHealthDetailDto {
  MedicalHealthDetailDto({
    int? healthDetailsId,
    int? healthStatusId,
    String? injuries,
    String? medication,
    String? allergies,
    DateTime? medicalAppointments,
    int? intakeAssessmentId,
    String? createdBy,
    DateTime? dateCreated,
    int? modifiedBy,
    DateTime? dateModified,
    HealthStatusDto? healthStatusDto,
  }) {
    _healthDetailsId = healthDetailsId;
    _healthStatusId = healthStatusId;
    _injuries = injuries;
    _medication = medication;
    _allergies = allergies;
    _medicalAppointments = medicalAppointments;
    _intakeAssessmentId = intakeAssessmentId;
    _createdBy = createdBy;
    _dateCreated = dateCreated;
    _modifiedBy = modifiedBy;
    _dateModified = dateModified;
    _healthStatusDto = healthStatusDto;
  }

  MedicalHealthDetailDto.fromJson(dynamic json) {
    _healthDetailsId = json['healthDetailsId'];
    _healthStatusId = json['healthStatusId'];
    _injuries = json['injuries'];
    _medication = json['medication'];
    _allergies = json['allergies'];
    _medicalAppointments = json['medicalAppointments'];
    _intakeAssessmentId = json['intakeAssessmentId'];
    _createdBy = json['createdBy'];
    _dateCreated = json['dateCreated'];
    _modifiedBy = json['modifiedBy'];
    _dateModified = json['dateModified'];
    _healthStatusDto = json['healthStatusDto'] != null
        ? HealthStatusDto.fromJson(json['healthStatusDto'])
        : null;
  }
  int? _healthDetailsId;
  int? _healthStatusId;
  String? _injuries;
  String? _medication;
  String? _allergies;
  DateTime? _medicalAppointments;
  int? _intakeAssessmentId;
  String? _createdBy;
  DateTime? _dateCreated;
  int? _modifiedBy;
  DateTime? _dateModified;
  HealthStatusDto? _healthStatusDto;

  int? get healthDetailsId => _healthDetailsId;
  int? get healthStatusId => _healthStatusId;
  String? get injuries => _injuries;
  String? get medication => _medication;
  String? get allergies => _allergies;
  DateTime? get medicalAppointments => _medicalAppointments;
  int? get intakeAssessmentId => _intakeAssessmentId;
  String? get createdBy => _createdBy;
  DateTime? get dateCreated => _dateCreated;
  int? get modifiedBy => _modifiedBy;
  DateTime? get dateModified => _dateModified;
  HealthStatusDto? get healthStatusDto => _healthStatusDto;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    map['healthDetailsId'] = _healthDetailsId;
    map['healthStatusId'] = _healthStatusId;
    map['injuries'] = _injuries;
    map['medication'] = _medication;
    map['allergies'] = _allergies;
    map['medicalAppointments'] = _medicalAppointments;
    map['intakeAssessmentId'] = _intakeAssessmentId;
    map['createdBy'] = _createdBy;
    map['dateCreated'] = _dateCreated;
    map['modifiedBy'] = _modifiedBy;
    map['dateModified'] = _dateModified;
    if (_healthStatusDto != null) {
      map['healthStatusDto'] = _healthStatusDto?.toJson();
    }
    return map;
  }
}
