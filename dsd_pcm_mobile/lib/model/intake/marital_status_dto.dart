class MaritalStatusDto {
  MaritalStatusDto({
    int? maritalStatusId,
    String? description,
  }) {
    _maritalStatusId = maritalStatusId;
    _description = description;
  }

  MaritalStatusDto.fromJson(dynamic json) {
    _maritalStatusId = json['maritalStatusId'];
    _description = json['description'];
  }
  int? _maritalStatusId;
  String? _description;

  int? get maritalStatusId => _maritalStatusId;
  String? get description => _description;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['maritalStatusId'] = _maritalStatusId;
    map['description'] = _description;
    return map;
  }
}
