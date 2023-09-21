import '../intake/admission_type.dart';
import '../intake/cyca_facility_dto.dart';
import '../intake/province_dto.dart';

class FacilityBedSpaceDto {
  FacilityBedSpaceDto({
    int? requestId,
    int? sentBy,
    int? intakeAssessmentId,
    String? requestSubject,
    int? provinceId,
    String? dateRecieved,
    String? timeRecieved,
    String? requestComments,
    int? facilityId,
    String? approvedComments,
    String? replyDate,
    String? replyTime,
    int? requestStatusId,
    String? requestStatusComments,
    String? requestOpenClose,
    String? dateClosed,
    int? countDeclined,
    int? countAccepted,
    int? admissionTypeId,
    int? createdBy,
    String? dateCreated,
    int? modifiedBy,
    String? dateModified,
    CycaFacilityDto? cycaFacilityDto,
    AdmissionTypeDto? admissionTypeDto,
    ProvinceDto? provinceDto,
  }) {
    _requestId = requestId;
    _sentBy = sentBy;
    _intakeAssessmentId = intakeAssessmentId;
    _requestSubject = requestSubject;
    _provinceId = provinceId;
    _dateRecieved = dateRecieved;
    _timeRecieved = timeRecieved;
    _requestComments = requestComments;
    _facilityId = facilityId;
    _approvedComments = approvedComments;
    _replyDate = replyDate;
    _replyTime = replyTime;
    _requestStatusId = requestStatusId;
    _requestStatusComments = requestStatusComments;
    _requestOpenClose = requestOpenClose;
    _dateClosed = dateClosed;
    _countDeclined = countDeclined;
    _countAccepted = countAccepted;
    _admissionTypeId = admissionTypeId;
    _createdBy = createdBy;
    _dateCreated = dateCreated;
    _modifiedBy = modifiedBy;
    _dateModified = dateModified;
    _cycaFacilityDto = cycaFacilityDto;
    _admissionTypeDto = admissionTypeDto;
     _provinceDto = provinceDto;
  }

  FacilityBedSpaceDto.fromJson(dynamic json) {
    _requestId = json['requestId'];
    _sentBy = json['sentBy'];
    _intakeAssessmentId = json['intakeAssessmentId'];
    _requestSubject = json['requestSubject'];
    _provinceId = json['provinceId'];
    _dateRecieved = json['dateRecieved'];
    _timeRecieved = json['timeRecieved'];
    _requestComments = json['requestComments'];
    _facilityId = json['facilityId'];
    _approvedComments = json['approvedComments'];
    _replyDate = json['replyDate'];
    _replyTime = json['replyTime'];
    _requestStatusId = json['requestStatusId'];
    _requestStatusComments = json['requestStatusComments'];
    _requestOpenClose = json['requestOpenClose'];
    _dateClosed = json['dateClosed'];
    _countDeclined = json['countDeclined'];
    _countAccepted = json['countAccepted'];
    _admissionTypeId = json['admissionTypeId'];
    _createdBy = json['createdBy'];
    _dateCreated = json['dateCreated'];
    _modifiedBy = json['modifiedBy'];
    _dateModified = json['dateModified'];
      _cycaFacilityDto = json['cycaFacilityDto'] != null
        ? CycaFacilityDto.fromJson(json['cycaFacilityDto'])
        : null;
    _admissionTypeDto = json['admissionTypeDto'] != null
        ? AdmissionTypeDto.fromJson(json['admissionTypeDto'])
        : null;
          _provinceDto = json['provinceDto'] != null
        ? ProvinceDto.fromJson(json['provinceDto'])
        : null;
  }
  int? _requestId;
  int? _sentBy;
  int? _intakeAssessmentId;
  String? _requestSubject;
  int? _provinceId;
  String? _dateRecieved;
  String? _timeRecieved;
  String? _requestComments;
  int? _facilityId;
  String? _approvedComments;
  String? _replyDate;
  String? _replyTime;
  int? _requestStatusId;
  String? _requestStatusComments;
  String? _requestOpenClose;
  String? _dateClosed;
  int? _countDeclined;
  int? _countAccepted;
  int? _admissionTypeId;
  int? _createdBy;
  String? _dateCreated;
  int? _modifiedBy;
  String? _dateModified;
  CycaFacilityDto? _cycaFacilityDto;
  AdmissionTypeDto? _admissionTypeDto;
  ProvinceDto? _provinceDto;

  int? get requestId => _requestId;
  int? get sentBy => _sentBy;
  int? get intakeAssessmentId => _intakeAssessmentId;
  String? get requestSubject => _requestSubject;
  int? get provinceId => _provinceId;
  String? get dateRecieved => _dateRecieved;
  String? get timeRecieved => _timeRecieved;
  String? get requestComments => _requestComments;
  int? get facilityId => _facilityId;
  String? get approvedComments => _approvedComments;
  String? get replyDate => _replyDate;
  String? get replyTime => _replyTime;
  int? get requestStatusId => _requestStatusId;
  String? get requestStatusComments => _requestStatusComments;
  String? get requestOpenClose => _requestOpenClose;
  String? get dateClosed => _dateClosed;
  int? get countDeclined => _countDeclined;
  int? get countAccepted => _countAccepted;
   int? get admissionTypeId => _admissionTypeId;
  int? get createdBy => _createdBy;
  String? get dateCreated => _dateCreated;
  int? get modifiedBy => _modifiedBy;
  String? get dateModified => _dateModified;
  CycaFacilityDto? get cycaFacilityDto => _cycaFacilityDto;
  AdmissionTypeDto? get admissionTypeDto => _admissionTypeDto;
  ProvinceDto? get provinceDto => _provinceDto;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['requestId'] = _requestId;
    map['sentBy'] = _sentBy;
    map['intakeAssessmentId'] = _intakeAssessmentId;
    map['requestSubject'] = _requestSubject;
    map['provinceId'] = _provinceId;
    map['dateRecieved'] = _dateRecieved;
    map['timeRecieved'] = _timeRecieved;
    map['requestComments'] = _requestComments;
    map['facilityId'] = _facilityId;
    map['approvedComments'] = _approvedComments;
    map['replyDate'] = _replyDate;
    map['replyTime'] = _replyTime;
    map['requestStatusId'] = _requestStatusId;
    map['requestStatusComments'] = _requestStatusComments;
    map['requestOpenClose'] = _requestOpenClose;
    map['dateClosed'] = _dateClosed;
    map['countDeclined'] = _countDeclined;
    map['countAccepted'] = _countAccepted;
    map['admissionTypeId'] = _admissionTypeId;
    map['createdBy'] = _createdBy;
    map['dateCreated'] = _dateCreated;
    map['modifiedBy'] = _modifiedBy;
    map['dateModified'] = _dateModified;
   if (_cycaFacilityDto != null) {
      map['cycaFacilityDto'] = _cycaFacilityDto?.toJson();
    }
    if (_admissionTypeDto != null) {
      map['admissionTypeDto'] = _admissionTypeDto?.toJson();
    }
     if (_provinceDto != null) {
      map['provinceDto'] = _provinceDto?.toJson();
    }

    return map;
  }
}
