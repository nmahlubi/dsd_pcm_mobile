class OffenseTypeDto {
  OffenseTypeDto({
    int? offenseCodeId,
    String? offenseDescription,
    String? offenseCode,
  }) {
    _offenseCodeId = offenseCodeId;
    _offenseDescription = offenseDescription;
    _offenseCode = offenseCode;
  }

  OffenseTypeDto.fromJson(dynamic json) {
    _offenseCodeId = json['offenseCodeId'];
    _offenseDescription = json['offenseDescription'];
    _offenseCode = json['offenseCode'];
  }

  int? _offenseCodeId;
  String? _offenseDescription;
  String? _offenseCode;

  int? get offenseCodeId => _offenseCodeId;
  String? get offenseDescription => _offenseDescription;
  String? get offenseCode => _offenseCode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['offenseCodeId'] = _offenseCodeId;
    map['offenseDescription'] = _offenseDescription;
    map['offenseCode'] = _offenseCode;
    return map;
  }
}
