import 'package:hive/hive.dart';

part 'placement_type.model.g.dart';

@HiveType(typeId: 13)
class PlacementTypeModel {
  @HiveField(0)
  final int? placementTypeId;
  @HiveField(1)
  final String? description;

  PlacementTypeModel({this.placementTypeId, this.description});
}
