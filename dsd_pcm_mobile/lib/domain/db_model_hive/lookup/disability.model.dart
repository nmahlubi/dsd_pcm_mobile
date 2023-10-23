import 'package:hive/hive.dart';

part 'disability.model.g.dart';

@HiveType(typeId: 8)
class DisabilityModel {
  @HiveField(0)
  final int? disabilityId;
  @HiveField(1)
  final String? description;

  DisabilityModel({this.disabilityId, this.description});
}
