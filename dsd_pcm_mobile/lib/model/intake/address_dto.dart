class AddressDto {
  AddressDto({
    int? addressId,
    int? addressTypeId,
    String? addressLine1,
    String? addressLine2,
    int? townId,
    String? postalCode,
    String? addressType,
  }) {
    _addressId = addressId;
    _addressTypeId = addressTypeId;
    _addressLine1 = addressLine1;
    _addressLine2 = addressLine2;
    _townId = townId;
    _postalCode = postalCode;
    _addressType = addressType;
  }

  AddressDto.fromJson(dynamic json) {
    _addressId = json['addressId'];
    _addressTypeId = json['addressTypeId'];
    _addressLine1 = json['addressLine1'];
    _addressLine2 = json['addressLine2'];
    _townId = json['townId'];
    _postalCode = json['postalCode'];
    _addressType = json['addressType'];
  }
  int? _addressId;
  int? _addressTypeId;
  String? _addressLine1;
  String? _addressLine2;
  int? _townId;
  String? _postalCode;
  String? _addressType;

  int? get addressId => _addressId;
  int? get addressTypeId => _addressTypeId;
  String? get addressLine1 => _addressLine1;
  String? get addressLine2 => _addressLine2;
  int? get townId => _townId;
  String? get postalCode => _postalCode;
  String? get addressType => _addressType;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['addressId'] = addressId;
    map['addressTypeId'] = addressTypeId;
    map['addressLine1'] = addressLine1;
    map['addressLine2'] = addressLine2;
    map['townId'] = townId;
    map['postalCode'] = postalCode;
    map['addressType'] = addressType;
    return map;
  }
}
