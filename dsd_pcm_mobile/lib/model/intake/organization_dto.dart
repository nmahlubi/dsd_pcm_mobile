class OrganizationDto {
  OrganizationDto({
    int? organizationId,
    String? description,
    String? telephoneNumber,
    String? faxNumber,
    String? emailAddress,
    String? nPONumber,
    int? organisationTypeId,
    String? registrationNumber,
    String? siteCode,
    String? address,
    int? localMunicipalityId,
    bool? isActive,
    bool? isDeleted,
    String? createdBy,
    String? dateCreated,
    String? modifiedBy,
    String? dateLastModified,
  }) {
    _organizationId = organizationId;
    _description = description;
    _telephoneNumber = telephoneNumber;
    _faxNumber = faxNumber;
    _emailAddress = emailAddress;
    _nPONumber = nPONumber;
    _organisationTypeId = organisationTypeId;
    _registrationNumber = registrationNumber;
    _siteCode = siteCode;
    _address = address;
    _localMunicipalityId = localMunicipalityId;
    _isActive = isActive;
    _isDeleted = isDeleted;
    _createdBy = createdBy;
    _dateCreated = dateCreated;
    _modifiedBy = modifiedBy;
    _dateLastModified = dateLastModified;
  }

  OrganizationDto.fromJson(dynamic json) {
    _organizationId = json['organizationId'];
    _description = json['description'];
    _telephoneNumber = json['telephoneNumber'];
    _faxNumber = json['faxNumber'];
    _emailAddress = json['emailAddress'];
    _nPONumber = json['nPONumber'];
    _organisationTypeId = json['organisationTypeId'];
    _registrationNumber = json['registrationNumber'];
    _siteCode = json['siteCode'];
    _address = json['address'];
    _localMunicipalityId = json['localMunicipalityId'];
    _isActive = json['isActive'];
    _isDeleted = json['isDeleted'];
    _createdBy = json['createdBy'];
    _dateCreated = json['dateCreated'];
    _modifiedBy = json['modifiedBy'];
    _dateLastModified = json['dateLastModified'];
  }
  int? _organizationId;
  String? _description;
  String? _telephoneNumber;
  String? _faxNumber;
  String? _emailAddress;
  String? _nPONumber;
  int? _organisationTypeId;
  String? _registrationNumber;
  String? _siteCode;
  String? _address;
  int? _localMunicipalityId;
  bool? _isActive;
  bool? _isDeleted;
  String? _createdBy;
  String? _dateCreated;
  String? _modifiedBy;
  String? _dateLastModified;

  int? get organizationId => _organizationId;
  String? get description => _description;
  String? get telephoneNumber => _telephoneNumber;
  String? get faxNumber => _faxNumber;
  String? get emailAddress => _emailAddress;
  String? get nPONumber => _nPONumber;
  int? get organisationTypeId => _organisationTypeId;
  String? get registrationNumber => _registrationNumber;
  String? get siteCode => _siteCode;
  String? get address => _address;
  int? get localMunicipalityId => _localMunicipalityId;
  bool? get isActive => _isActive;
  bool? get isDeleted => _isDeleted;
  String? get createdBy => _createdBy;
  String? get dateCreated => _dateCreated;
  String? get modifiedBy => _modifiedBy;
  String? get dateLastModified => _dateLastModified;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['organizationId'] = _organizationId;
    map['description'] = _description;
    map['telephoneNumber'] = _telephoneNumber;
    map['faxNumber'] = _faxNumber;
    map['emailAddress'] = _emailAddress;
    map['nPONumber'] = _nPONumber;
    map['organisationTypeId'] = _organisationTypeId;
    map['registrationNumber'] = _registrationNumber;
    map['siteCode'] = _siteCode;
    map['address'] = _address;
    map['localMunicipalityId'] = _localMunicipalityId;
    map['isActive'] = _isActive;
    map['isDeleted'] = _isDeleted;
    map['createdBy'] = _createdBy;
    map['dateCreated'] = _dateCreated;
    map['modifiedBy'] = _modifiedBy;
    map['dateLastModified'] = _dateLastModified;
    return map;
  }
}
