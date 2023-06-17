import 'package:hive/hive.dart';

part 'preferred_contact_type.model.g.dart';

@HiveType(typeId: 12)
class PreferredContactTypeModel {
  @HiveField(0)
  final int? preferredContactTypeId;
  @HiveField(1)
  final String? description;

  PreferredContactTypeModel({this.preferredContactTypeId, this.description});
}
