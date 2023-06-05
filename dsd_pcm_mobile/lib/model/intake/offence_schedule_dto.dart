class OffenceScheduleDto {
  OffenceScheduleDto({
    int? offenceScheduleId,
    String? description,
  }) {
    _offenceScheduleId = offenceScheduleId;
    _description = description;
  }

  OffenceScheduleDto.fromJson(dynamic json) {
    _offenceScheduleId = json['offenceScheduleId'];
    _description = json['description'];
  }
  int? _offenceScheduleId;
  String? _description;

  int? get offenceScheduleId => _offenceScheduleId;
  String? get description => _description;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['offenceScheduleId'] = _offenceScheduleId;
    map['description'] = _description;
    return map;
  }
}
