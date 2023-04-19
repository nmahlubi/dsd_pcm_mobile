class LanguageDto {
  LanguageDto({
    int? languageId,
    String? description,
  }) {
    _languageId = languageId;
    _description = description;
  }

  LanguageDto.fromJson(dynamic json) {
    _languageId = json['languageId'];
    _description = json['description'];
  }
  int? _languageId;
  String? _description;

  int? get languageId => _languageId;
  String? get description => _description;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['languageId'] = _languageId;
    map['description'] = _description;
    return map;
  }
}
