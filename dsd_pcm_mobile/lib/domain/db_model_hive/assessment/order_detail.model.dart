import 'package:dsd_pcm_mobile/domain/db_model_hive/lookup/pcm_order_detail.model.dart';
import 'package:hive/hive.dart';
part 'order_detail.model.g.dart';

@HiveType(typeId: 46)
class OrderDetailModel {
  @HiveField(0)
  final int? orderId;
  @HiveField(1)
  final int? recommendationId;
  @HiveField(2)
  final int? recomendationOrderId;
  @HiveField(3)
  final String? orderReason;
  @HiveField(4)
  int? createdBy;
  @HiveField(5)
  final String? dateCreated;
  @HiveField(6)
  final int? modifiedBy;
  @HiveField(7)
  final String? dateModified;
  final PcmOrderDetailModel? pcmOrderDetailModel;
  OrderDetailModel(
      {this.orderId,
      this.recommendationId,
      this.recomendationOrderId,
      this.createdBy,
      this.orderReason,
      this.dateCreated,
      this.modifiedBy,
      this.dateModified,
      this.pcmOrderDetailModel});
}
