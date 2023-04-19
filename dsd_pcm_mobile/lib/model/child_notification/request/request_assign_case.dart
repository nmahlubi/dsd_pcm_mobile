class RequestAssignCase {
  RequestAssignCase({
    int? notificationId,
    int? probationOfficerId,
    int? caseInformationId,
    int? contactTypeId,
    String? estimatedArrivalTime,
  }) {
    _notificationId = notificationId;
    _probationOfficerId = probationOfficerId;
    _caseInformationId = caseInformationId;
    _contactTypeId = contactTypeId;
    _estimatedArrivalTime = estimatedArrivalTime;
  }

  RequestAssignCase.fromJson(dynamic json) {
    _notificationId = json['notificationId'];
    _probationOfficerId = json['probationOfficerId'];
    _caseInformationId = json['caseInformationId'];
    _contactTypeId = json['contactTypeId'];
    _estimatedArrivalTime = json['estimatedArrivalTime'];
  }

  int? _notificationId;
  int? _probationOfficerId;
  int? _caseInformationId;
  int? _contactTypeId;
  String? _estimatedArrivalTime;

  int? get notificationId => _notificationId;
  int? get probationOfficerId => _probationOfficerId;
  int? get caseInformationId => _caseInformationId;
  int? get contactTypeId => _contactTypeId;
  String? get estimatedArrivalTime => _estimatedArrivalTime;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['notificationId'] = _notificationId;
    map['probationOfficerId'] = _probationOfficerId;
    map['caseInformationId'] = _caseInformationId;
    map['contactTypeId'] = _contactTypeId;
    map['estimatedArrivalTime'] = _estimatedArrivalTime;
    return map;
  }
}
