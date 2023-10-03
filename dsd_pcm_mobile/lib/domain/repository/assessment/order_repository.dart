import 'package:dsd_pcm_mobile/domain/db_model_hive/assessment/order_detail.model.dart';
import 'package:dsd_pcm_mobile/domain/repository/lookup/pcm_order_repository.dart';
import 'package:dsd_pcm_mobile/model/pcm/order_dto.dart';
import 'package:hive_flutter/adapters.dart';

const String orderDetailBox = 'orderDetailBox';

class OrderDetailRepository {
  OrderDetailRepository._construct();
  final _pcmOrderDetailRepository = PcmOrderDetailRepository();
  static final OrderDetailRepository _instance =
      OrderDetailRepository._construct();
  factory OrderDetailRepository() => _instance;
  late Box<OrderDetailModel> _orderDetailsBox;

  Future<void> initialize() async {
    await Hive.initFlutter();
    Hive.registerAdapter<OrderDetailModel>(OrderDetailModelAdapter());
    _orderDetailsBox = await Hive.openBox<OrderDetailModel>(orderDetailBox);
  }

  Future<void> saveOrderDetailItems(List<OrderDto> orderDetailsDto) async {
    for (var orderDetailDto in orderDetailsDto) {
      await _orderDetailsBox.put(
          orderDetailDto.orderId,
          (OrderDetailModel(
              orderId: orderDetailDto.orderId,
              recommendationId: orderDetailDto.recommendationId,
              recomendationOrderId: orderDetailDto.recomendationOrderId,
              orderReason: orderDetailDto.orderReason,
              createdBy: orderDetailDto.createdBy,
              dateCreated: orderDetailDto.dateCreated,
              modifiedBy: orderDetailDto.modifiedBy,
              dateModified: orderDetailDto.dateModified,
              pcmOrderDetailModel: orderDetailDto.recomendationOrderId != null
                  ? _pcmOrderDetailRepository
                      .pcmOrderDetailToDb(orderDetailDto.pcmOrderDto)
                  : null)));
    }
  }

  Future<void> saveOrderDetail(OrderDto orderDetailsDto) async {
    await _orderDetailsBox.put(
        orderDetailsDto.orderId,
        OrderDetailModel(
            orderId: orderDetailsDto.orderId,
            recommendationId: orderDetailsDto.recommendationId,
            recomendationOrderId: orderDetailsDto.recomendationOrderId,
            orderReason: orderDetailsDto.orderReason,
            createdBy: orderDetailsDto.createdBy,
            dateCreated: orderDetailsDto.dateCreated,
            modifiedBy: orderDetailsDto.modifiedBy,
            dateModified: orderDetailsDto.dateModified,
            pcmOrderDetailModel: orderDetailsDto.recomendationOrderId != null
                ? _pcmOrderDetailRepository
                    .pcmOrderDetailToDb(orderDetailsDto.pcmOrderDto)
                : null));
  }

  Future<void> deleteOrderlDetailByRecommendationId(int id) async {
    await _orderDetailsBox.delete(id);
  }

  Future<void> deleteAllOrderlDetails() async {
    await _orderDetailsBox.clear();
  }

  List<OrderDto> getAllOrderlDetails() {
    return _orderDetailsBox.values.map(orderlDetailFromDb).toList();
  }

  OrderDto? getOrderlDetailByRecommendationId(int id) {
    final bookDb = _orderDetailsBox.get(id);
    if (bookDb != null) {
      return orderlDetailFromDb(bookDb);
    }
    return null;
  }

  OrderDto orderlDetailFromDb(OrderDetailModel orderDetailModel) => OrderDto(
      orderId: orderDetailModel.orderId,
      recommendationId: orderDetailModel.recommendationId,
      recomendationOrderId: orderDetailModel.recomendationOrderId,
      orderReason: orderDetailModel.orderReason,
      createdBy: orderDetailModel.createdBy,
      modifiedBy: orderDetailModel.modifiedBy,
      dateCreated: orderDetailModel.dateCreated,
      dateModified: orderDetailModel.dateModified,
      pcmOrderDto: orderDetailModel.recomendationOrderId != null
          ? _pcmOrderDetailRepository
              .pcmOrderlDetailFromDb(orderDetailModel.pcmOrderDetailModel!)
          : null);

  OrderDetailModel orderDetailToDb(OrderDto? orderDetailDto) =>
      OrderDetailModel(
          orderId: orderDetailDto!.orderId,
          recommendationId: orderDetailDto.recommendationId,
          recomendationOrderId: orderDetailDto.recomendationOrderId,
          orderReason: orderDetailDto.orderReason,
          createdBy: orderDetailDto.createdBy,
          modifiedBy: orderDetailDto.modifiedBy,
          dateCreated: orderDetailDto.dateCreated,
          dateModified: orderDetailDto.dateModified,
          pcmOrderDetailModel: orderDetailDto.recomendationOrderId != null
              ? _pcmOrderDetailRepository
                  .pcmOrderDetailToDb(orderDetailDto.pcmOrderDto!)
              : null);
}
