import 'package:hive/hive.dart';

part 'health_status.model.g.dart';

@HiveType(typeId: 6)
class HealthStatusModel {
  @HiveField(0)
  final int? healthStatusId;
  @HiveField(1)
  final String? description;

  HealthStatusModel({this.healthStatusId, this.description});
}
