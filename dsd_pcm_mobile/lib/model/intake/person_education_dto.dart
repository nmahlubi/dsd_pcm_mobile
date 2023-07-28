import 'grade_dto.dart';
import 'school_dto.dart';

class PersonEducationDto {
  PersonEducationDto({
    int? personEducationId,
    int? personId,
    int? gradeId,
    int? schoolId,
    String? yearCompleted,
    String? dateLastAttended,
    String? additionalInformation,
    String? dateCreated,
    String? createdBy,
    String? dateLastModified,
    String? modifiedBy,
    bool? isActive,
    bool? isDeleted,
    String? schoolName,
    SchoolDto? schoolDto,
    GradeDto? gradeDto,
  }) {
    _personEducationId = personEducationId;
    _personId = personId;
    _gradeId = gradeId;
    _schoolId = schoolId;
    _yearCompleted = yearCompleted;
    _dateLastAttended = dateLastAttended;
    _additionalInformation = additionalInformation;
    _dateCreated = dateCreated;
    _createdBy = createdBy;
    _dateLastModified = dateLastModified;
    _modifiedBy = modifiedBy;
    _isActive = isActive;
    _isDeleted = isDeleted;
    _schoolName = schoolName;
    _schoolDto = schoolDto;
    _gradeDto = gradeDto;
  }

  PersonEducationDto.fromJson(dynamic json) {
    _personEducationId = json['personEducationId'];
    _personId = json['personId'];
    _schoolId = json['schoolId'];
    _gradeId = json['gradeId'];
    _yearCompleted = json['yearCompleted'];
    _dateLastAttended = json['dateLastAttended'];
    _additionalInformation = json['additionalInformation'];
    _dateCreated = json['dateCreated'];
    _createdBy = json['createdBy'];
    _dateLastModified = json['dateLastModified'];
    _modifiedBy = json['modifiedBy'];
    _isActive = json['isActive'];
    _isDeleted = json['isDeleted'];
    _schoolName = json['schoolName'];
    _schoolDto = json['schoolDto'] != null
        ? SchoolDto.fromJson(json['schoolDto'])
        : null;
    _gradeDto =
        json['gradeDto'] != null ? GradeDto.fromJson(json['gradeDto']) : null;
  }
  int? _personEducationId;
  int? _personId;
  int? _gradeId;
  int? _schoolId;
  String? _yearCompleted;
  String? _dateLastAttended;
  String? _additionalInformation;
  String? _dateCreated;
  String? _createdBy;
  String? _dateLastModified;
  String? _modifiedBy;
  bool? _isActive;
  bool? _isDeleted;
  String? _schoolName;
  SchoolDto? _schoolDto;
  GradeDto? _gradeDto;

  int? get personEducationId => _personEducationId;
  int? get personId => _personId;
  int? get gradeId => _gradeId;
  int? get schoolId => _schoolId;
  String? get yearCompleted => _yearCompleted;
  String? get dateLastAttended => _dateLastAttended;
  String? get additionalInformation => _additionalInformation;
  String? get dateCreated => _dateCreated;
  String? get createdBy => _createdBy;
  String? get dateLastModified => _dateLastModified;
  String? get modifiedBy => _modifiedBy;
  bool? get isActive => _isActive;
  bool? get isDeleted => _isDeleted;
  String? get schoolName => _schoolName;
  SchoolDto? get schoolDto => _schoolDto;
  GradeDto? get gradeDto => _gradeDto;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    map['personEducationId'] = _personEducationId;
    map['personId'] = _personId;
    map['gradeId'] = _gradeId;
    map['schoolId'] = _schoolId;
    map['yearCompleted'] = _yearCompleted;
    map['dateLastAttended'] = _dateLastAttended;
    map['additionalInformation'] = _additionalInformation;
    map['dateCreated'] = _dateCreated;
    map['createdBy'] = _createdBy;
    map['dateLastModified'] = _dateLastModified;
    map['isActive'] = _isActive;
    map['isDeleted'] = _isDeleted;
    map['modifiedBy'] = _modifiedBy;
    map['schoolName'] = _schoolName;
    if (_schoolDto != null) {
      map['schoolDto'] = _schoolDto?.toJson();
    }
    if (_gradeDto != null) {
      map['gradeDto'] = _gradeDto?.toJson();
    }
    return map;
  }
}
