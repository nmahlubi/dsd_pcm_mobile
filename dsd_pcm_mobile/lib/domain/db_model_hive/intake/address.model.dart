import 'package:hive/hive.dart';

import 'address_type.model.dart';

part 'address.model.g.dart';

@HiveType(typeId: 31)
class AddressModel {
  @HiveField(0)
  int? addressId;
  @HiveField(1)
  int? addressTypeId;
  @HiveField(2)
  String? addressLine1;
  @HiveField(3)
  String? addressLine2;
  @HiveField(4)
  int? townId;
  @HiveField(5)
  String? postalCode;
  @HiveField(6)
  String? addressType;
  @HiveField(7)
  final AddressTypeModel? addressTypeModel;

  AddressModel(
      {this.addressId,
      this.addressTypeId,
      this.addressLine1,
      this.addressLine2,
      this.townId,
      this.postalCode,
      this.addressType,
      this.addressTypeModel});
}
