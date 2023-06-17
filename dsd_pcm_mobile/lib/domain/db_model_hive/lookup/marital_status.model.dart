import 'package:hive/hive.dart';

part 'marital_status.model.g.dart';

@HiveType(typeId: 10)
class MaritalStatusModel {
  @HiveField(0)
  final int? maritalStatusId;
  @HiveField(1)
  final String? description;

  MaritalStatusModel({this.maritalStatusId, this.description});
}
