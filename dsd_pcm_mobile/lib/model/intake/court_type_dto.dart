class CourtTypeDto{
    CourtTypeDto({
    int? courtTypeId,
    String? description,
    String? defination,
    String? source,
   
  }) 
  {
    _courtTypeId = courtTypeId;
    _description = description;
    _defination = defination;
    _source= source;
 
  }

  CourtTypeDto.fromJson(dynamic json) {
    _courtTypeId = json['courtTypeId'];
    _description = json['description'];
    _defination = json['defination'];
    _source = json['source'];
   
  }
  int? _courtTypeId;
  String? _description;
  String? _defination;
  String? _source;

  int? get courtTypeId => _courtTypeId;
  String? get description => _description;
  String? get defination => _defination;
  String? get source => _source;
  

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['courtTypeId'] = _courtTypeId;
    map['description'] = _description;
    map['defination'] = _defination;
    map['source'] = _source;
    
    return map;
  }
}
