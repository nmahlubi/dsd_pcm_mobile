import 'package:dsd_pcm_mobile/model/pcm/preliminaryStatus_dto.dart';

import '../intake/placement_type_dto.dart';
import '../intake/recommendation_type_dto.dart';

class PreliminaryDetailDto {
  PreliminaryDetailDto({
    int? pCMPreliminaryId,
    int? pCMCaseId,
    int? clientId,
    int? intakeAssessmentId,
    String? preInquiryConducted,
    String? reasonPreInquiryConducted,
    String? pCMPreliminaryDate,
    int? pCMPreliminaryStatusId,
    String? pCMOutcomeReason,
    int? pCMOffenceId,
    int? pCMRecommendationId,
    int? placementPreStatusId,
    String? pretrialReason,
    String? pretrialDate,
    int? placementPreRecommendedId,
    int? createdBy,
    String? dateCreated,
    int? modifiedBy,
    String? dateModified,
    PreliminaryStatusDto? preliminaryStatusDto,
    RecommendationTypeDto? recommendationTypeDto,
    PlacementTypeDto? placementTypeDto,
  }) {
    _pCMPreliminaryId = pCMPreliminaryId;
    _pCMCaseId = pCMCaseId;
    _clientId = clientId;
    _intakeAssessmentId = intakeAssessmentId;
    _preInquiryConducted = preInquiryConducted;
    _reasonPreInquiryConducted = reasonPreInquiryConducted;
    _pCMPreliminaryDate = pCMPreliminaryDate;
    _pCMPreliminaryStatusId = pCMPreliminaryStatusId;
    _pCMOutcomeReason = pCMOutcomeReason;
    _pCMOffenceId = pCMOffenceId;
    _pCMRecommendationId = pCMRecommendationId;
    _placementPreStatusId = placementPreStatusId;
    _pretrialReason = pretrialReason;
    _pretrialDate = pretrialDate;
    _placementPreRecommendedId = placementPreRecommendedId;
    _createdBy = createdBy;
    _dateCreated = dateCreated;
    _modifiedBy = modifiedBy;
    _dateModified = dateModified;
    _preliminaryStatusDto = preliminaryStatusDto;
    _recommendationTypeDto = recommendationTypeDto;
    _placementTypeDto = placementTypeDto;
  }

  PreliminaryDetailDto.fromJson(dynamic json) {
    _pCMPreliminaryId = json['pcmPreliminaryId'];
    ;
    _pCMCaseId = json['pcmCaseId'];
    ;
    _clientId = json['clientId'];
    ;
    _intakeAssessmentId = json['intakeAssessmentId'];
    ;
    _preInquiryConducted = json['preInquiryConducted'];
    ;
    _reasonPreInquiryConducted = json['reasonPreInquiryConducted'];
    ;
    _pCMPreliminaryDate = json['pcmPreliminaryDate'];
    ;
    _pCMPreliminaryStatusId = json['preliminaryStatusId'];
    ;
    _pCMOutcomeReason = json['pcmOutcomeReason'];
    ;
    _pCMOffenceId = json['pcmOffenceId'];
    ;
    _pCMRecommendationId = json['recommendationTypeId'];
    ;
    _placementPreStatusId = json['placementPreStatusId'];
    ;
    _pretrialReason = json['pretrialReason'];
    ;

    _pretrialDate = json['pretrialDate'];

    _placementPreRecommendedId = json['placementTypeId'];
    ;
    _createdBy = json['createdBy'];
    ;
    _dateCreated = json['dateCreated'];
    ;
    _modifiedBy = json['modifiedBy'];
    ;
    _dateModified = json['dateModified'];
    ;

    _preliminaryStatusDto = json['preliminaryStatusDto'] != null
        ? PreliminaryStatusDto.fromJson(json['preliminaryStatusDto'])
        : null;
    _recommendationTypeDto = json['recommendationTypeDto'] != null
        ? RecommendationTypeDto.fromJson(json['recommendationTypeDto'])
        : null;
    _placementTypeDto = json['placementTypeDto'] != null
        ? PlacementTypeDto.fromJson(json['placementTypeDto'])
        : null;
  }
  int? _pCMPreliminaryId;
  int? _pCMCaseId;
  int? _clientId;
  int? _intakeAssessmentId;
  String? _preInquiryConducted;
  String? _reasonPreInquiryConducted;
  String? _pCMPreliminaryDate;
  int? _pCMPreliminaryStatusId;
  String? _pCMOutcomeReason;
  int? _pCMOffenceId;
  int? _pCMRecommendationId;
  int? _placementPreStatusId;
  String? _pretrialReason;
  String? _pretrialDate;
  int? _placementPreRecommendedId;
  int? _createdBy;
  String? _dateCreated;
  int? _modifiedBy;
  String? _dateModified;
  PreliminaryStatusDto? _preliminaryStatusDto;
  RecommendationTypeDto? _recommendationTypeDto;
  PlacementTypeDto? _placementTypeDto;

