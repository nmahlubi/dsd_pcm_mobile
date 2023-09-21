class LocalMunicipalityDto {
  LocalMunicipalityDto({
    int? localMunicipalityId,
    int? districtMunicipalityId,
    String? description,
    //DistrictDto? districtDto,
  }) {
    _localMunicipalityId = localMunicipalityId;
    _districtMunicipalityId = districtMunicipalityId;
    _description = description;
    //_districtDto = districtDto;
  }

  LocalMunicipalityDto.fromJson(dynamic json) {
    _localMunicipalityId = json['localMunicipalityId'];
    _districtMunicipalityId = json['districtMunicipalityId'];
    _description = json['description'];
    // _districtDto = json['districtDto'] != null
    //     ? DistrictDto.fromJson(json['districtDto'])
    //     : null;
  }
  int? _localMunicipalityId;
  int? _districtMunicipalityId;
  String? _description;
  //DistrictDto? _districtDto;

  int? get localMunicipalityId => _localMunicipalityId;
  int? get districtMunicipalityId => _districtMunicipalityId;
  String? get description => _description;
  //DistrictDto? get districtDto => _districtDto;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['localMunicipalityId'] = _localMunicipalityId;
    map['districtMunicipalityId'] = _districtMunicipalityId;
    map['description'] = _description;
    // if (_districtDto != null) {
    //   map['districtDto'] = _districtDto?.toJson();
    // }
    return map;
  }
}
