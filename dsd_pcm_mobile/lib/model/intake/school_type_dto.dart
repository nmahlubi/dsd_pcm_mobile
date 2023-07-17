class SchoolTypeDto {
  SchoolTypeDto({
    int? schoolTypeId,
    String? description,
  }) {
    _schoolTypeId = schoolTypeId;
    _description = description;
  }

  SchoolTypeDto.fromJson(dynamic json) {
    _schoolTypeId = json['schoolTypeId'];
    _description = json['description'];
  }
  int? _schoolTypeId;
  String? _description;

  int? get schoolTypeId => _schoolTypeId;
  String? get description => _description;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['schoolTypeId'] = _schoolTypeId;
    map['description'] = _description;
    return map;
  }
}
