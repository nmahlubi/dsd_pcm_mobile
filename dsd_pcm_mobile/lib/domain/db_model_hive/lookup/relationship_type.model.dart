import 'package:hive/hive.dart';

part 'relationship_type.model.g.dart';

@HiveType(typeId: 5)
class RelationshipTypeModel {
  @HiveField(0)
  final int? relationshipTypeId;
  @HiveField(1)
  final String? description;

  RelationshipTypeModel({this.relationshipTypeId, this.description});
}
