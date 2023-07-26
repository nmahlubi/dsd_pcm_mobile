class ConditionsDto {
  ConditionsDto({
    int? conditionsId,
    String? conditions,
    
  }) {
    _conditionsId = conditionsId;
    _conditions = conditions;
  
  }

  ConditionsDto.fromJson(dynamic json) {
    _conditionsId = json['conditionsId'];
    _conditions = json['conditions'];
    
  }

  int? _conditionsId;
  String? _conditions;
 

  int? get conditionsId => _conditionsId;
  String? get conditions => _conditions;


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['conditionsId'] = _conditionsId;
    map['conditions'] = _conditions;
  
    return map;
  }
}
