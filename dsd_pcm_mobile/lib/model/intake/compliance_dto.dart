class ComplianceDto{
    ComplianceDto({
    int? complianceId,
    String? description,
    String? defination,
    String? source,
   
  }) 
  {
    _complianceId = complianceId;
    _description = description;
    _defination = defination;
    _source= source;
 
  }

  ComplianceDto.fromJson(dynamic json) {
    _complianceId = json['complianceId'];
    _description = json['description'];
    _defination = json['defination'];
    _source = json['source'];
   
  }
  int? _complianceId;
  String? _description;
  String? _defination;
  String? _source;

  int? get complianceId => _complianceId;
  String? get description => _description;
  String? get defination => _defination;
  String? get source => _source;
  

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['complianceId'] = _complianceId;
    map['description'] = _description;
    map['defination'] = _defination;
    map['source'] = _source;
    
    return map;
  }
}
