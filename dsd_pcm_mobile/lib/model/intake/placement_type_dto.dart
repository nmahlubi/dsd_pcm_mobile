class PlacementTypeDto {
  PlacementTypeDto({
    int? placementTypeId,
    String? description,
  }) {
    _placementTypeId = placementTypeId;
    _description = description;
  }

  PlacementTypeDto.fromJson(dynamic json) {
    _placementTypeId = json['placementTypeId'];
    _description = json['description'];
  }
  int? _placementTypeId;
  String? _description;

  int? get placementTypeId => _placementTypeId;
  String? get description => _description;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['placementTypeId'] = _placementTypeId;
    map['description'] = _description;
    return map;
  }
}
