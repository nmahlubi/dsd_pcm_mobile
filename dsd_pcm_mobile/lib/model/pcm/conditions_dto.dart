class ConditionsDto {
  ConditionsDto({
    int? conditionsId,
    String? description,
    String? source,
    String? definition,
  }) {
    _conditionsId = conditionsId;
    _description = description;
    _source = source;
    _definition = definition;
  }

  ConditionsDto.fromJson(dynamic json) {
    _conditionsId = json['conditionsId'];
    _description = json['description'];
    _source = json['source'];
    _definition = json['definition'];
  }

  int? _conditionsId;
  String? _description;
  String? _source;
  String? _definition;

  int? get conditionsId => _conditionsId;
  String? get description => _description;
  String? get source => _source;
  String? get definition => _definition;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['conditionsId'] = _conditionsId;
    map['description'] = _description;
    map['source'] = _source;
    map['definition'] = _definition;

    return map;
  }
}
