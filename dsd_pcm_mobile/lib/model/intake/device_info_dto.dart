class DeviceInfoDto {
  DeviceInfoDto({
    String? deviceId,
    String? model,
  }) {
    _deviceId = deviceId;
    _model = model;
  }

  DeviceInfoDto.fromJson(dynamic json) {
    _deviceId = json['deviceId'];
    _model = json['model'];
  }
  String? _deviceId;
  String? _model;

  String? get deviceId => _deviceId;
  String? get model => _model;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['deviceId'] = _deviceId;
    map['model'] = _model;
    return map;
  }
}
