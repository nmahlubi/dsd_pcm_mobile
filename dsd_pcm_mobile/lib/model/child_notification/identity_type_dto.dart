class IdentityTypeDto {
  IdentityTypeDto({
    int? identityTypeId,
    String? identityDescrip,
  }) {
    _identityTypeId = identityTypeId;
    _identityDescrip = identityDescrip;
  }

  IdentityTypeDto.fromJson(dynamic json) {
    _identityTypeId = json['identityTypeId'];
    _identityDescrip = json['identityDescrip'];
  }

  int? _identityTypeId;
  String? _identityDescrip;

  int? get identityTypeId => _identityTypeId;
  String? get identityDescrip => _identityDescrip;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['identityTypeId'] = _identityTypeId;
    map['identityDescrip'] = _identityDescrip;
    return map;
  }
}
