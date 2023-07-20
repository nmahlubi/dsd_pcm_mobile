class ProgrammeModuleDto {
  ProgrammeModuleDto({
    int? programmeModuleId,
    String? description,
    int? numberofSessions,
    String? sessionStartDate,
    String? sessionEndDate,
    int? programmeId,
    String? defination,
    String? source,
  }) {
    _programmeModuleId = programmeModuleId;
    _description = description;
    _numberofSessions = numberofSessions;
    _sessionStartDate = sessionStartDate;
    _sessionEndDate = sessionEndDate;
    _programmeId = programmeId;
    _defination = defination;
    _source = source;
  }

  ProgrammeModuleDto.fromJson(dynamic json) {
    _programmeModuleId = json['programmeModuleId'];
    _description = json['description'];
    _numberofSessions = json['numberofSessions'];
    _sessionStartDate = json['sessionStartDate'];
    _sessionEndDate = json['sessionEndDate'];
    _programmeId = json['programmeId'];
    _defination = json['defination'];
    _source = json['source'];
  }

  int? _programmeModuleId;
  String? _description;
  int? _numberofSessions;
  String? _sessionStartDate;
  String? _sessionEndDate;
  int? _programmeId;
  String? _defination;
  String? _source;

  int? get programmeModuleId => _programmeModuleId;
  String? get description => _description;
  int? get numberofSessions => _numberofSessions;
  String? get sessionStartDate => _sessionStartDate;
  String? get sessionEndDate => _sessionEndDate;
  int? get programmeId => _programmeId;
  String? get defination => _defination;
  String? get source => _source;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['programmeModuleId'] = _programmeModuleId;
    map['description'] = _description;
    map['numberofSessions'] = _numberofSessions;
    map['sessionStartDate'] = _sessionStartDate;
    map['sessionEndDate'] = _sessionEndDate;
    map['programmeId'] = _programmeId;
    map['defination'] = _defination;
    map['source'] = _source;

    return map;
  }
}
