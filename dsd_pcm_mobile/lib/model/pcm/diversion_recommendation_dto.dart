import 'package:dsd_pcm_mobile/model/pcm/diversion_dto.dart';
import 'package:dsd_pcm_mobile/model/pcm/programmes_dto.dart';

class DiversionRecommendationDto {
  DiversionRecommendationDto({
    int? pcmDiversionRecommId,
    int? recommendationId,
    int? serviceProviderId,
    int? recommendationProgrammesId,
    int? levelId,
    int? orderId,
    int? typeOfPlacementId,
    int? facilityId,
    int? personalDetailsId,
    int? createdBy,
    int? modifiedBy,
    String? dateCreated,
    String? dateModified,
    bool? withdrawalStatus,
    ProgrammesDto? programmesDto,
    DiversionDto? diversionDto,
  }) {
    _pcmDiversionRecommId = pcmDiversionRecommId;
    _recommendationId = recommendationId;
    _serviceProviderId = serviceProviderId;
    _recommendationProgrammesId = recommendationProgrammesId;
    _levelId = levelId;
    _orderId = orderId;
    _typeOfPlacementId = typeOfPlacementId;
    _facilityId = facilityId;
    _personalDetailsId = personalDetailsId;
    _createdBy = createdBy;
    _modifiedBy = modifiedBy;
    _dateCreated = dateCreated;
    _dateModified = dateModified;
    _withdrawalStatus = withdrawalStatus;
    _programmesDto = programmesDto;
    _diversionDto = diversionDto;
  }

  DiversionRecommendationDto.fromJson(dynamic json) {
    _pcmDiversionRecommId = json['pcmDiversionRecommId'];
    _recommendationId = json['recommendationId'];
    _serviceProviderId = json['serviceProviderId'];
    _recommendationProgrammesId = json['recommendationProgrammesId'];
    _levelId = json['levelId'];
    _orderId = json['orderId'];
    _typeOfPlacementId = json['typeOfPlacementId'];
    _facilityId = json['facilityId'];
    _personalDetailsId = json['personalDetailsId'];
    _createdBy = json['createdBy'];
    _modifiedBy = json['modifiedBy'];
    _dateCreated = json['dateCreated'];
    _dateModified = json['dateModified'];
    _withdrawalStatus = json['withdrawalStatus'];
    _programmesDto = json['programmesDto'] != null
        ? ProgrammesDto.fromJson(json['programmesDto'])
        : null;
    _diversionDto = json['diversionDto'] != null
        ? DiversionDto.fromJson(json['diversionDto'])
        : null;
  }

  int? _pcmDiversionRecommId;
  int? _recommendationId;
  int? _serviceProviderId;
  int? _recommendationProgrammesId;
  int? _levelId;
  int? _orderId;
  int? _typeOfPlacementId;
  int? _facilityId;
  int? _personalDetailsId;
  int? _createdBy;
  int? _modifiedBy;
  String? _dateCreated;
  String? _dateModified;
  bool? _withdrawalStatus;
  ProgrammesDto? _programmesDto;
  DiversionDto? _diversionDto;

  int? get pcmDiversionRecommId => _pcmDiversionRecommId;
  int? get recommendationId => _recommendationId;
  int? get serviceProviderId => _serviceProviderId;
  int? get recommendationProgrammesId => _recommendationProgrammesId;
  int? get levelId => _levelId;
  int? get orderId => _orderId;
  int? get typeOfPlacementId => _typeOfPlacementId;
  int? get facilityId => _facilityId;
  int? get personalDetailsId => _personalDetailsId;
  int? get createdBy => _createdBy;
  int? get modifiedBy => _modifiedBy;
  String? get dateCreated => _dateCreated;
  String? get dateModified => _dateModified;
  bool? get withdrawalStatus => _withdrawalStatus;
  ProgrammesDto? get programmesDto => _programmesDto;
  DiversionDto? get diversionDto => _diversionDto;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['pcmDiversionRecommId'] = _pcmDiversionRecommId;
    map['recommendationId'] = _recommendationId;
    map['serviceProviderId'] = _serviceProviderId;
    map['recommendationProgrammesId'] = _recommendationProgrammesId;
    map['levelId'] = _levelId;
    map['orderId'] = _orderId;
    map['typeOfPlacementId'] = _typeOfPlacementId;
    map['facilityId'] = _facilityId;
    map['personalDetailsId'] = _personalDetailsId;
    map['createdBy'] = _createdBy;
    map['modifiedBy'] = _modifiedBy;
    map['dateCreated'] = _dateCreated;
    map['dateModified'] = _dateModified;
    map['withdrawalStatus'] = _withdrawalStatus;
    if (_programmesDto != null) {
      map['programmesDto'] = _programmesDto?.toJson();
    }
    if (_diversionDto != null) {
      map['diversionDto'] = _diversionDto?.toJson();
    }
    return map;
  }
}
