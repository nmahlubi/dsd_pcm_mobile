import 'package:hive/hive.dart';

part 'disability_type.model.g.dart';

@HiveType(typeId: 7)
class DisabilityTypeModel {
  @HiveField(0)
  final int? disabilityTypeId;
  @HiveField(1)
  final String? typeName;

  DisabilityTypeModel({this.disabilityTypeId, this.typeName});
}
