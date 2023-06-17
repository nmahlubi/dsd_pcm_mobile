import 'package:hive/hive.dart';

part 'nationality.model.g.dart';

@HiveType(typeId: 9)
class NationalityModel {
  @HiveField(0)
  final int? nationalityId;
  @HiveField(1)
  final String? description;

  NationalityModel({this.nationalityId, this.description});
}
