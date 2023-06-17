import 'package:hive/hive.dart';

part 'gender.model.g.dart';

@HiveType(typeId: 3)
class GenderModel {
  @HiveField(0)
  final int? genderId;
  @HiveField(1)
  final String? description;

  GenderModel({this.genderId, this.description});
}
