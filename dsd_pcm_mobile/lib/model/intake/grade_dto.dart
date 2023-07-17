class GradeDto {
  GradeDto({
    int? gradeId,
    String? description,
  }) {
    _gradeId = gradeId;
    _description = description;
  }

  GradeDto.fromJson(dynamic json) {
    _gradeId = json['gradeId'];
    _description = json['description'];
  }
  int? _gradeId;
  String? _description;

  int? get gradeId => _gradeId;
  String? get description => _description;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['gradeId'] = _gradeId;
    map['description'] = _description;
    return map;
  }
}
