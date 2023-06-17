import 'package:hive/hive.dart';

part 'offence_category.model.g.dart';

@HiveType(typeId: 23)
class OffenceCategoryModel {
  @HiveField(0)
  final int? offenceCategoryId;
  @HiveField(1)
  final String? description;

  OffenceCategoryModel({this.offenceCategoryId, this.description});
}
