import '../intake/person_dto.dart';
import '../intake/relationship_type_dto.dart';

class FamilyMemberDto {
  FamilyMemberDto({
    int? familyMemberId,
    int? intakeAssessmentId,
    int? personId,
    int? relationshipTypeId,
    int? createdBy,
    String? dateCreated,
    RelationshipTypeDto? relationshipTypeDto,
    PersonDto? personDto,
  }) {
    _familyMemberId = familyMemberId;
    _intakeAssessmentId = intakeAssessmentId;
    _personId = personId;
    _relationshipTypeId = relationshipTypeId;
    _createdBy = createdBy;
    _dateCreated = dateCreated;
    _relationshipTypeDto = relationshipTypeDto;
    _personDto = personDto;
  }

  FamilyMemberDto.fromJson(dynamic json) {
    _familyMemberId = json['familyMemberId'];
    _intakeAssessmentId = json['intakeAssessmentId'];
    _personId = json['personId'];
    _relationshipTypeId = json['relationshipTypeId'];
    _createdBy = json['createdBy'];
    _dateCreated = json['dateCreated'];
    _relationshipTypeDto = json['relationshipTypeDto'] != null
        ? RelationshipTypeDto.fromJson(json['relationshipTypeDto'])
        : null;
    _personDto = json['personDto'] != null
        ? PersonDto.fromJson(json['personDto'])
        : null;
  }
  int? _familyMemberId;
  int? _intakeAssessmentId;
  int? _personId;
  int? _relationshipTypeId;
  int? _createdBy;
  String? _dateCreated;
  RelationshipTypeDto? _relationshipTypeDto;
  PersonDto? _personDto;

  int? get familyMemberId => _familyMemberId;
  int? get intakeAssessmentId => _intakeAssessmentId;
  int? get personId => _personId;
  int? get relationshipTypeId => _relationshipTypeId;
  int? get createdBy => _createdBy;
  String? get dateCreated => _dateCreated;
  RelationshipTypeDto? get relationshipTypeDto => _relationshipTypeDto;
  PersonDto? get personDto => _personDto;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['familyMemberId'] = _familyMemberId;
    map['intakeAssessmentId'] = _intakeAssessmentId;
    map['personId'] = _personId;
    map['relationshipTypeId'] = _relationshipTypeId;
    map['createdBy'] = _createdBy;
    map['dateCreated'] = _dateCreated;
    if (_relationshipTypeDto != null) {
      map['relationshipTypeDto'] = _relationshipTypeDto?.toJson();
    }
    if (_personDto != null) {
      map['personDto'] = _personDto?.toJson();
    }
    return map;
  }
}
