import 'package:hive/hive.dart';

part 'grade.model.g.dart';

@HiveType(typeId: 39)
class GradeModel {
  @HiveField(0)
  final int? gradeId;
  @HiveField(1)
  final String? description;

  GradeModel({this.gradeId, this.description});
}
