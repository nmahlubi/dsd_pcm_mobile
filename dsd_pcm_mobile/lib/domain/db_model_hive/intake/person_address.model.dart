import 'package:hive/hive.dart';

import 'address.model.dart';

part 'person_address.model.g.dart';

@HiveType(typeId: 32)
class PersonAddressModel {
  @HiveField(0)
  int? personId;
  @HiveField(1)
  int? addressId;
  @HiveField(2)
  final AddressModel? addressModel;

  PersonAddressModel({this.personId, this.addressId, this.addressModel});
}
