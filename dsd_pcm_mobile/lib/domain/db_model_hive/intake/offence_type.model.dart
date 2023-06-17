import 'package:hive/hive.dart';

part 'offence_type.model.g.dart';

@HiveType(typeId: 22)
class OffenceTypeModel {
  @HiveField(0)
  final int? offenceTypeId;
  @HiveField(1)
  final String? description;

  OffenceTypeModel({this.offenceTypeId, this.description});
}
