import 'package:hive/hive.dart';

part 'address_type.model.g.dart';

@HiveType(typeId: 17)
class AddressTypeModel {
  @HiveField(0)
  final int? addressTypeId;
  @HiveField(1)
  final String? description;

  AddressTypeModel({this.addressTypeId, this.description});
}
