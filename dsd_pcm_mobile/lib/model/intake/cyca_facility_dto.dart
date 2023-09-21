

class CycaFacilityDto {
  CycaFacilityDto({
    int? facilityId,
    String? facilityName,
    String? officialCapacity,
    String? facilityAddress,
    String? facilityFaxNo,
    String? facilityEmailAddress,
    String? facilityTelNo,
    String? facilityAccro,
    int? provinceId,
    int? admissionTypeId,
    int? organizationId,

  }) {
    _facilityId = facilityId;
    _facilityName = facilityName;
    _officialCapacity = officialCapacity;
    _facilityAddress = facilityAddress;
    _facilityFaxNo = facilityFaxNo;
    _facilityEmailAddress = facilityEmailAddress;
    _facilityTelNo = facilityTelNo;
    _facilityAccro = facilityAccro;
    _provinceId = provinceId;
    _admissionTypeId = admissionTypeId;
    _organizationId = organizationId;

  }

  CycaFacilityDto.fromJson(dynamic json) {
    _facilityId = json['facilityId'];
    _facilityName = json['facilityName'];
    _officialCapacity = json['officialCapacity'];
    _facilityAddress = json['facilityAddress'];
    _facilityFaxNo = json['facilityFaxNo'];
    _facilityEmailAddress = json['facilityEmailAddress'];
    _facilityTelNo = json['facilityTelNo'];
    _facilityAccro = json['facilityAccro'];
    _provinceId = json['provinceId'];
    _admissionTypeId = json['admissionTypeId'];
    _organizationId = json['organizationId'];

  }
  int? _facilityId;
  String? _facilityName;
  String? _officialCapacity;
  String? _facilityAddress;
  String? _facilityFaxNo;
  String? _facilityEmailAddress;
  String? _facilityTelNo;
  String? _facilityAccro;
  int? _provinceId;
  int? _admissionTypeId;
  int? _organizationId;

  int? get facilityId => _facilityId;
  String? get facilityName => _facilityName;
  String? get officialCapacity => _officialCapacity;
  String? get facilityAddress => _facilityAddress;
  String? get facilityFaxNo => _facilityFaxNo;
  String? get facilityEmailAddress => _facilityEmailAddress;
  String? get facilityTelNo => _facilityTelNo;
  String? get facilityAccro => _facilityAccro;
  int? get provinceId => _provinceId;
  int? get admissionTypeId => _admissionTypeId;
  int? get organizationId => _organizationId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    map['facilityId'] = _facilityId;
    map['facilityName'] = _facilityName;
    map['officialCapacity'] = _officialCapacity;
    map['facilityAddress'] = _facilityAddress;
    map['facilityFaxNo'] = _facilityFaxNo;
    map['facilityEmailAddress'] = _facilityEmailAddress;
    map['facilityTelNo'] = _facilityTelNo;
    map['facilityAccro'] = _facilityAccro;
    map['provinceId'] = _provinceId;
    map['admissionTypeId'] = _admissionTypeId;
    map['organizationId'] = _organizationId;

    return map;
  }
}
