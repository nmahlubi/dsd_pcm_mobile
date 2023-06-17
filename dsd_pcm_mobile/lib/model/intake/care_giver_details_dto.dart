import 'person_dto.dart';
import 'relationship_type_dto.dart';

class CareGiverDetailsDto {
  CareGiverDetailsDto({
    int? clientCaregiverId,
    int? clientId,
    int? personId,
    int? relationshipTypeId,
    String? createdBy,
    String? dateCreated,
    String? modifiedBy,
    String? dateModified,
    RelationshipTypeDto? relationshipTypeDto,
    PersonDto? personDto,
  }) {
    _clientCaregiverId = clientCaregiverId;
    _clientId = clientId;
    _personId = personId;
    _relationshipTypeId = relationshipTypeId;
    _createdBy = createdBy;
    _dateCreated = dateCreated;
    _modifiedBy = modifiedBy;
    _dateModified = dateModified;
    _relationshipTypeDto = relationshipTypeDto;
    _personDto = personDto;
  }
  CareGiverDetailsDto.fromJson(dynamic json) {
    _clientCaregiverId = json['clientCaregiverId'];
    _clientId = json['clientId'];
    _personId = json['personId'];
    _relationshipTypeId = json['relationshipTypeId'];
    _createdBy = json['createdBy'];
    _dateCreated = json['dateCreated'];
    _modifiedBy = json['modifiedBy'];
    _dateModified = json['dateModified'];
    _relationshipTypeDto = json['relationshipTypeDto'] != null
        ? RelationshipTypeDto.fromJson(json['relationshipTypeDto'])
        : null;
    _personDto = json['personDto'] != null
        ? PersonDto.fromJson(json['personDto'])
        : null;
  }
  int? _clientCaregiverId;
  int? _clientId;
  int? _personId;
  int? _relationshipTypeId;
  String? _createdBy;
  String? _dateCreated;
  String? _modifiedBy;
  String? _dateModified;
  RelationshipTypeDto? _relationshipTypeDto;
  PersonDto? _personDto;

  int? get clientCaregiverId => _clientCaregiverId;
  int? get clientId => _clientId;
  int? get personId => _personId;
  int? get relationshipTypeId => _relationshipTypeId;
  String? get createdBy => _createdBy;
  String? get dateCreated => _dateCreated;
  String? get modifiedBy => _modifiedBy;
  String? get dateModified => _dateModified;
  RelationshipTypeDto? get relationshipTypeDto => _relationshipTypeDto;
  PersonDto? get personDto => _personDto;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['clientCaregiverId'] = _clientCaregiverId;
    map['clientId'] = _clientId;
    map['personId'] = _personId;
    map['relationshipTypeId'] = relationshipTypeId;
    map['createdBy'] = _createdBy;
    map['dateCreated'] = _dateCreated;
    map['modifiedBy'] = _modifiedBy;
    map['dateModified'] = _dateModified;
    if (_relationshipTypeDto != null) {
      map['relationshipTypeDto'] = _relationshipTypeDto?.toJson();
    }
    if (_personDto != null) {
      map['personDto'] = _personDto?.toJson();
    }
    return map;
  }
}
