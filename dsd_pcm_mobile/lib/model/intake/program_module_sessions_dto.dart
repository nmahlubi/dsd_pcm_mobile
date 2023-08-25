class ProgramModuleSessionDto {
  ProgramModuleSessionDto({
    int? programModuleSessionsId,
    int? programModuleId,
    String? sessionName,
  }) {
    _programModuleSessionsId = programModuleSessionsId;
    _programModuleId = programModuleId;
    _sessionName = sessionName;
  }

  ProgramModuleSessionDto.fromJson(dynamic json) {
    _programModuleSessionsId = json['programModuleSessionId'];
    _programModuleId = json['programModuleId'];
    _sessionName = json['sessionName'];
  }
  int? _programModuleSessionsId;
  int? _programModuleId;
  String? _sessionName;

  int? get programModuleSessionsId => _programModuleSessionsId;
  int? get programModuleId => _programModuleId;
  String? get sessionName => _sessionName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['programModuleSessionId'] = _programModuleSessionsId;
    map['programModuleId'] = _programModuleId;
    map['sessionName'] = _sessionName;
    return map;
  }
}
