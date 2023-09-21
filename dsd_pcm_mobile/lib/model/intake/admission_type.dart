class AdmissionTypeDto{
    AdmissionTypeDto({
    int? admissionTypeId,
    String? description,
    String? defination,
    String? source,
   
  }) 
  {
    _admissionTypeId = admissionTypeId;
    _description = description;
    _defination = defination;
    _source= source;
 
  }

  AdmissionTypeDto.fromJson(dynamic json) {
    _admissionTypeId = json['admissionTypeId'];
    _description = json['description'];
    _defination = json['defination'];
    _source = json['source'];
   
  }
  int? _admissionTypeId;
  String? _description;
  String? _defination;
  String? _source;

  int? get admissionTypeId => _admissionTypeId;
  String? get description => _description;
  String? get defination => _defination;
  String? get source => _source;
  

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['admissionTypeId'] = _admissionTypeId;
    map['description'] = _description;
    map['defination'] = _defination;
    map['source'] = _source;
    
    return map;
  }
}
