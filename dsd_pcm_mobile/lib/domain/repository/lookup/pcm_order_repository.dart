import 'package:dsd_pcm_mobile/domain/db_model_hive/lookup/pcm_order_detail.model.dart';
import 'package:dsd_pcm_mobile/model/intake/pcm_order_dto.dart';
import 'package:hive_flutter/adapters.dart';

const String pcmOrderDetailBox = 'pcmOrderDetailBox';

class PcmOrderDetailRepository {
  PcmOrderDetailRepository._construct();
  static final PcmOrderDetailRepository _instance =
      PcmOrderDetailRepository._construct();
  factory PcmOrderDetailRepository() => _instance;
  late Box<PcmOrderDetailModel> _pcmOrderDetailsBox;

  Future<void> initialize() async {
    await Hive.initFlutter();
    Hive.registerAdapter<PcmOrderDetailModel>(PcmOrderDetailModelAdapter());
    _pcmOrderDetailsBox =
        await Hive.openBox<PcmOrderDetailModel>(pcmOrderDetailBox);
  }

  Future<void> savePcmOrderDetailItems(
      List<PcmOrderDto> pcmOrderDetailsDto) async {
    for (var pcmOrderDetailDto in pcmOrderDetailsDto) {
      await _pcmOrderDetailsBox.put(
          pcmOrderDetailDto.recomendationOrderId,
          (PcmOrderDetailModel(
            recomendationOrderId: pcmOrderDetailDto.recomendationOrderId,
            description: pcmOrderDetailDto.description,
            definition: pcmOrderDetailDto.definition,
            source: pcmOrderDetailDto.source,
          )));
    }
  }

  Future<void> savePcmOrderDetail(PcmOrderDto pcmOrderDetailDto) async {
    await _pcmOrderDetailsBox.put(
        pcmOrderDetailDto.recomendationOrderId,
        PcmOrderDetailModel(
          recomendationOrderId: pcmOrderDetailDto.recomendationOrderId,
          description: pcmOrderDetailDto.description,
          definition: pcmOrderDetailDto.definition,
          source: pcmOrderDetailDto.source,
        ));
  }

  Future<void> deletePcmOrderlDetailById(int id) async {
    await _pcmOrderDetailsBox.delete(id);
  }

  Future<void> deleteAllPcmOrderlDetails() async {
    await _pcmOrderDetailsBox.clear();
  }

  List<PcmOrderDto> getAllPcmOrderlDetails() {
    return _pcmOrderDetailsBox.values.map(pcmOrderlDetailFromDb).toList();
  }

  PcmOrderDto? getPcmOrderlDetailById(int id) {
    final bookDb = _pcmOrderDetailsBox.get(id);
    if (bookDb != null) {
      return pcmOrderlDetailFromDb(bookDb);
    }
    return null;
  }

  PcmOrderDto pcmOrderlDetailFromDb(PcmOrderDetailModel orderDetailModel) =>
      PcmOrderDto(
        recomendationOrderId: orderDetailModel.recomendationOrderId,
        description: orderDetailModel.description,
        definition: orderDetailModel.definition,
        source: orderDetailModel.source,
      );

  PcmOrderDetailModel pcmOrderDetailToDb(PcmOrderDto? pcmOrderDetailDto) =>
      PcmOrderDetailModel(
          recomendationOrderId: pcmOrderDetailDto!.recomendationOrderId,
          description: pcmOrderDetailDto.description,
          definition: pcmOrderDetailDto.definition,
          source: pcmOrderDetailDto.source);
}
