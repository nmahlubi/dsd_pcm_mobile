class RelationshipTypeDto {
  RelationshipTypeDto({
    int? relationshipTypeId,
    String? description,
  }) {
    _relationshipTypeId = relationshipTypeId;
    _description = description;
  }

  RelationshipTypeDto.fromJson(dynamic json) {
    _relationshipTypeId = json['relationshipTypeId'];
    _description = json['description'];
  }
  int? _relationshipTypeId;
  String? _description;

  int? get relationshipTypeId => _relationshipTypeId;
  String? get description => _description;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['relationshipTypeId'] = _relationshipTypeId;
    map['description'] = _description;
    return map;
  }
}
