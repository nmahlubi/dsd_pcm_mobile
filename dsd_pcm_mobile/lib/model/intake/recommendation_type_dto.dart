class RecommendationTypeDto {
  RecommendationTypeDto({
    int? recommendationTypeId,
    String? description,
  }) {
    _recommendationTypeId = recommendationTypeId;
    _description = description;
  }

  RecommendationTypeDto.fromJson(dynamic json) {
    _recommendationTypeId = json['recommendationTypeId'];
    _description = json['description'];
  }
  int? _recommendationTypeId;
  String? _description;

  int? get recommendationTypeId => _recommendationTypeId;
  String? get description => _description;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['recommendationTypeId'] = _recommendationTypeId;
    map['description'] = _description;
    return map;
  }
}
