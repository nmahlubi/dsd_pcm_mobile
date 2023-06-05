class OffenceCategoryDto {
  OffenceCategoryDto({
    int? offenceCategoryId,
    String? description,
  }) {
    _offenceCategoryId = offenceCategoryId;
    _description = description;
  }

  OffenceCategoryDto.fromJson(dynamic json) {
    _offenceCategoryId = json['offenceCategoryId'];
    _description = json['description'];
  }
  int? _offenceCategoryId;
  String? _description;

  int? get offenceCategoryId => _offenceCategoryId;
  String? get description => _description;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['offenceCategoryId'] = _offenceCategoryId;
    map['description'] = _description;
    return map;
  }
}
