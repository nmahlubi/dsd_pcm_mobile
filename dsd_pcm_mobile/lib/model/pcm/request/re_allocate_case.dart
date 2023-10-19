class ReAllocateCase {
  ReAllocateCase({
    int? endPointPOId,
    int? probationOfficerId,
    int? modifiedBy,
    String? dateReAllocated,
  }) {
    _endPointPOId = endPointPOId;
    _probationOfficerId = probationOfficerId;
    _modifiedBy = modifiedBy;
    _dateReAllocated = dateReAllocated;
  }

  ReAllocateCase.fromJson(dynamic json) {
    _endPointPOId = json['endPointPOId'];
    _probationOfficerId = json['probationOfficerId'];
    _modifiedBy = json['modifiedBy'];
    _dateReAllocated = json['dateReAllocated'];
  }

  int? _endPointPOId;
  int? _probationOfficerId;
  int? _modifiedBy;
  String? _dateReAllocated;

  int? get endPointPOId => _endPointPOId;
  int? get probationOfficerId => _probationOfficerId;
  int? get modifiedBy => _modifiedBy;
  String? get dateReAllocated => _dateReAllocated;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['endPointPOId'] = _endPointPOId;
    map['probationOfficerId'] = _probationOfficerId;
    map['modifiedBy'] = _modifiedBy;
    map['dateReAllocated'] = _dateReAllocated;
    return map;
  }
}
