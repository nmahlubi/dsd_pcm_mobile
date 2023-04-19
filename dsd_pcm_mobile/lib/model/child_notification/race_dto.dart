class RaceDto {
  RaceDto({
    int? raceId,
    String? raceType,
    String? raceCode,
  }) {
    _raceId = raceId;
    _raceType = raceType;
    _raceCode = raceCode;
  }

  RaceDto.fromJson(dynamic json) {
    _raceId = json['raceId'];
    _raceType = json['raceType'];
    _raceCode = json['raceCode'];
  }

  int? _raceId;
  String? _raceType;
  String? _raceCode;

  int? get raceId => _raceId;
  String? get raceType => _raceType;
  String? get raceCode => _raceCode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['raceId'] = _raceId;
    map['raceType'] = _raceType;
    map['raceCode'] = _raceCode;
    return map;
  }
}
