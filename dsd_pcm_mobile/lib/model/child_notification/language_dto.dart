class LanguageDto {
  LanguageDto({
    int? personLanguageCodeId,
    String? personLanguage,
    String? personLanguageCode,
  }) {
    _personLanguageCodeId = personLanguageCodeId;
    _personLanguage = personLanguage;
    _personLanguageCode = personLanguageCode;
  }

  LanguageDto.fromJson(dynamic json) {
    _personLanguageCodeId = json['personLanguageCodeId'];
    _personLanguage = json['personLanguage'];
    _personLanguageCode = json['personLanguageCode'];
  }

  int? _personLanguageCodeId;
  String? _personLanguage;
  String? _personLanguageCode;

  int? get personLanguageCodeId => _personLanguageCodeId;
  String? get personLanguage => _personLanguage;
  String? get personLanguageCode => _personLanguageCode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['personLanguageCodeId'] = _personLanguageCodeId;
    map['personLanguage'] = _personLanguage;
    map['personLanguageCode'] = _personLanguageCode;
    return map;
  }
}
