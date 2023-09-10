import 'package:dsd_pcm_mobile/model/intake/offence_category_dto.dart';

class PreviousInvolvementDetailDto {
  PreviousInvolvementDetailDto({
    int? involvementId,
    int? intakeAssessmentId,
    String? previousInvolved,
    String? isArrest,
    String? arrestDate,
    int? offenceCategoryId,
    String? sentenceOutcomes,
    String? isConvicted,
    String? convictionDate,
    String? isEscape,
    String? escapesDate,
    String? escapeTime,
    int? whenEscapedId,
    String? placeOfEscape,
    int? createdBy,
    String? dateCreated,
    int? modifiedBy,
    String? dateModified,
    OffenceCategoryDto? offenceCategoryDto,
  }) {
    _involvementId = involvementId;
    _intakeAssessmentId = intakeAssessmentId;
    _previousInvolved = previousInvolved;
    _isArrest = isArrest;
    _arrestDate = arrestDate;
    _offenceCategoryId = offenceCategoryId;
    _sentenceOutcomes = sentenceOutcomes;
    _isConvicted = isConvicted;
    _convictionDate = convictionDate;
    _isEscape = isEscape;
    _escapesDate = escapesDate;
    _escapeTime = escapeTime;
    _whenEscapedId = whenEscapedId;
    _placeOfEscape = placeOfEscape;
    _createdBy = createdBy;
    _dateCreated = dateCreated;
    _modifiedBy = _modifiedBy;
    _dateModified = dateModified;
    _offenceCategoryDto = offenceCategoryDto;
  }

  PreviousInvolvementDetailDto.fromJson(dynamic json) {
    _involvementId = json['involvementId'];
    _intakeAssessmentId = json['intakeAssessmentId'];
    _previousInvolved = json['previousInvolved'];
    _isArrest = json['isArrest'];
    _arrestDate = json['arrestDate'];
    _offenceCategoryId = json['offenceCategoryId'];
    _sentenceOutcomes = json['sentenceOutcomes'];
    _isConvicted = json['isConvicted'];
    _convictionDate = json['convictionDate'];
    _isEscape = json['isEscape'];
    _escapesDate = json['escapesDate'];
    _escapeTime = json['escapeTime'];
    _whenEscapedId = json['whenEscapedId'];
    _placeOfEscape = json['placeOfEscape'];
    _createdBy = json['createdBy'];
    _dateCreated = json['dateCreated'];
    _modifiedBy = json['modifiedBy'];
    _dateModified = json['dateModified'];
    _offenceCategoryDto = json['offenceCategoryDto'] != null
        ? OffenceCategoryDto.fromJson(json['offenceCategoryDto'])
        : null;
  }
  int? _involvementId;
  int? _intakeAssessmentId;
  String? _previousInvolved;
  String? _isArrest;
  String? _arrestDate;
  int? _offenceCategoryId;
  String? _sentenceOutcomes;
  String? _isConvicted;
  String? _convictionDate;
  String? _isEscape;
  String? _escapesDate;
  String? _escapeTime;
  int? _whenEscapedId;
  String? _placeOfEscape;
  int? _createdBy;
  String? _dateCreated;
  int? _modifiedBy;
  String? _dateModified;
  OffenceCategoryDto? _offenceCategoryDto;

  int? get involvementId => _involvementId;
  int? get intakeAssessmentId => _intakeAssessmentId;
  String? get previousInvolved => _previousInvolved;
  String? get isArrest => _isArrest;
  String? get arrestDate => _arrestDate;
  int? get offenceCategoryId => _offenceCategoryId;
  String? get sentenceOutcomes => _sentenceOutcomes;
  String? get isConvicted => _isConvicted;
  String? get convictionDate => _convictionDate;
  String? get isEscape => _isEscape;
  String? get escapesDate => _escapesDate;
  String? get escapeTime => _escapeTime;
  int? get whenEscapedId => _whenEscapedId;
  String? get placeOfEscape => _placeOfEscape;
  int? get createdBy => _createdBy;
  String? get dateCreated => _dateCreated;
  int? get modifiedBy => _modifiedBy;
  String? get dateModified => _dateModified;
  OffenceCategoryDto? get offenceCategoryDto => _offenceCategoryDto;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    map['involvementId'] = _involvementId;
    map['intakeAssessmentId'] = _intakeAssessmentId;
    map['previousInvolved'] = _previousInvolved;
    map['isArrest'] = _isArrest;
    map['arrestDate'] = _arrestDate;
    map['offenceCategoryId'] = _offenceCategoryId;
    map['sentenceOutcomes'] = _sentenceOutcomes;
    map['isConvicted'] = _isConvicted;
    map['convictionDate'] = _convictionDate;
    map['isEscape'] = _isEscape;
    map['escapesDate'] = _escapesDate;
    map['escapeTime'] = _escapeTime;
    map['whenEscapedId'] = _whenEscapedId;
    map['placeOfEscape'] = _placeOfEscape;
    map['createdBy'] = _createdBy;
    map['dateCreated'] = _dateCreated;
    map['modifiedBy'] = _modifiedBy;
    map['dateModified'] = _dateModified;
    if (_offenceCategoryDto != null) {
      map['offenceCategoryDto'] = _offenceCategoryDto?.toJson();
    }
    return map;
  }
}
