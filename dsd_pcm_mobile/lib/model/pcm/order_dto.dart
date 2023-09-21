import 'package:dsd_pcm_mobile/model/intake/pcm_order_dto.dart';

class OrderDto {
  OrderDto({
    int? orderId,
    int? recommendationId,
    int? recomendationOrderId,
    String? orderReason,
    int? createdBy,
    String? dateCreated,
    int? modifiedBy,
    String? dateModified,
    PcmOrderDto? pcmOrderDto,
  }) {
    _orderId = orderId;
    _recommendationId = recommendationId;
    _recomendationOrderId = recomendationOrderId;
    _orderReason = orderReason;
    _createdBy = createdBy;
    _dateCreated = dateCreated;
    _modifiedBy = modifiedBy;
    _dateModified = dateModified;
    _pcmOrderDto = pcmOrderDto;
  }

  OrderDto.fromJson(dynamic json) {
    _orderId = json['orderId'];
    _recommendationId = json['recommendationId'];
    _recomendationOrderId = json['recomendationOrderId'];
    _orderReason = json['orderReason'];
    _createdBy = json['createdBy'];
    _dateCreated = json['dateCreated'];
    _modifiedBy = json['modifiedBy'];
    _dateModified = json['dateModified'];

    _pcmOrderDto = json['pcmOrderDto'] != null
        ? PcmOrderDto.fromJson(json['pcmOrderDto'])
        : null;
  }
  int? _orderId;
  int? _recommendationId;
  int? _recomendationOrderId;
  String? _orderReason;
  int? _createdBy;
  String? _dateCreated;
  int? _modifiedBy;
  String? _dateModified;
  PcmOrderDto? _pcmOrderDto;

  int? get orderId => _orderId;
  int? get recommendationId => _recommendationId;
  int? get recomendationOrderId => _recomendationOrderId;
  String? get orderReason => _orderReason;
  int? get createdBy => _createdBy;
  String? get dateCreated => _dateCreated;
  int? get modifiedBy => _modifiedBy;
  String? get dateModified => _dateModified;
  PcmOrderDto? get pcmOrderDto => _pcmOrderDto;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    map['orderId'] = _orderId;
    map['recommendationId'] = _recommendationId;
    map['recomendationOrderId'] = _recomendationOrderId;
    map['orderReason'] = _orderReason;
    map['dateCreated'] = _dateCreated;
    map['modifiedBy'] = _modifiedBy;
    map['dateModified'] = _dateModified;
    if (_pcmOrderDto != null) {
      map['pcmOrderDto'] = _pcmOrderDto?.toJson();
    }
    return map;
  }
}
