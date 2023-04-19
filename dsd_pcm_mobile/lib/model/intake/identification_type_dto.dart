class IdentificationTypeDto {
  IdentificationTypeDto({
    int? identificationTypeId,
    String? description,
  }) {
    _identificationTypeId = identificationTypeId;
    _description = description;
  }

  IdentificationTypeDto.fromJson(dynamic json) {
    _identificationTypeId = json['identificationTypeId'];
    _description = json['description'];
  }
  int? _identificationTypeId;
  String? _description;

  int? get identificationTypeId => _identificationTypeId;
  String? get description => _description;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['identificationTypeId'] = _identificationTypeId;
    map['description'] = _description;
    return map;
  }
}
