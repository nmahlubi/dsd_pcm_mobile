import '../intake/offence_category_dto.dart';
import '../intake/offence_type_dto.dart';

class OffenceDetailDto {
  OffenceDetailDto({
    int? pcmOffenceId,
    int? pcmCaseId,
    int? intakeAssessmentId,
    int? offenceTypeId,
    int? offenceCategoryId,
    int? offenceScheduleId,
    String? offenceCircumstance,
    String? valueOfGoods,
    String? valueRecovered,
    String? isChildResponsible,
    String? responsibilityDetails,
    int? createdBy,
    String? dateCreated,
    int? modifiedBy,
    String? dateModified,
    OffenceTypeDto? offenceTypeDto,
    OffenceCategoryDto? offenceCategoryDto,
  }) {
    _pcmOffenceId = pcmOffenceId;
    _pcmCaseId = pcmCaseId;
    _intakeAssessmentId = intakeAssessmentId;
    _offenceTypeId = offenceTypeId;
    _offenceCategoryId = offenceCategoryId;
    _offenceScheduleId = offenceScheduleId;
    _offenceCircumstance = offenceCircumstance;
    _valueOfGoods = valueOfGoods;
    _valueRecovered = valueRecovered;
    _isChildResponsible = isChildResponsible;
    _responsibilityDetails = responsibilityDetails;
    _createdBy = createdBy;
    _dateCreated = dateCreated;
    _modifiedBy = modifiedBy;
    _dateModified = dateModified;
    _offenceTypeDto = offenceTypeDto;
    _offenceCategoryDto = offenceCategoryDto;
  }

  OffenceDetailDto.fromJson(dynamic json) {
    _pcmOffenceId = json['pcmOffenceId'];
    _pcmCaseId = json['pcmCaseId'];
    _intakeAssessmentId = json['intakeAssessmentId'];
    _offenceTypeId = json['offenceTypeId'];
    _offenceCategoryId = json['offenceCategoryId'];
    _offenceScheduleId = json['offenceScheduleId'];
    _offenceCircumstance = json['offenceCircumstance'];
    _valueOfGoods = json['valueOfGoods'];
    _valueRecovered = json['valueRecovered'];
    _isChildResponsible = json['isChildResponsible'];
    _responsibilityDetails = json['responsibilityDetails'];
    _createdBy = json['createdBy'];
    _dateCreated = json['dateCreated'];
    _modifiedBy = json['modifiedBy'];
    _dateModified = json['dateModified'];
    _offenceTypeDto = json['offenceTypeDto'] != null
        ? OffenceTypeDto.fromJson(json['offenceTypeDto'])
        : null;
    _offenceCategoryDto = json['offenceCategoryDto'] != null
        ? OffenceCategoryDto.fromJson(json['offenceCategoryDto'])
        : null;
  }

  int? _pcmOffenceId;
  int? _pcmCaseId;
  int? _intakeAssessmentId;
  int? _offenceTypeId;
  int? _offenceCategoryId;
  int? _offenceScheduleId;
  String? _offenceCircumstance;
  String? _valueOfGoods;
  String? _valueRecovered;
  String? _isChildResponsible;
  String? _responsibilityDetails;
  int? _createdBy;
  String? _dateCreated;
  int? _modifiedBy;
  String? _dateModified;
  OffenceTypeDto? _offenceTypeDto;
  OffenceCategoryDto? _offenceCategoryDto;

  int? get pcmOffenceId => _pcmOffenceId;
  int? get pcmCaseId => _pcmCaseId;
  int? get intakeAssessmentId => _intakeAssessmentId;
  int? get offenceTypeId => _offenceTypeId;
  int? get offenceCategoryId => _offenceCategoryId;
  int? get offenceScheduleId => _offenceScheduleId;
  String? get offenceCircumstance => _offenceCircumstance;
  String? get valueOfGoods => _valueOfGoods;
  String? get valueRecovered => _valueRecovered;
  String? get isChildResponsible => _isChildResponsible;
  String? get responsibilityDetails => _responsibilityDetails;
  int? get createdBy => _createdBy;
  String? get dateCreated => _dateCreated;
  int? get modifiedBy => _modifiedBy;
  String? get dateModified => _dateModified;
  OffenceTypeDto? get offenceTypeDto => _offenceTypeDto;
  OffenceCategoryDto? get offenceCategoryDto => _offenceCategoryDto;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['pcmOffenceId'] = _pcmOffenceId;
    map['pcmCaseId'] = _pcmCaseId;
    map['intakeAssessmentId'] = _intakeAssessmentId;
    map['offenceTypeId'] = _offenceTypeId;
    map['offenceCategoryId'] = _offenceCategoryId;
    map['offenceScheduleId'] = _offenceScheduleId;
    map['offenceCircumstance'] = _offenceCircumstance;
    map['valueOfGoods'] = _valueOfGoods;
    map['valueRecovered'] = _valueRecovered;
    map['isChildResponsible'] = _isChildResponsible;
    map['responsibilityDetails'] = _responsibilityDetails;
    map['createdBy'] = _createdBy;
    map['dateCreated'] = _dateCreated;
    map['modifiedBy'] = _modifiedBy;
    map['dateModified'] = _dateModified;
    if (_offenceTypeDto != null) {
      map['offenceTypeDto'] = _offenceTypeDto?.toJson();
    }
    if (_offenceCategoryDto != null) {
      map['offenceCategoryDto'] = _offenceCategoryDto?.toJson();
    }

    return map;
  }
}
