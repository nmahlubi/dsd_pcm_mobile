import 'police_station_dto.dart';

class SapsInfoDto {
  SapsInfoDto({
    String? policeFullName,
    String? contactDetailsText,
    String? policeUnitName,
    String? componentCode,
    PoliceStationDto? policeStationDto,
  }) {
    _policeFullName = policeFullName;
    _contactDetailsText = contactDetailsText;
    _policeUnitName = policeUnitName;
    _componentCode = componentCode;
    _policeStationDto = policeStationDto;
  }

  SapsInfoDto.fromJson(dynamic json) {
    _policeFullName = json['policeFullName'];
    _contactDetailsText = json['contactDetailsText'];
    _policeUnitName = json['policeUnitName'];
    _componentCode = json['componentCode'];
    _policeStationDto = json['policeStationDto'] != null
        ? PoliceStationDto.fromJson(json['policeStationDto'])
        : null;
  }

  String? _policeFullName;
  String? _contactDetailsText;
  String? _policeUnitName;
  String? _componentCode;
  PoliceStationDto? _policeStationDto;

  String? get policeFullName => _policeFullName;
  String? get contactDetailsText => _contactDetailsText;
  String? get policeUnitName => _policeUnitName;
  String? get componentCode => _componentCode;
  PoliceStationDto? get policeStationDto => _policeStationDto;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['policeFullName'] = _policeFullName;
    map['contactDetailsText'] = _contactDetailsText;
    map['policeUnitName'] = _policeUnitName;
    map['componentCode'] = _componentCode;
    if (_policeStationDto != null) {
      map['policeStationDto'] = _policeStationDto?.toJson();
    }
    return map;
  }
}
