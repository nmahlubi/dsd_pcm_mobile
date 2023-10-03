import 'package:hive/hive.dart';
part 'pcm_order_detail.model.g.dart';

@HiveType(typeId: 47)
class PcmOrderDetailModel {
  @HiveField(0)
  final int? recomendationOrderId;
  @HiveField(1)
  final String? description;
  @HiveField(2)
  final String? definition;
  @HiveField(3)
  final String? source;

  PcmOrderDetailModel({
    this.recomendationOrderId,
    this.description,
    this.definition,
    this.source,
  });
}
