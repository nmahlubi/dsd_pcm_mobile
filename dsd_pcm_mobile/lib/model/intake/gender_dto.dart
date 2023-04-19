class GenderDto {
  GenderDto({
    int? genderId,
    String? description,
  }) {
    _genderId = genderId;
    _description = description;
  }

  GenderDto.fromJson(dynamic json) {
    _genderId = json['genderId'];
    _description = json['description'];
  }
  int? _genderId;
  String? _description;

  int? get genderId => _genderId;
  String? get description => _description;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['genderId'] = _genderId;
    map['description'] = _description;
    return map;
  }
}
