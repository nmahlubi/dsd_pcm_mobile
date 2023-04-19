class GenderDto {
  GenderDto({
    int? personGenderCodeID,
    String? personGender,
    String? personGenderCode,
  }) {
    _personGenderCodeID = personGenderCodeID;
    _personGender = personGender;
    _personGenderCode = personGenderCode;
  }

  GenderDto.fromJson(dynamic json) {
    _personGenderCodeID = json['personGenderCodeID'];
    _personGender = json['personGender'];
    _personGenderCode = json['personGenderCode'];
  }

  int? _personGenderCodeID;
  String? _personGender;
  String? _personGenderCode;

  int? get personGenderCodeID => _personGenderCodeID;
  String? get personGender => _personGender;
  String? get personGenderCode => _personGenderCode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['personGenderCodeID'] = _personGenderCodeID;
    map['personGender'] = _personGender;
    map['personGenderCode'] = _personGenderCode;
    return map;
  }
}
