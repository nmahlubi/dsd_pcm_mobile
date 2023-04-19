class CountryDto {
  CountryDto({
    int? countyId,
    String? countryName,
    String? countryCode,
  }) {
    _countyId = countyId;
    _countryName = countryName;
    _countryCode = countryCode;
  }

  CountryDto.fromJson(dynamic json) {
    _countyId = json['countyId'];
    _countryName = json['countryName'];
    _countryCode = json['countryCode'];
  }

  int? _countyId;
  String? _countryName;
  String? _countryCode;

  int? get countyId => _countyId;
  String? get countryName => _countryName;
  String? get countryCode => _countryCode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['countyId'] = _countyId;
    map['countryName'] = _countryName;
    map['countryCode'] = _countryCode;
    return map;
  }
}
