import 'package:dsd_pcm_mobile/domain/db_model_hive/lookup/disability.model.dart';
import 'package:dsd_pcm_mobile/model/intake/disability_dto.dart';
import 'package:hive_flutter/adapters.dart';

const String disabilityBox = 'disabilityBox';

class DisabilityRepository {
  DisabilityRepository._constructor();

  static final DisabilityRepository _instance =
      DisabilityRepository._constructor();

  factory DisabilityRepository() => _instance;

  late Box<DisabilityModel> _disabilitiesBox;

  Future<void> initialize() async {
    await Hive.initFlutter();
    Hive.registerAdapter<DisabilityModel>(DisabilityModelAdapter());
    _disabilitiesBox = await Hive.openBox<DisabilityModel>(disabilityBox);
  }

  Future<void> saveDisabilityItems(List<DisabilityDto> disabilitiesDto) async {
    for (var disabilityDto in disabilitiesDto) {
      await _disabilitiesBox.put(
          disabilityDto.disabilityId,
          (DisabilityModel(
              disabilityId: disabilityDto.disabilityId,
              description: disabilityDto.description)));
    }
  }

  Future<void> saveDisability(DisabilityDto disabilityDto) async {
    await _disabilitiesBox.put(
        disabilityDto.disabilityId,
        DisabilityModel(
            disabilityId: disabilityDto.disabilityId,
            description: disabilityDto.description));
  }

  Future<void> deleteDisability(int id) async {
    await _disabilitiesBox.delete(id);
  }

  Future<void> deleteAllDisabilities() async {
    await _disabilitiesBox.clear();
  }

  List<DisabilityDto> getAllDisabilities() {
    return _disabilitiesBox.values.map(disabilityFromDb).toList();
  }

  DisabilityDto? getDisabilityById(int id) {
    final bookDb = _disabilitiesBox.get(id);
    if (bookDb != null) {
      return disabilityFromDb(bookDb);
    }
    return null;
  }

  DisabilityDto disabilityFromDb(DisabilityModel disabilityModel) =>
      DisabilityDto(
        disabilityId: disabilityModel.disabilityId,
        description: disabilityModel.description,
      );

  DisabilityModel disabilityToDb(DisabilityDto? disabilityDto) =>
      DisabilityModel(
          disabilityId: disabilityDto?.disabilityId,
          description: disabilityDto?.description);
}
