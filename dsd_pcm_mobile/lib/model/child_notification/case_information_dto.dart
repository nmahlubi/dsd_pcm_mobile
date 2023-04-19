import 'child_information_dto.dart';
import 'saps_info_dto.dart';

class CaseInformationDto {
  CaseInformationDto({
    int? caseInformationId,
    String? casNumber,
    int? sapsInfoId,
    String? arrestDate,
    String? arrestTime,
    int? childInformationId,
    int? probationOfficerInformationId,
    String? probationOfficerEstimatedArrivalTime,
    String? probationOfficerContactTypeId,
    String? probationOfficerAllocatedDate,
    String? timeAssigned,
    int? notificacationId,
    String? offenseType,
    int? hoursLeft,
    String? notificationDateSet,
    String? arrestDateFormat,
    ChildInformationDto? childInformationDto,
    SapsInfoDto? sapsInfoDto,
  }) {
    _caseInformationId = caseInformationId;
    _casNumber = casNumber;
    _sapsInfoId = sapsInfoId;
    _arrestDate = arrestDate;
    _arrestTime = arrestTime;
    _childInformationId = childInformationId;
    _probationOfficerInformationId = probationOfficerInformationId;
    _probationOfficerEstimatedArrivalTime =
        probationOfficerEstimatedArrivalTime;
    _probationOfficerContactTypeId = probationOfficerContactTypeId;
    _probationOfficerAllocatedDate = probationOfficerAllocatedDate;
    _timeAssigned = timeAssigned;
    _notificacationId = notificacationId;
    _offenseType = offenseType;
    _hoursLeft = hoursLeft;
    _notificationDateSet = notificationDateSet;
    _arrestDateFormat = arrestDateFormat;
    _childInformationDto = childInformationDto;
    _sapsInfoDto = sapsInfoDto;
  }

  CaseInformationDto.fromJson(dynamic json) {
    _caseInformationId = json['caseInformationId'];
    _casNumber = json['casNumber'];
    _sapsInfoId = json['sapsInfoId'];
    _arrestDate = json['arrestDate'];
    _arrestTime = json['arrestTime'];
    _childInformationId = json['childInformationId'];
    _probationOfficerInformationId = json['probationOfficerInformationId'];
    _probationOfficerEstimatedArrivalTime =
        json['probationOfficerEstimatedArrivalTime'];
    _probationOfficerContactTypeId = json['probationOfficerContactTypeId'];
    _probationOfficerAllocatedDate = json['probationOfficerAllocatedDate'];
    _timeAssigned = json['timeAssigned'];
    _notificacationId = json['notificacationId'];
    _offenseType = json['offenseType'];
    _hoursLeft = json['hoursLeft'];
    _notificationDateSet = json['notificationDateSet'];
    _arrestDateFormat = json['arrestDateFormat'];
    _childInformationDto = json['childInformationDto'] != null
        ? ChildInformationDto.fromJson(json['childInformationDto'])
        : null;
    _sapsInfoDto = json['sapsInfoDto'] != null
        ? SapsInfoDto.fromJson(json['sapsInfoDto'])
        : null;
  }
  int? _caseInformationId;
  String? _casNumber;
  int? _sapsInfoId;
  String? _arrestDate;
  String? _arrestTime;
  int? _childInformationId;
  int? _probationOfficerInformationId;
  String? _probationOfficerEstimatedArrivalTime;
  String? _probationOfficerContactTypeId;
  String? _probationOfficerAllocatedDate;
  String? _timeAssigned;
  int? _notificacationId;
  String? _offenseType;
  int? _hoursLeft;
  String? _notificationDateSet;
  String? _arrestDateFormat;
  ChildInformationDto? _childInformationDto;
  SapsInfoDto? _sapsInfoDto;

  int? get caseInformationId => _caseInformationId;
  String? get casNumber => _casNumber;
  int? get sapsInfoId => _sapsInfoId;
  String? get arrestDate => _arrestDate;
  String? get arrestTime => _arrestTime;
  int? get childInformationId => _childInformationId;
  int? get probationOfficerInformationId => _probationOfficerInformationId;
  String? get probationOfficerEstimatedArrivalTime =>
      _probationOfficerEstimatedArrivalTime;
  String? get probationOfficerContactTypeId => _probationOfficerContactTypeId;
  String? get probationOfficerAllocatedDate => _probationOfficerAllocatedDate;
  String? get timeAssigned => _timeAssigned;
  int? get notificacationId => _notificacationId;
  String? get offenseType => _offenseType;
  int? get hoursLeft => _hoursLeft;
  String? get notificationDateSet => _notificationDateSet;
  String? get arrestDateFormat => _arrestDateFormat;
  ChildInformationDto? get childInformationDto => _childInformationDto;
  SapsInfoDto? get sapsInfoDto => _sapsInfoDto;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    map['caseInformationId'] = _caseInformationId;
    map['casNumber'] = _casNumber;
    map['sapsInfoId'] = _sapsInfoId;
    map['arrestDate'] = _arrestDate;
    map['arrestTime'] = _arrestTime;
    map['childInformationId'] = _childInformationId;
    map['probationOfficerInformationId'] = _probationOfficerInformationId;
    map['probationOfficerEstimatedArrivalTime'] =
        _probationOfficerEstimatedArrivalTime;
    map['probationOfficerContactTypeId'] = _probationOfficerContactTypeId;
    map['probationOfficerAllocatedDate'] = _probationOfficerAllocatedDate;
    map['timeAssigned'] = _timeAssigned;
    map['notificacationId'] = _notificacationId;
    map['offenseType'] = _offenseType;
    map['hoursLeft'] = _hoursLeft;
    map['notificationDateSet'] = _notificationDateSet;
    map['arrestDateFormat'] = _arrestDateFormat;
    if (_childInformationDto != null) {
      map['childInformationDto'] = _childInformationDto?.toJson();
    }
    if (_sapsInfoDto != null) {
      map['sapsInfoDto'] = _sapsInfoDto?.toJson();
    }
    return map;
  }
}
