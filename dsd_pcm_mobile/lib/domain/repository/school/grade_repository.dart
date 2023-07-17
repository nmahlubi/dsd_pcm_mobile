import 'package:hive_flutter/adapters.dart';

import '../../../model/intake/grade_dto.dart';
import '../../db_model_hive/school/grade.model.dart';

const String gradeBox = 'gradeBox';

class GradeRepository {
  GradeRepository._constructor();

  static final GradeRepository _instance = GradeRepository._constructor();

  factory GradeRepository() => _instance;

  late Box<GradeModel> _gradesBox;

  Future<void> initialize() async {
    await Hive.initFlutter();
    Hive.registerAdapter<GradeModel>(GradeModelAdapter());
    _gradesBox = await Hive.openBox<GradeModel>(gradeBox);
  }

  Future<void> saveGradeItems(List<GradeDto> gradesDto) async {
    for (var gradeDto in gradesDto) {
      await _gradesBox.put(
          gradeDto.gradeId,
          (GradeModel(
              gradeId: gradeDto.gradeId, description: gradeDto.description)));
    }
  }

  Future<void> saveGrade(GradeDto gradeDto) async {
    await _gradesBox.put(
        gradeDto.gradeId,
        GradeModel(
            gradeId: gradeDto.gradeId, description: gradeDto.description));
  }

  Future<void> deleteGrade(int id) async {
    await _gradesBox.delete(id);
  }

  Future<void> deleteAllGrades() async {
    await _gradesBox.clear();
  }

  List<GradeDto> getAllGrades() {
    return _gradesBox.values.map(gradeFromDb).toList();
  }

  GradeDto? getGradeById(int id) {
    final bookDb = _gradesBox.get(id);
    if (bookDb != null) {
      return gradeFromDb(bookDb);
    }
    return null;
  }

  GradeDto gradeFromDb(GradeModel gradeModel) => GradeDto(
        gradeId: gradeModel.gradeId,
        description: gradeModel.description,
      );

  GradeModel gradeToDb(GradeDto? gradeDto) => GradeModel(
      gradeId: gradeDto?.gradeId, description: gradeDto?.description);
}
