import 'package:hive_flutter/adapters.dart';

import '../../../model/intake/gender_dto.dart';
import '../../db_model_hive/lookup/gender.model.dart';

const String _genderBox = 'genderBox';

class GenderRepository {
  GenderRepository._constructor();

  static final GenderRepository _instance = GenderRepository._constructor();

  factory GenderRepository() => _instance;

  late Box<GenderModel> _gendersBox;

  Future<void> initialize() async {
    await Hive.initFlutter();
    Hive.registerAdapter<GenderModel>(GenderModelAdapter());
    _gendersBox = await Hive.openBox<GenderModel>(_genderBox);
  }

  Future<void> saveGenderItems(List<GenderDto> gendersDto) async {
    for (var genderDto in gendersDto) {
      await _gendersBox.put(
          genderDto.genderId,
          (GenderModel(
              genderId: genderDto.genderId,
              description: genderDto.description)));
    }
  }

  Future<void> saveGender(GenderDto genderDto) async {
    await _gendersBox.put(
        genderDto.genderId,
        GenderModel(
            genderId: genderDto.genderId, description: genderDto.description));
  }

  Future<void> deleteGender(int id) async {
    await _gendersBox.delete(id);
  }

  Future<void> deleteAllGenders() async {
    await _gendersBox.clear();
  }

  List<GenderDto> getAllGenders() {
    return _gendersBox.values.map(genderFromDb).toList();
  }

  GenderDto? getGenderById(int id) {
    final bookDb = _gendersBox.get(id);
    if (bookDb != null) {
      return genderFromDb(bookDb);
    }
    return null;
  }

  GenderDto genderFromDb(GenderModel? genderModel) => GenderDto(
      genderId: genderModel?.genderId, description: genderModel?.description);

  GenderModel genderToDb(GenderDto? genderDto) => GenderModel(
      genderId: genderDto?.genderId, description: genderDto?.description);
}
