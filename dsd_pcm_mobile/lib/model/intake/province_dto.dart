import 'package:dsd_pcm_mobile/model/child_notification/country_dto.dart';

class ProvinceDto {
  ProvinceDto({
    int? provinceId,
    int? countryId,
    String? description,
    String? abbreviation,
    CountryDto? countryDto,
  }) {
    _provinceId = provinceId;
    _countryId = countryId;
    _description = description;
    _abbreviation = abbreviation;
    _countryDto = countryDto;
  }

  ProvinceDto.fromJson(dynamic json) {
    _provinceId = json['provinceId'];
    _countryId = json['countryId'];
    _description = json['description'];
    _abbreviation = json['abbreviation'];
    _countryDto = json['countryDto'] != null
       ? CountryDto.fromJson(json['countryDto'])
       : null;
  }
  int? _provinceId;
  int? _countryId;
  String? _description;
  String? _abbreviation;
  CountryDto? _countryDto;

  int? get provinceId => _provinceId;
  int? get countryId => _countryId;
  String? get description => _description;
  String? get abbreviation => _abbreviation;
  CountryDto? get countryDto => _countryDto;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['provinceId'] = _provinceId;
    map['countryId'] = _countryId;
    map['description'] = _description;
    map['abbreviation'] = _abbreviation;
   if (_countryDto != null) {
     map['countryDto'] = _countryDto?.toJson();
    }

    return map;
  }
}
