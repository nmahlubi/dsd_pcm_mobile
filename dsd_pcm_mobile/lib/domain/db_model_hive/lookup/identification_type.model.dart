import 'package:hive/hive.dart';

part 'identification_type.model.g.dart';

@HiveType(typeId: 11)
class IdentificationTypeModel {
  @HiveField(0)
  final int? identificationTypeId;
  @HiveField(1)
  final String? description;

  IdentificationTypeModel({this.identificationTypeId, this.description});
}
