import 'package:hive_flutter/adapters.dart';

import '../../../model/intake/offence_category_dto.dart';
import '../../db_model_hive/intake/offence_category.model.dart';

const String offenceCategoryBox = 'offenceCategoryBox';

class OffenceCategoryRepository {
  OffenceCategoryRepository._constructor();

  static final OffenceCategoryRepository _instance =
      OffenceCategoryRepository._constructor();

  factory OffenceCategoryRepository() => _instance;

  late Box<OffenceCategoryModel> _offenceCategorysBox;

  Future<void> initialize() async {
    await Hive.initFlutter();
    Hive.registerAdapter<OffenceCategoryModel>(OffenceCategoryModelAdapter());
    _offenceCategorysBox =
        await Hive.openBox<OffenceCategoryModel>(offenceCategoryBox);
  }

  Future<void> saveOffenceCategoryItems(
      List<OffenceCategoryDto> offenceCategoriesDto) async {
    for (var offenceCategoryDto in offenceCategoriesDto) {
      await _offenceCategorysBox.put(
          offenceCategoryDto.offenceCategoryId,
          (OffenceCategoryModel(
              offenceCategoryId: offenceCategoryDto.offenceCategoryId,
              description: offenceCategoryDto.description)));
    }
  }

  Future<void> saveOffenceCategory(
      OffenceCategoryDto offenceCategoryDto) async {
    await _offenceCategorysBox.put(
        offenceCategoryDto.offenceCategoryId,
        OffenceCategoryModel(
            offenceCategoryId: offenceCategoryDto.offenceCategoryId,
            description: offenceCategoryDto.description));
  }

  Future<void> deleteOffenceCategory(int id) async {
    await _offenceCategorysBox.delete(id);
  }

  Future<void> deleteAllOffenceCategorys() async {
    await _offenceCategorysBox.clear();
  }

  List<OffenceCategoryDto> getAllOffenceCategorys() {
    return _offenceCategorysBox.values.map(offenceCategoryFromDb).toList();
  }

  OffenceCategoryDto? getOffenceCategoryById(int id) {
    final bookDb = _offenceCategorysBox.get(id);
    if (bookDb != null) {
      return offenceCategoryFromDb(bookDb);
    }
    return null;
  }

  OffenceCategoryDto offenceCategoryFromDb(
          OffenceCategoryModel? offenceCategoryModel) =>
      OffenceCategoryDto(
          offenceCategoryId: offenceCategoryModel?.offenceCategoryId,
          description: offenceCategoryModel?.description);

  OffenceCategoryModel offenceCategoryToDb(
          OffenceCategoryDto? offenceCategoryDto) =>
      OffenceCategoryModel(
          offenceCategoryId: offenceCategoryDto?.offenceCategoryId,
          description: offenceCategoryDto?.description);
}
