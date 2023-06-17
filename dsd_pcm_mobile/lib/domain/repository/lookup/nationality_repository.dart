import 'package:hive_flutter/adapters.dart';

import '../../../model/intake/nationality_dto.dart';
import '../../db_model_hive/lookup/nationality.model.dart';

const String nationalityBox = 'nationalityBox';

class NationalityRepository {
  NationalityRepository._constructor();

  static final NationalityRepository _instance =
      NationalityRepository._constructor();

  factory NationalityRepository() => _instance;

  late Box<NationalityModel> _nationalitiesBox;

  Future<void> initialize() async {
    await Hive.initFlutter();
    Hive.registerAdapter<NationalityModel>(NationalityModelAdapter());
    _nationalitiesBox = await Hive.openBox<NationalityModel>(nationalityBox);
  }

  Future<void> saveNationalityItems(
      List<NationalityDto> nationalitiesDto) async {
    for (var nationalityDto in nationalitiesDto) {
      await _nationalitiesBox.put(
          nationalityDto.nationalityId,
          (NationalityModel(
              nationalityId: nationalityDto.nationalityId,
              description: nationalityDto.description)));
    }
  }

  Future<void> saveNationality(NationalityDto nationalityDto) async {
    await _nationalitiesBox.put(
        nationalityDto.nationalityId,
        NationalityModel(
            nationalityId: nationalityDto.nationalityId,
            description: nationalityDto.description));
  }

  Future<void> deleteNationality(int id) async {
    await _nationalitiesBox.delete(id);
  }

  Future<void> deleteAllNationalities() async {
    await _nationalitiesBox.clear();
  }

  List<NationalityDto> getAllNationalities() {
    return _nationalitiesBox.values.map(nationalityFromDb).toList();
  }

  NationalityDto? getNationalityById(int id) {
    final bookDb = _nationalitiesBox.get(id);
    if (bookDb != null) {
      return nationalityFromDb(bookDb);
    }
    return null;
  }

  NationalityDto nationalityFromDb(NationalityModel nationalityModel) =>
      NationalityDto(
          nationalityId: nationalityModel.nationalityId,
          description: nationalityModel.description);

  NationalityModel nationalityToDb(NationalityDto? nationalityDto) =>
      NationalityModel(
          nationalityId: nationalityDto?.nationalityId,
          description: nationalityDto?.description);
}
