class PcmCountryDto{
    PcmCountryDto({
    int? countryId,
    String? description,
   
  }) 
  {
    _countryId = countryId;
    _description = description;
 
  }

  PcmCountryDto.fromJson(dynamic json) {
    _countryId = json['countryId'];
    _description = json['description'];
   
  }
  int? _countryId;
  String? _description;

  int? get countryId => _countryId;
  String? get description => _description;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['countryId'] = _countryId;
    map['description'] = _description;
    
    return map;
  }
}
