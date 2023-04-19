class NotificationCaseDto {
  NotificationCaseDto({
    int? caseInformationId,
    int? notificacationId,
    String? messageRefNumber,
    String? caseStatus,
    String? messageSourceName,
    String? messageSource,
    String? notificationDate,
    String? notificationTypeVersion,
    int? employeeDetailsId,
    String? surname,
    String? firstName,
    String? persalNo,
    String? contactNumber,
    int? policeStationId,
    String? policeStationName,
    String? casNumber,
    int? hoursLeft,
    int? supervisorId,
    int? respondStatus,
    int? sapsInfoId,
    String? policeFullNames,
    String? policeUnitName,
    String? policeOfficerContact,
    String? componentCode,
    String? rankDescription,
    String? poName,
    String? poSurname,
    int? childInformationId,
    String? childName,
    String? childDateOfBirth,
    String? officerAssignedDate,
    String? notificationDateSet,
    String? childNameAbbr,
    String? arrestDate,
    String? arrestTime,
    String? offenseType,
    String? arrestDateFormat,
  }) {
    _caseInformationId = caseInformationId;
    _notificacationId = notificacationId;
    _messageRefNumber = messageRefNumber;
    _caseStatus = caseStatus;
    _messageSourceName = messageSourceName;
    _messageSource = messageSource;
    _notificationDate = notificationDate;
    _notificationTypeVersion = notificationTypeVersion;
    _employeeDetailsId = employeeDetailsId;
    _surname = surname;
    _firstName = firstName;
    _persalNo = persalNo;
    _contactNumber = contactNumber;
    _policeStationId = policeStationId;
    _policeStationName = policeStationName;
    _casNumber = casNumber;
    _hoursLeft = hoursLeft;
    _supervisorId = supervisorId;
    _respondStatus = respondStatus;
    _sapsInfoId = sapsInfoId;
    _policeFullNames = policeFullNames;
    _policeUnitName = policeUnitName;
    _policeOfficerContact = policeOfficerContact;
    _componentCode = componentCode;
    _rankDescription = rankDescription;
    _poName = poName;
    _poSurname = poSurname;
    _childInformationId = childInformationId;
    _childName = childName;
    _childDateOfBirth = childDateOfBirth;
    _officerAssignedDate = officerAssignedDate;
    _childNameAbbr = childNameAbbr;
    _notificationDateSet = notificationDateSet;
    _arrestDate = arrestDate;
    _arrestTime = arrestTime;
    _offenseType = offenseType;
    _arrestDateFormat = arrestDateFormat;
  }

  NotificationCaseDto.fromJson(dynamic json) {
    _caseInformationId = json['caseInformationId'];
    _notificacationId = json['notificacationId'];
    _messageRefNumber = json['messageRefNumber'];
    _caseStatus = json['caseStatus'];
    _messageSourceName = json['messageSourceName'];
    _messageSource = json['messageSource'];
    _notificationDate = json['notificationDate'];
    _notificationTypeVersion = json['notificationTypeVersion'];
    _employeeDetailsId = json['employeeDetailsId'];
    _surname = json['surname'];
    _firstName = json['firstName'];
    _persalNo = json['persalNo'];
    _contactNumber = json['contactNumber'];
    _policeStationId = json['policeStationId'];
    _policeStationName = json['policeStationName'];
    _casNumber = json['casNumber'];
    _hoursLeft = json['hoursLeft'];
    _supervisorId = json['hoursLeft'];
    _respondStatus = json['respondStatus'];
    _sapsInfoId = json['sapsInfoId'];
    _policeFullNames = json['policeFullNames'];
    _policeUnitName = json['policeUnitName'];
    _policeOfficerContact = json['policeOfficerContact'];
    _componentCode = json['componentCode'];
    _rankDescription = json['rankDescription'];
    _poName = json['poName'];
    _poSurname = json['poSurname'];
    _childInformationId = json['childInformationId'];
    _childName = json['childName'];
    _childDateOfBirth = json['childDateOfBirth'];
    _officerAssignedDate = json['officerAssignedDate'];
    _childNameAbbr = json['childNameAbbr'];
    _notificationDateSet = json['notificationDateSet'];
    _arrestDate = json['arrestDate'];
    _arrestTime = json['arrestTime'];
    _offenseType = json['offenseType'];
    _arrestDateFormat = json['arrestDateFormat'];
  }

  int? _caseInformationId;
  int? _notificacationId;
  String? _messageRefNumber;
  String? _caseStatus;
  String? _messageSourceName;
  String? _messageSource;
  String? _notificationDate;
  String? _notificationTypeVersion;
  int? _employeeDetailsId;
  String? _surname;
  String? _firstName;
  String? _persalNo;
  String? _contactNumber;
  int? _policeStationId;
  String? _policeStationName;
  String? _casNumber;
  int? _hoursLeft;
  int? _supervisorId;
  int? _respondStatus;
  int? _sapsInfoId;
  String? _policeFullNames;
  String? _policeUnitName;
  String? _policeOfficerContact;
  String? _componentCode;
  String? _rankDescription;
  String? _poName;
  String? _poSurname;
  int? _childInformationId;
  String? _childName;
  String? _childDateOfBirth;
  String? _officerAssignedDate;
  String? _childNameAbbr;
  String? _notificationDateSet;
  String? _arrestDate;
  String? _arrestTime;
  String? _offenseType;
  String? _arrestDateFormat;

  int? get caseInformationId => _caseInformationId;
  int? get notificacationId => _notificacationId;
  String? get messageRefNumber => _messageRefNumber;
  String? get caseStatus => _caseStatus;
  String? get messageSourceName => _messageSourceName;
  String? get messageSource => _messageSource;
  String? get notificationDate => _notificationDate;
  String? get notificationTypeVersion => _notificationTypeVersion;
  int? get employeeDetailsId => _employeeDetailsId;
  String? get surname => _surname;
  String? get firstName => _firstName;
  String? get persalNo => _persalNo;
  String? get contactNumber => _contactNumber;
  int? get policeStationId => _policeStationId;
  String? get policeStationName => _policeStationName;
  String? get casNumber => _casNumber;
  int? get hoursLeft => _hoursLeft;
  int? get supervisorId => _supervisorId;
  int? get respondStatus => _respondStatus;
  int? get sapsInfoId => _sapsInfoId;
  String? get policeFullNames => _policeFullNames;
  String? get policeUnitName => _policeUnitName;
  String? get policeOfficerContact => _policeOfficerContact;
  String? get componentCode => _componentCode;
  String? get rankDescription => _rankDescription;
  String? get poName => _poName;
  String? get poSurname => _poSurname;
  int? get childInformationId => _childInformationId;
  String? get childName => _childName;
  String? get childDateOfBirth => _childDateOfBirth;
  String? get officerAssignedDate => _officerAssignedDate;
  String? get childNameAbbr => _childNameAbbr;
  String? get notificationDateSet => _notificationDateSet;
  String? get arrestDate => _arrestDate;
  String? get arrestTime => _arrestTime;
  String? get offenseType => _offenseType;
  String? get arrestDateFormat => _arrestDateFormat;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['caseInformationId'] = _caseInformationId;
    map['notificacationId'] = _notificacationId;
    map['messageRefNumber'] = _messageRefNumber;
    map['caseStatus'] = _caseStatus;
    map['messageSourceName'] = _messageSourceName;
    map['messageSource'] = _messageSource;
    map['notificationDate'] = _notificationDate;
    map['notificationTypeVersion'] = _notificationTypeVersion;
    map['employeeDetailsId'] = _employeeDetailsId;
    map['surname'] = _surname;
    map['firstName'] = _firstName;
    map['persalNo'] = _persalNo;
    map['contactNumber'] = _contactNumber;
    map['policeStationId'] = _policeStationId;
    map['policeStationName'] = _policeStationName;
    map['casNumber'] = _casNumber;
    map['hoursLeft'] = _hoursLeft;
    map['supervisorId'] = _supervisorId;
    map['respondStatus'] = _respondStatus;
    map['sapsInfoId'] = _sapsInfoId;
    map['policeFullNames'] = _policeFullNames;
    map['policeUnitName'] = _policeUnitName;
    map['policeOfficerContact'] = _policeOfficerContact;
    map['componentCode'] = _componentCode;
    map['rankDescription'] = _rankDescription;
    map['poName'] = _poName;
    map['poSurname'] = _poSurname;
    map['childInformationId'] = _childInformationId;
    map['childName'] = _childName;
    map['childDateOfBirth'] = _childDateOfBirth;
    map['officerAssignedDate'] = _officerAssignedDate;
    map['childNameAbbr'] = _childNameAbbr;
    map['notificationDateSet'] = _notificationDateSet;
    map['arrestDate'] = _arrestDate;
    map['arrestTime'] = _arrestTime;
    map['offenseType'] = _offenseType;
    map['arrestDateFormat'] = _arrestDateFormat;
    return map;
  }
}
