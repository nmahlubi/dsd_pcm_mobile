class PcmOrderDto {
  PcmOrderDto({
    int? recomendationOrderId,
    String? description,
    String? definition,
    String? source,
  }) {
    _recomendationOrderId = recomendationOrderId;
    _description = description;
    _defination = definition;
    _source = source;
  }

  PcmOrderDto.fromJson(dynamic json) {
    _recomendationOrderId = json['recomendationOrderId'];
    _description = json['description'];
    _defination = json['definition'];
    _source = json['source'];
  }
  int? _recomendationOrderId;
  String? _description;
  String? _defination;
  String? _source;

  int? get recomendationOrderId => _recomendationOrderId;
  String? get description => _description;
  String? get definition => _defination;
  String? get source => _source;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['recomendationOrderId'] = _recomendationOrderId;
    map['description'] = _description;
    map['definition'] = _defination;
    map['source'] = _source;

    return map;
  }
}
