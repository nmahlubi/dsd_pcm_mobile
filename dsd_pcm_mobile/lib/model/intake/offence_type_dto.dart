class OffenceTypeDto {
  OffenceTypeDto({
    int? offenceTypeId,
    String? description,
  }) {
    _offenceTypeId = offenceTypeId;
    _description = description;
  }

  OffenceTypeDto.fromJson(dynamic json) {
    _offenceTypeId = json['offenceTypeId'];
    _description = json['description'];
  }
  int? _offenceTypeId;
  String? _description;

  int? get offenceTypeId => _offenceTypeId;
  String? get description => _description;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['offenceTypeId'] = _offenceTypeId;
    map['description'] = _description;
    return map;
  }
}
