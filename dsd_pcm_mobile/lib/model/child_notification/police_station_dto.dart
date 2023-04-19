class PoliceStationDto {
  PoliceStationDto({
    int? policeStationId,
    String? policeStationName,
    String? componentCode,
  }) {
    _policeStationId = policeStationId;
    _policeStationName = policeStationName;
    _componentCode = componentCode;
  }

  PoliceStationDto.fromJson(dynamic json) {
    _policeStationId = json['policeStationId'];
    _policeStationName = json['policeStationName'];
    _componentCode = json['componentCode'];
  }

  int? _policeStationId;
  String? _policeStationName;
  String? _componentCode;

  int? get policeStationId => _policeStationId;
  String? get policeStationName => _policeStationName;
  String? get componentCode => _componentCode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['policeStationId'] = _policeStationId;
    map['policeStationName'] = _policeStationName;
    map['componentCode'] = _componentCode;
    return map;
  }
}
