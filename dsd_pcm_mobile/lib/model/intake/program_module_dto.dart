class ProgramModuleDto {
  ProgramModuleDto({
    int? programModuleId,
    int? programmeId,
    String? moduleName,
    String? moduleDescription,
  }) {
    _programModuleId = programModuleId;
    _programmeId = programmeId;
    _moduleName = moduleName;
    _moduleDescription = moduleDescription;
  }

  ProgramModuleDto.fromJson(dynamic json) {
    _programModuleId = json['programModuleId'];
    _programmeId = json['programmeId'];
    _moduleName = json['moduleName'];
    _moduleDescription = json['moduleDescription'];
  }
  int? _programModuleId;
  int? _programmeId;
  String? _moduleName;
  String? _moduleDescription;

  int? get programModuleId => _programModuleId;
  int? get programmeId => _programmeId;
  String? get moduleName => _moduleName;
  String? get moduleDescription => _moduleDescription;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['programModuleId'] = _programModuleId;
    map['programmeId'] = _programmeId;
    map['moduleName'] = _moduleName;
    map['moduleDescription'] = _moduleDescription;
    return map;
  }
}
