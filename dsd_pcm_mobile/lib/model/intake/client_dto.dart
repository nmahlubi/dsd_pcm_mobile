import 'package:dsd_pcm_mobile/model/intake/person_dto.dart';

class ClientDto {
  ClientDto({
    int? clientId,
    int? personId,
    String? referenceNumber,
    String? createdBy,
    String? modifiedBy,
    String? dateCreated,
    String? dateLastModified,
    bool? isActive,
    bool? isDeleted,
    PersonDto? personDto,
  }) {
    _districtId = clientId;
    _personId = personId;
    _referenceNumber = referenceNumber;
    _createdBy = createdBy;
    _modifiedBy = modifiedBy;
    _dateCreated = dateCreated;
    _isActive = isActive;
    _isDeleted = isDeleted;
    _dateLastModified = dateLastModified;
    _personDto = personDto;
  }

  ClientDto.fromJson(dynamic json) {
    _districtId = json['clientId'];
    _personId = json['personId'];
    _referenceNumber = json['referenceNumber'];
    _createdBy = json['createdBy'];
    _modifiedBy = json['modifiedBy'];
    _dateCreated = json['dateCreated'];
    _modifiedBy = json['modifiedBy'];
    _isActive = json['isActive'];
    _isDeleted = json['isDeleted'];
    _personDto = json['personDto'] != null
        ? PersonDto.fromJson(json['personDto'])
        : null;
  }
  int? _districtId;
  int? _personId;
  String? _referenceNumber;
  String? _createdBy;
  String? _modifiedBy;
  String? _dateCreated;
  String? _dateLastModified;
  bool? _isActive;
  bool? _isDeleted;
  PersonDto? _personDto;

  int? get clientId => _districtId;
  int? get personId => _personId;
  String? get referenceNumber => _referenceNumber;
  String? get createdBy => _createdBy;
  String? get modifiedBy => _modifiedBy;
  String? get dateCreated => _dateCreated;
  String? get dateLastModified => _dateLastModified;
  bool? get isActive => _isActive;
  bool? get isDeleted => _isDeleted;
  PersonDto? get personDto => _personDto;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['clientId'] = _districtId;
    map['personId'] = _personId;
    map['referenceNumber'] = _referenceNumber;
    map['createdBy'] = _createdBy;
    map['modifiedBy'] = _modifiedBy;
    map['dateCreated'] = _dateCreated;
    map['dateLastModified'] = _dateLastModified;
    map['isActive'] = _isActive;
    map['isDeleted'] = _isDeleted;
    if (_personDto != null) {
      map['personDto'] = _personDto?.toJson();
    }
    return map;
  }
}
