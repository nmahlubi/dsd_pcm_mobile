import 'package:dsd_pcm_mobile/model/pcm/programmes_dto.dart';

class ProgramsEnrolledDto {
  ProgramsEnrolledDto({
    int? enrolmentID,
    int? diversionId,
    int? assessement,
    int? programmeId,
    String? facilitator,
    int? provinceId,
    int? districtId,
    String? programName,
    String? programDescription,
    String? endDate,
    int? ageGroupId,
    int? organisationId,
    int? localMunicipalityId,
    int? programmeLevelId,
    String? startDate,
    int? userId,
    String? createDate,
    ProgrammesDto? programmesDto,
    /* ProvinceDto? provinceDto,
    PersonDto? personDto,
    PersonDto? personDto,*/
  }) {
    _enrolmentID = enrolmentID;
    _diversionId = diversionId;
    _assessement = assessement;
    _programmeId = programmeId;
    _facilitator = facilitator;
    _provinceId = provinceId;
    _districtId = districtId;
    _programName = programName;
    _programDescription = programDescription;
    _endDate = endDate;
    _ageGroupId = ageGroupId;
    _organisationId = organisationId;
    _localMunicipalityId = localMunicipalityId;
    _programmeLevelId = programmeLevelId;
    _startDate = startDate;
    _userId = userId;
    _createDate = createDate;
    _ProgrammesDto = programmesDto;
    /* _ProvinceDto = provinceDto;
    _personDto = personDto;
    _personDto = personDto;*/
  }

  ProgramsEnrolledDto.fromJson(dynamic json) {
    _enrolmentID = json['enrolmentID'];
    _diversionId = json['diversionId'];
    _assessement = json['assessement'];
    _programmeId = json['programmeId'];
    _facilitator = json['facilitator'];
    _provinceId = json['provinceId'];
    _districtId = json['districtId'];
    _programName = json['programName'];
    _programDescription = json['programDescription'];
    _endDate = json['endDate'];
    _ageGroupId = json['ageGroupId'];
    _organisationId = json['organisationId'];
    _localMunicipalityId = json['localMunicipalityId'];
    _programmeLevelId = json['programmeLevelId'];
    _startDate = json['startDate'];
    _userId = json['userId'];
    _createDate = json['createDate'];
    _ProgrammesDto = json['programmesDto'] != null
        ? ProgrammesDto.fromJson(json['programmesDto'])
        : null;
    /* 
    _ProvinceDto = json['provinceDto'] != null
        ? ProvinceDto.fromJson(json['provinceDto'])
        : null;
    _personDto = json['personDto'] != null
        ? PersonDto.fromJson(json['personDto'])
        : null;*/
  }
  int? _enrolmentID;
  int? _diversionId;
  int? _assessement;
  int? _programmeId;
  String? _facilitator;
  int? _provinceId;
  int? _districtId;
  String? _programName;
  String? _programDescription;
  String? _endDate;
  int? _ageGroupId;
  int? _organisationId;
  int? _localMunicipalityId;
  int? _programmeLevelId;
  String? _startDate;
  int? _userId;
  String? _createDate;
  ProgrammesDto? _ProgrammesDto;
  //PersonDto? _personDto;

  int? get enrolmentID => _enrolmentID;
  int? get diversionId => _diversionId;
  int? get assessement => _assessement;
  int? get programmeId => _programmeId;
  String? get facilitator => _facilitator;
  int? get provinceId => _provinceId;
  int? get districtId => _districtId;
  String? get programName => _programName;
  String? get programDescription => _programDescription;
  String? get endDate => _endDate;
  int? get ageGroupId => _ageGroupId;
  int? get organisationId => _organisationId;
  int? get localMunicipalityId => _localMunicipalityId;
  int? get programmeLevelId => _programmeLevelId;
  String? get startDate => _startDate;
  int? get userId => _userId;
  String? get createDate => _createDate;

  ProgrammesDto? get programmesDto => _ProgrammesDto;
  //PersonDto? get personDto => _personDto;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    map['enrolmentID'] = _enrolmentID;
    map['diversionId'] = _diversionId;
    map['assessement'] = _assessement;
    map['programmeId'] = _programmeId;
    map['facilitator'] = _facilitator;
    map['provinceId'] = _provinceId;
    map['districtId'] = _districtId;
    map['programName'] = _programName;
    map['programDescription'] = _programDescription;
    map['endDate'] = _endDate;
    map['ageGroupId'] = _ageGroupId;
    map['organisationId'] = _organisationId;
    map['localMunicipalityId'] = _localMunicipalityId;
    map['programmeLevelId'] = _programmeLevelId;
    map['startDate'] = _startDate;
    map['userId'] = _userId;
    map['createDate'] = _createDate;

    if (_ProgrammesDto != null) {
      map['ProgrammesDto'] = _ProgrammesDto?.toJson();
    }
    /*if (_personDto != null) {
      map['personDto'] = _personDto?.toJson();
    }*/
    return map;
  }
}
