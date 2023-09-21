class OrganizationTypeDto {
  OrganizationTypeDto({
    int? organizationTypeId,
    String? description,
  }) {
    _organizationTypeId = organizationTypeId;
    _description = description;
  }

  OrganizationTypeDto.fromJson(dynamic json) {
    _organizationTypeId = json['organizationTypeId'];
    _description = json['description'];
  }
  int? _organizationTypeId;
  String? _description;

  int? get organizationTypeId => _organizationTypeId;
  String? get description => _description;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['organizationTypeId'] = _organizationTypeId;
    map['description'] = _description;
    return map;
  }
}
