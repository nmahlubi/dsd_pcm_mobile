class AddressTypeDto {
  AddressTypeDto({
    int? addressTypeId,
    String? description,
  }) {
    _addressTypeId = addressTypeId;
    _description = description;
  }

  AddressTypeDto.fromJson(dynamic json) {
    _addressTypeId = json['addressTypeId'];
    _description = json['description'];
  }
  int? _addressTypeId;
  String? _description;

  int? get addressTypeId => _addressTypeId;
  String? get description => _description;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['addressTypeId'] = _addressTypeId;
    map['description'] = _description;
    return map;
  }
}
