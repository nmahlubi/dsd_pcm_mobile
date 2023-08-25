import 'package:dsd_pcm_mobile/model/intake/program_module_dto.dart';
import '../intake/program_module_sessions_dto.dart';

class ProgramEnrolmentSessionOutcomeDto {
  ProgramEnrolmentSessionOutcomeDto({
    int? sessionId,
    int? enrolmentID,
    int? programModuleId,
    String? sessionOutCome,
    String? sessionDate,
    int? programModuleSessionsId,
    int? createdBy,
    String? dateCreated,
    int? modifiedBy,
    String? dateModified,
    ProgramModuleDto? programModuleDto,
    ProgramModuleSessionDto? programModuleSessionDto,
    int? enrollmentId,
  }) {
    _sessionId = sessionId;
    _enrolmentID = enrolmentID;
    _programModuleId = programModuleId;
    _sessionOutCome = sessionOutCome;
    _sessionDate = sessionDate;
    _programModuleSessionsId = programModuleSessionsId;
    _createdBy = createdBy;
    _dateCreated = dateCreated;
    _modifiedBy = modifiedBy;
    _dateModified = dateModified;
    _programModuleDto = programModuleDto;
    _programModuleSessionDto = programModuleSessionDto;
  }

  ProgramEnrolmentSessionOutcomeDto.fromJson(dynamic json) {
    _sessionId = json['sessionId'];
    _enrolmentID = json['enrolmentID'];
    _programModuleId = json['programModuleId'];
    _sessionOutCome = json['sessionOutCome'];
    _sessionDate = json['sessionDate'];
    _programModuleSessionsId = json['programModuleSessionId'];
    _createdBy = json['createdBy'];
    _dateCreated = json['dateCreated'];
    _modifiedBy = json['modifiedBy'];
    _dateModified = json['dateModified'];
    _programModuleDto = json['programModuleDto'] != null
        ? ProgramModuleDto.fromJson(json['programModuleDto'])
        : null;
    _programModuleSessionDto = json['programModuleSessionDto'] != null
        ? ProgramModuleSessionDto.fromJson(json['programModuleSessionDto'])
        : null;
  }
  int? _sessionId;
  int? _enrolmentID;
  int? _programModuleId;
  String? _sessionOutCome;
  String? _sessionDate;
  int? _programModuleSessionsId;
  int? _createdBy;
  String? _dateCreated;
  int? _modifiedBy;
  String? _dateModified;
  ProgramModuleDto? _programModuleDto;
  ProgramModuleSessionDto? _programModuleSessionDto;

  int? get sessionId => _sessionId;
  int? get enrolmentID => _enrolmentID;
  int? get programModuleId => _programModuleId;
  String? get sessionOutCome => _sessionOutCome;
  String? get sessionDate => _sessionDate;
  int? get programModuleSessionsId => _programModuleSessionsId;
  int? get createdBy => _createdBy;
  String? get dateCreated => _dateCreated;
  int? get modifiedBy => _modifiedBy;
  String? get dateModified => _dateModified;
  ProgramModuleDto? get programModuleDto => _programModuleDto;
  ProgramModuleSessionDto? get programModuleSessionDto =>
      _programModuleSessionDto;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['sessionId'] = _sessionId;
    map['enrolmentID'] = _enrolmentID;
    map['programModuleId'] = _programModuleId;
    map['sessionOutCome'] = _sessionOutCome;
    map['sessionDate'] = _sessionDate;
    map['programModuleSessionId'] = _programModuleSessionsId;
    map['createdBy'] = _createdBy;
    map['dateCreated'] = _dateCreated;
    map['dateModified'] = _dateModified;
    map['modifiedBy'] = _modifiedBy;
    if (_programModuleDto != null) {
      map['programModuleDto'] = _programModuleDto?.toJson();
    }
    if (_programModuleSessionDto != null) {
      map['programModuleSessionDto'] = _programModuleSessionDto?.toJson();
    }
    return map;
  }
}