  int? get pCMPreliminaryId => _pCMPreliminaryId;
  int? get pCMCaseId => _pCMCaseId;
  int? get clientId => _clientId;
  int? get intakeAssessmentId => _intakeAssessmentId;
  String? get preInquiryConducted => _preInquiryConducted;
  String? get reasonPreInquiryConducted => _reasonPreInquiryConducted;
  String? get pCMPreliminaryDate => _pCMPreliminaryDate;
  int? get pCMPreliminaryStatusId => _pCMPreliminaryStatusId;
  String? get pCMOutcomeReason => _pCMOutcomeReason;
  int? get pCMOffenceId => _pCMOffenceId;
  int? get pCMRecommendationId => _pCMRecommendationId;
  String? get pretrialReason => _pretrialReason;
  String? get pretrialDate => _pretrialDate;
  int? get placementPreRecommendedId => _placementPreRecommendedId;
  int? get createdBy => _createdBy;
  String? get dateCreated => _dateCreated;
  int? get modifiedBy => _modifiedBy;
  String? get dateModified => _dateModified;
  PreliminaryStatusDto? get preliminaryStatusDto => _preliminaryStatusDto;
  RecommendationTypeDto? get recommendationTypeDto => _recommendationTypeDto;
  PlacementTypeDto? get placementTypeDto => _placementTypeDto;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['pcmPreliminaryId'] = _pCMPreliminaryId;
    map['pcmCaseId'] = _pCMCaseId;
    map['clientId'] = _clientId;
    map['intakeAssessmentId'] = _intakeAssessmentId;
    map['preInquiryConducted'] = _preInquiryConducted;
    map['reasonPreInquiryConducted'] = _reasonPreInquiryConducted;
    map['pcmPreliminaryDate'] = _pCMPreliminaryDate;
    map['preliminaryStatusId'] = _pCMPreliminaryStatusId;
    map['pcmOutcomeReason'] = _pCMOutcomeReason;
    map['pcmOffenceId'] = _pCMOffenceId;
    map['recommendationTypeId'] = _pCMRecommendationId;
    map['placementPreStatusId'] = _placementPreStatusId;
    map['pretrialReason'] = _pretrialReason;
    map['pretrialDate'] = _pretrialDate;
    map['placementTypeId'] = _placementPreRecommendedId;
    map['createdBy'] = _createdBy;
    map['dateCreated'] = _dateCreated;
    map['modifiedBy'] = _modifiedBy;
    map['dateModified'] = _dateModified;
    if (_preliminaryStatusDto != null) {
      map['preliminaryStatusDto'] = _preliminaryStatusDto?.toJson();
    }
    if (_recommendationTypeDto != null) {
      map['recommendationTypeDto'] = _recommendationTypeDto?.toJson();
    }
    if (_placementTypeDto != null) {
      map['placementTypeDto'] = _placementTypeDto?.toJson();
    }
    return map;
  }
}
