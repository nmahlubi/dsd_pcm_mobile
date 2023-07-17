import 'school_type_dto.dart';

class SchoolDto {
  SchoolDto({
    int? schoolId,
    int? schoolTypeId,
    String? schoolName,
    String? contactPerson,
    String? telephoneNumber,
    String? cellphoneNumber,
    String? faxNumber,
    String? emailAddress,
    String? dateCreated,
    String? createdBy,
    String? dateLastModified,
    String? modifiedBy,
    bool? isActive,
    bool? isDeleted,
    String? natEmis,
    SchoolTypeDto? schoolTypeDto,
  }) {
    _schoolId = schoolId;
    _schoolTypeId = schoolTypeId;
    _schoolName = schoolName;
    _contactPerson = contactPerson;
    _telephoneNumber = telephoneNumber;
    _cellphoneNumber = cellphoneNumber;
    _faxNumber = faxNumber;
    _emailAddress = emailAddress;
    _dateCreated = dateCreated;
    _createdBy = createdBy;
    _dateLastModified = dateLastModified;
    _modifiedBy = modifiedBy;
    _isActive = isActive;
    _isDeleted = isDeleted;
    _natEmis = natEmis;
    _schoolTypeDto = schoolTypeDto;
  }

  SchoolDto.fromJson(dynamic json) {
    _schoolId = json['schoolId'];
    _schoolTypeId = json['schoolTypeId'];
    _schoolName = json['schoolName'];
    _contactPerson = json['contactPerson'];
    _telephoneNumber = json['telephoneNumber'];
    _cellphoneNumber = json['cellphoneNumber'];
    _faxNumber = json['faxNumber'];
    _emailAddress = json['emailAddress'];
    _dateCreated = json['dateCreated'];
    _createdBy = json['createdBy'];
    _dateLastModified = json['dateLastModified'];
    _modifiedBy = json['modifiedBy'];
    _isActive = json['isActive'];
    _isDeleted = json['isDeleted'];
    _natEmis = json['natEmis'];
    _schoolTypeDto = json['schoolTypeDto'] != null
        ? SchoolTypeDto.fromJson(json['schoolTypeDto'])
        : null;
  }
  int? _schoolId;
  int? _schoolTypeId;
  String? _schoolName;
  String? _contactPerson;
  String? _telephoneNumber;
  String? _cellphoneNumber;
  String? _faxNumber;
  String? _emailAddress;
  String? _dateCreated;
  String? _createdBy;
  String? _dateLastModified;
  String? _modifiedBy;
  bool? _isActive;
  bool? _isDeleted;
  String? _natEmis;
  SchoolTypeDto? _schoolTypeDto;

  int? get schoolId => _schoolId;
  int? get schoolTypeId => _schoolTypeId;
  String? get schoolName => _schoolName;
  String? get contactPerson => _contactPerson;
  String? get telephoneNumber => _telephoneNumber;
  String? get cellphoneNumber => _cellphoneNumber;
  String? get faxNumber => _faxNumber;
  String? get emailAddress => _emailAddress;
  String? get dateCreated => _dateCreated;
  String? get createdBy => _createdBy;
  String? get dateLastModified => _dateLastModified;
  String? get modifiedBy => _modifiedBy;
  bool? get isActive => _isActive;
  bool? get isDeleted => _isDeleted;
  String? get natEmis => _natEmis;
  SchoolTypeDto? get schoolTypeDto => _schoolTypeDto;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    map['schoolId'] = _schoolId;
    map['schoolTypeId'] = _schoolTypeId;
    map['schoolName'] = _schoolName;
    map['contactPerson'] = _contactPerson;
    map['telephoneNumber'] = _telephoneNumber;
    map['cellphoneNumber'] = _cellphoneNumber;
    map['faxNumber'] = _faxNumber;
    map['emailAddress'] = _emailAddress;
    map['dateCreated'] = _dateCreated;
    map['createdBy'] = _createdBy;
    map['dateLastModified'] = _dateLastModified;
    map['modifiedBy'] = _modifiedBy;
    map['isActive'] = _isActive;
    map['isDeleted'] = _isDeleted;
    map['natEmis'] = _natEmis;
    if (_schoolTypeDto != null) {
      map['schoolTypeDto'] = _schoolTypeDto?.toJson();
    }
    return map;
  }
}
