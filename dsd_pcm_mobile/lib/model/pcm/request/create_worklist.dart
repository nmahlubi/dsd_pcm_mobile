class CreateWorklist {
  CreateWorklist({
    int? endPointPOId,
    int? userId,
  }) {
    _endPointPOId = endPointPOId;
    _userId = userId;
  }

  CreateWorklist.fromJson(dynamic json) {
    _endPointPOId = json['endPointPOId'];
    _userId = json['userId'];
  }

  int? _endPointPOId;
  int? _userId;

  int? get endPointPOId => _endPointPOId;
  int? get userId => _userId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['endPointPOId'] = _endPointPOId;
    map['userId'] = _userId;
    return map;
  }
}
