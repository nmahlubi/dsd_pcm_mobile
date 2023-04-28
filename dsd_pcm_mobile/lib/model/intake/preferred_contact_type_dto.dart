class PreferredContactTypeDto {
  PreferredContactTypeDto({
    int? preferredContactTypeId,
    String? description,
  }) {
    _preferredContactTypeId = preferredContactTypeId;
    _description = description;
  }

  PreferredContactTypeDto.fromJson(dynamic json) {
    _preferredContactTypeId = json['preferredContactTypeId'];
    _description = json['description'];
  }
  int? _preferredContactTypeId;
  String? _description;

  int? get preferredContactTypeId => _preferredContactTypeId;
  String? get description => _description;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['preferredContactTypeId'] = _preferredContactTypeId;
    map['description'] = _description;
    return map;
  }
}
