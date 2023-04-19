class NationalityDto {
  NationalityDto({
    int? nationalityId,
    String? description,
  }) {
    _nationalityId = nationalityId;
    _description = description;
  }

  NationalityDto.fromJson(dynamic json) {
    _nationalityId = json['nationalityId'];
    _description = json['description'];
  }
  int? _nationalityId;
  String? _description;

  int? get nationalityId => _nationalityId;
  String? get description => _description;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['nationalityId'] = _nationalityId;
    map['description'] = _description;
    return map;
  }
}
