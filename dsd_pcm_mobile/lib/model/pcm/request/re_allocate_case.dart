class ReAllocateCase {
  ReAllocateCase({
    int? endPointPOId,
    int? probationOfficerId,
    int? modifiedBy,
  }) {
    _endPointPOId = endPointPOId;
    _probationOfficerId = probationOfficerId;
    _modifiedBy = modifiedBy;
  }

  ReAllocateCase.fromJson(dynamic json) {
    _endPointPOId = json['endPointPOId'];
    _probationOfficerId = json['probationOfficerId'];
    _modifiedBy = json['modifiedBy'];
  }

  int? _endPointPOId;
  int? _probationOfficerId;
  int? _modifiedBy;

  int? get endPointPOId => _endPointPOId;
  int? get probationOfficerId => _probationOfficerId;
  int? get modifiedBy => _modifiedBy;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['endPointPOId'] = _endPointPOId;
    map['probationOfficerId'] = _probationOfficerId;
    map['modifiedBy'] = _modifiedBy;
    return map;
  }
}
