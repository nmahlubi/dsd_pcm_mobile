import 'package:hive/hive.dart';

part 'school_type.model.g.dart';

@HiveType(typeId: 40)
class SchoolTypeModel {
  @HiveField(0)
  final int? schoolTypeId;
  @HiveField(1)
  final String? description;

  SchoolTypeModel({this.schoolTypeId, this.description});
}
