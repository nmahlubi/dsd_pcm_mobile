import 'package:dsd_pcm_mobile/model/intake/province_dto.dart';

class DistrictDto {
  DistrictDto({
    int? districtId,
    int? provinceId,
    String? description,
    ProvinceDto? provinceDto,
  }) {
    _districtId = districtId;
    _provinceId = provinceId;
    _description = description;
    _provinceDto = provinceDto;
  }

  DistrictDto.fromJson(dynamic json) {
    _districtId = json['districtId'];
    _provinceId = json['provinceId'];
    _description = json['description'];
    _provinceDto = json['provinceDto'] != null
        ? ProvinceDto.fromJson(json['provinceDto'])
        : null;
  }
  int? _districtId;
  int? _provinceId;
  String? _description;
  ProvinceDto? _provinceDto;

  int? get districtId => _districtId;
  int? get provinceId => _provinceId;
  String? get description => _description;
  ProvinceDto? get provinceDto => _provinceDto;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['districtId'] = _districtId;
    map['provinceId'] = _provinceId;
    map['description'] = _description;
    if (_provinceDto != null) {
      map['provinceDto'] = _provinceDto?.toJson();
    }
    return map;
  }
}
