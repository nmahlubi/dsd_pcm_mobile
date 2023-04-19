class MobileDashboardDto {
  MobileDashboardDto({
    int? newPropationOfficerInbox,
    int? newWorklist,
    int? reAssignedCases,
  }) {
    _newPropationOfficerInbox = newPropationOfficerInbox;
    _newWorklist = newWorklist;
    _reAssignedCases = reAssignedCases;
  }

  MobileDashboardDto.fromJson(dynamic json) {
    _newPropationOfficerInbox = json['newPropationOfficerInbox'];
    _newWorklist = json['newWorklist'];
    _reAssignedCases = json['reAssignedCases'];
  }

  int? _newPropationOfficerInbox;
  int? _newWorklist;
  int? _reAssignedCases;

  int? get newPropationOfficerInbox => _newPropationOfficerInbox;
  int? get newWorklist => _newWorklist;
  int? get reAssignedCases => _reAssignedCases;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['newPropationOfficerInbox'] = _newPropationOfficerInbox;
    map['newWorklist'] = _newWorklist;
    map['reAssignedCases'] = _reAssignedCases;
    return map;
  }
}
