import 'package:hive_flutter/adapters.dart';

import '../../../model/intake/language_dto.dart';
import '../../db_model_hive/lookup/language.model.dart';

const String languageBox = 'languageBox';

class LanguageRepository {
  LanguageRepository._constructor();

  static final LanguageRepository _instance = LanguageRepository._constructor();

  factory LanguageRepository() => _instance;

  late Box<LanguageModel> _languagesBox;

  Future<void> initialize() async {
    await Hive.initFlutter();
    Hive.registerAdapter<LanguageModel>(LanguageModelAdapter());
    _languagesBox = await Hive.openBox<LanguageModel>(languageBox);
  }

  Future<void> saveLanguageItems(List<LanguageDto> languagesDto) async {
    for (var languageDto in languagesDto) {
      await _languagesBox.put(
          languageDto.languageId,
          (LanguageModel(
              languageId: languageDto.languageId,
              description: languageDto.description)));
    }
  }

  Future<void> saveLanguage(LanguageDto languageDto) async {
    await _languagesBox.put(
        languageDto.languageId,
        LanguageModel(
            languageId: languageDto.languageId,
            description: languageDto.description));
  }

  Future<void> deleteLanguage(int id) async {
    await _languagesBox.delete(id);
  }

  Future<void> deleteAllLanguages() async {
    await _languagesBox.clear();
  }

  List<LanguageDto> getAllLanguages() {
    return _languagesBox.values.map(languageFromDb).toList();
  }

  LanguageDto? getLanguageById(int id) {
    final bookDb = _languagesBox.get(id);
    if (bookDb != null) {
      return languageFromDb(bookDb);
    }
    return null;
  }

  LanguageDto languageFromDb(LanguageModel languageModel) => LanguageDto(
        languageId: languageModel.languageId,
        description: languageModel.description,
      );

  LanguageModel languageToDb(LanguageDto? languageDto) => LanguageModel(
      languageId: languageDto?.languageId,
      description: languageDto?.description);
}
