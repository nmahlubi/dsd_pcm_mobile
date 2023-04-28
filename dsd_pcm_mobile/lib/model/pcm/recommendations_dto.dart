import '../intake/placement_type_dto.dart';
import '../intake/recommendation_type_dto.dart';

class RecommendationDto {
  RecommendationDto({
    int? recommendationId,
    int? recommendationTypeId,
    int? placementTypeId,
    String? commentsForRecommendation,
    int? createdBy,
    String? dateCreated,
    int? modifiedBy,
    String? dateModified,
    int? intakeAssessmentId,
    RecommendationTypeDto? recommendationTypeDto,
    PlacementTypeDto? placementTypeDto,
  }) {
    _recommendationId = recommendationId;
    _recommendationTypeId = recommendationTypeId;
    _placementTypeId = placementTypeId;
    _commentsForRecommendation = commentsForRecommendation;
    _createdBy = createdBy;
    _dateCreated = dateCreated;
    _modifiedBy = modifiedBy;
    _dateModified = dateModified;
    _intakeAssessmentId = intakeAssessmentId;
    _recommendationTypeDto = recommendationTypeDto;
    _placementTypeDto = placementTypeDto;
  }
  RecommendationDto.fromJson(dynamic json) {
    _recommendationId = json['recommendationId'];
    _recommendationTypeId = json['recommendationTypeId'];
    _placementTypeId = json['placementTypeId'];
    _commentsForRecommendation = json['commentsForRecommendation'];
    _createdBy = json['createdBy'];
    _dateCreated = json['dateCreated'];
    _modifiedBy = json['modifiedBy'];
    _dateModified = json['dateModified'];
    _intakeAssessmentId = json['intakeAssessmentId'];
    _recommendationTypeDto = json['recommendationTypeDto'] != null
        ? RecommendationTypeDto.fromJson(json['recommendationTypeDto'])
        : null;
    _placementTypeDto = json['placementTypeDto'] != null
        ? PlacementTypeDto.fromJson(json['placementTypeDto'])
        : null;
  }
  int? _recommendationId;
  int? _recommendationTypeId;
  int? _placementTypeId;
  String? _commentsForRecommendation;
  int? _createdBy;
  String? _dateCreated;
  int? _modifiedBy;
  String? _dateModified;
  int? _intakeAssessmentId;
  RecommendationTypeDto? _recommendationTypeDto;
  PlacementTypeDto? _placementTypeDto;

  int? get recommendationId => _recommendationId;
  int? get recommendationTypeId => _recommendationTypeId;
  int? get placementTypeId => _placementTypeId;
  String? get commentsForRecommendation => _commentsForRecommendation;
  int? get createdBy => _createdBy;
  String? get dateCreated => _dateCreated;
  int? get modifiedBy => _modifiedBy;
  String? get dateModified => _dateModified;
  int? get intakeAssessmentId => _intakeAssessmentId;
  RecommendationTypeDto? get recommendationTypeDto => _recommendationTypeDto;
  PlacementTypeDto? get placementTypeDto => _placementTypeDto;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['recommendationId'] = _recommendationId;
    map['recommendationTypeId'] = _recommendationTypeId;
    map['placementTypeId'] = _placementTypeId;
    map['commentsForRecommendation'] = _commentsForRecommendation;
    map['createdBy'] = _createdBy;
    map['dateCreated'] = _dateCreated;
    map['modifiedBy'] = _modifiedBy;
    map['dateModified'] = _dateModified;
    map['intakeAssessmentId'] = _intakeAssessmentId;
    if (_recommendationTypeDto != null) {
      map['recommendationTypeDto'] = _recommendationTypeDto?.toJson();
    }
    if (_placementTypeDto != null) {
      map['placementTypeDto'] = _placementTypeDto?.toJson();
    }
    return map;
  }
}
