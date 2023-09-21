import 'package:dsd_pcm_mobile/model/intake/organization_dto.dart';

class ProgrammesDto {
  ProgrammesDto({
    int? programmeId,
    String? programmeName,
    String? programmeDescription,
    String? programmeStartDate,
    String? programmeEndDate,
    int? programmeTypeId,
    int? organizationId,
    int? programmeCategoryId,
    OrganizationDto? organizationDto,
  }) {
    _programmeId = programmeId;
    _programmeName = programmeName;
    _programmeDescription = programmeDescription;
    _programmeStartDate = programmeStartDate;
    _programmeEndDate = programmeEndDate;
    _programmeTypeId = programmeTypeId;
    _organizationId = organizationId;
    _programmeCategoryId = programmeCategoryId;
    _organizationDto = organizationDto;
  }
  ProgrammesDto.fromJson(dynamic json) {
    _programmeId = json['programmeId'];
    _programmeName = json['programmeName'];
    _programmeDescription = json['programmeDescription'];
    _programmeStartDate = json['programmeStartDate'];
    _programmeEndDate = json['programmeEndDate'];
    _programmeTypeId = json['programmeTypeId'];
    _organizationId = json['organizationId'];
    _programmeCategoryId = json['programmeCategoryId'];
    _organizationDto = json['organizationDto'] != null
        ? OrganizationDto.fromJson(json['organizationDto'])
        : null;
  }
  int? _programmeId;
  String? _programmeName;
  String? _programmeDescription;
  String? _programmeStartDate;
  String? _programmeEndDate;
  int? _programmeTypeId;
  int? _organizationId;
  int? _programmeCategoryId;
  OrganizationDto? _organizationDto;

  int? get programmeId => _programmeId;
  String? get programmeName => _programmeName;
  String? get programmeDescription => _programmeDescription;
  String? get programmeStartDate => _programmeStartDate;
  String? get programmeEndDate => _programmeEndDate;
  int? get programmeTypeId => _programmeTypeId;
  int? get organizationId => _organizationId;
  int? get programmeCategoryId => _programmeCategoryId;
  OrganizationDto? get organizationDto => _organizationDto;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['programmeId'] = _programmeId;
    map['programmeName'] = _programmeName;
    map['programmeDescription'] = _programmeDescription;
    map['programmeStartDate'] = _programmeStartDate;
    map['programmeEndDate'] = _programmeEndDate;
    map['programmeTypeId'] = _programmeTypeId;
    map['organizationId'] = _organizationId;
    map['programmeCategoryId'] = _programmeCategoryId;
    if (_organizationDto != null) {
      map['ProgrammesDto'] = _organizationDto?.toJson();
    }

    return map;
  }
}
