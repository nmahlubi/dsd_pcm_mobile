class AllocatedCaseProbationOfficerDto {
  AllocatedCaseProbationOfficerDto({
    int? caseInformationId,
    int? personId,
    int? endPointPodId,
    String? fullName,
    String? allocatedInfo,
    String? arrestDetails,
    String? arrestTime,
  }) {
    _caseInformationId = caseInformationId;
    _personId = personId;
    _endPointPodId = endPointPodId;
    _fullName = fullName;
    _allocatedInfo = allocatedInfo;
    _arrestDetails = arrestDetails;
    _arrestTime = arrestTime;
  }

  AllocatedCaseProbationOfficerDto.fromJson(dynamic json) {
    _caseInformationId = json['caseInformationId'];
    _personId = json['person_Id'];
    _endPointPodId = json['end_Point_POD_Id'];
    _fullName = json['fullName'];
    _allocatedInfo = json['allocatedInfo'];
    _arrestDetails = json['arrestDetails'];
    _arrestTime = json['arrestTime'];
  }

  int? _caseInformationId;
  int? _personId;
  int? _endPointPodId;
  String? _fullName;
  String? _allocatedInfo;
  String? _arrestDetails;
  String? _arrestTime;

  int? get caseInformationId => _caseInformationId;
  int? get personId => _personId;
  int? get endPointPodId => _endPointPodId;
  String? get fullName => _fullName;
  String? get allocatedInfo => _allocatedInfo;
  String? get arrestDetails => _arrestDetails;
  String? get arrestTime => _arrestTime;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['caseInformationId'] = _caseInformationId;
    map['person_Id'] = _personId;
    map['end_Point_POD_Id'] = _endPointPodId;
    map['fullName'] = _fullName;
    map['allocatedInfo'] = _allocatedInfo;
    map['arrestDetails'] = _arrestDetails;
    map['arrestTime'] = _arrestTime;
    return map;
  }
}
