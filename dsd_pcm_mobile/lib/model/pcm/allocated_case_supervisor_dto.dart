class AllocatedCaseSupervisorDto {
  AllocatedCaseSupervisorDto({
    int? endpointPoId,
    int? caseInformationId,
    String? childName,
    String? probationOfficer,
    String? arrestDetails,
    String? allocateTo,
    String? dateAllocated,
  }) {
    _endpointPoId = endpointPoId;
    _caseInformationId = caseInformationId;
    _childName = childName;
    _probationOfficer = probationOfficer;
    _arrestDetails = arrestDetails;
    _allocateTo = allocateTo;
    _dateAllocated = dateAllocated;
  }

  AllocatedCaseSupervisorDto.fromJson(dynamic json) {
    _endpointPoId = json['endpointPoId'];
    _caseInformationId = json['caseInformationId'];
    _childName = json['childName'];
    _probationOfficer = json['probationOfficer'];
    _arrestDetails = json['arrestDetails'];
    _allocateTo = json['allocateTo'];
    _dateAllocated = json['dateAllocated'];
  }

  int? _endpointPoId;
  int? _caseInformationId;
  String? _childName;
  String? _probationOfficer;
  String? _arrestDetails;
  String? _allocateTo;
  String? _dateAllocated;

  int? get endpointPoId => _endpointPoId;
  int? get caseInformationId => _caseInformationId;
  String? get childName => _childName;
  String? get probationOfficer => _probationOfficer;
  String? get arrestDetails => _arrestDetails;
  String? get allocateTo => _allocateTo;
  String? get dateAllocated => _dateAllocated;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['endpointPoId'] = _endpointPoId;
    map['caseInformationId'] = _caseInformationId;
    map['childName'] = _childName;
    map['probationOfficer'] = _probationOfficer;
    map['arrestDetails'] = _arrestDetails;
    map['allocateTo'] = _allocateTo;
    map['dateAllocated'] = _dateAllocated;
    return map;
  }
}
