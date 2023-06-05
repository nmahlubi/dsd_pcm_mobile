class YesNoDto {
  YesNoDto({
    String? value,
    String? description,
  }) {
    _value = value;
    _description = description;
  }

  YesNoDto.fromJson(dynamic json) {
    _value = json['value'];
    _description = json['description'];
  }
  String? _value;
  String? _description;

  String? get value => _value;
  String? get description => _description;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['value'] = _value;
    map['description'] = _description;
    return map;
  }
}
