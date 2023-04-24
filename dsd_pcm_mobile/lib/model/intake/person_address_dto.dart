import 'address_dto.dart';

class PersonAddressDto {
  PersonAddressDto({
    int? personId,
    int? addressId,
    AddressDto? addressDto,
  }) {
    _personId = personId;
    _addressId = addressId;
    _addressDto = addressDto;
  }

  PersonAddressDto.fromJson(dynamic json) {
    _personId = json['personId'];
    _addressId = json['addressId'];
    _addressDto = json['addressDto'] != null
        ? AddressDto.fromJson(json['addressDto'])
        : null;
  }
  int? _personId;
  int? _addressId;
  AddressDto? _addressDto;

  int? get personId => _personId;
  int? get addressId => _addressId;
  AddressDto? get addressDto => _addressDto;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['personId'] = _personId;
    map['addressId'] = _addressId;
    if (_addressDto != null) {
      map['addressDto'] = _addressDto?.toJson();
    }
    return map;
  }
}
