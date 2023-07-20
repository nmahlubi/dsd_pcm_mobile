class PreliminaryStatusDto {
  PreliminaryStatusDto({
    int? preliminaryStatusId,
    String? description,
    String? defination,
    String? source,
  }) {
    _preliminaryStatusId = preliminaryStatusId;
    _description = description;
    _defination = defination;
    _source = source;
  }

  PreliminaryStatusDto.fromJson(dynamic json) {
    _preliminaryStatusId = json['preliminaryStatusId'];
    _description = json['description'];
    _defination = json['defination'];
    _source = json['source'];
  }
  int? _preliminaryStatusId;
  String? _description;
  String? _defination;
  String? _source;

  int? get preliminaryStatusId => _preliminaryStatusId;
  String? get description => _description;
  String? get definiation => _defination;
  String? get source => _source;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['preliminaryStatusId'] = _preliminaryStatusId;
    map['description'] = _description;
    map['defination'] = _defination;
    map['source'] = _source;
    return map;
  }
}
