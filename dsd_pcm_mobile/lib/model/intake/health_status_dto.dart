class HealthStatusDto {
  HealthStatusDto({
    int? healthStatusId,
    String? description,
  }) {
    _healthStatusId = healthStatusId;
    _description = description;
  }

  HealthStatusDto.fromJson(dynamic json) {
    _healthStatusId = json['healthStatusId'];
    _description = json['description'];
  }
  int? _healthStatusId;
  String? _description;

  int? get healthStatusId => _healthStatusId;
  String? get description => _description;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['healthStatusId'] = _healthStatusId;
    map['description'] = _description;
    return map;
  }
}
