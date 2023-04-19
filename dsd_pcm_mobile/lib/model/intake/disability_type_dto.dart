class DisabilityTypeDto {
  DisabilityTypeDto({
    int? disabilityTypeId,
    String? typeName,
  }) {
    _disabilityTypeId = disabilityTypeId;
    _typeName = typeName;
  }

  DisabilityTypeDto.fromJson(dynamic json) {
    _disabilityTypeId = json['disabilityTypeId'];
    _typeName = json['typeName'];
  }
  int? _disabilityTypeId;
  String? _typeName;

  int? get disabilityTypeId => _disabilityTypeId;
  String? get typeName => _typeName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['disabilityTypeId'] = _disabilityTypeId;
    map['typeName'] = _typeName;
    return map;
  }
}
