class DisabilityDto {
  DisabilityDto({
    int? disabilityId,
    String? description,
  }) {
    _disabilityId = disabilityId;
    _description = description;
  }

  DisabilityDto.fromJson(dynamic json) {
    _disabilityId = json['disability_Id'];
    _description = json['description'];
  }
  int? _disabilityId;
  String? _description;

  int? get disabilityId => _disabilityId;
  String? get description => _description;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['disability_Id'] = _disabilityId;
    map['description'] = _description;
    return map;
  }
}
