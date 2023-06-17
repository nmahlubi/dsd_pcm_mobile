import 'package:hive_flutter/adapters.dart';

import '../../../model/intake/address_dto.dart';
import '../../db_model_hive/intake/address.model.dart';
import 'address_type_repository.dart';

const String addressBox = 'addressDtoBox';

class AddressRepository {
  AddressRepository._constructor();
  final _addressTypeRepository = AddressTypeRepository();

  static final AddressRepository _instance = AddressRepository._constructor();

  factory AddressRepository() => _instance;

  late Box<AddressModel> _addressBox;

  Future<void> initialize() async {
    await Hive.initFlutter();
    Hive.registerAdapter<AddressModel>(AddressModelAdapter());
    _addressBox = await Hive.openBox<AddressModel>(addressBox);
  }

  Future<void> saveAddressItems(List<AddressDto> addressDto) async {
    for (var address in addressDto) {
      await _addressBox.put(
          address.addressId,
          (AddressModel(
              addressId: address.addressId,
              addressTypeId: address.addressTypeId,
              addressLine1: address.addressLine1,
              addressLine2: address.addressLine2,
              townId: address.townId,
              postalCode: address.postalCode,
              addressType: address.addressType,
              addressTypeModel: address.addressTypeDto != null
                  ? _addressTypeRepository
                      .addressTypeToDb(address.addressTypeDto)
                  : null)));
    }
  }

  Future<void> saveAddress(AddressDto address) async {
    await _addressBox.put(
        address.addressId,
        AddressModel(
            addressId: address.addressId,
            addressTypeId: address.addressTypeId,
            addressLine1: address.addressLine1,
            addressLine2: address.addressLine2,
            townId: address.townId,
            postalCode: address.postalCode,
            addressType: address.addressType,
            addressTypeModel: address.addressTypeDto != null
                ? _addressTypeRepository.addressTypeToDb(address.addressTypeDto)
                : null));
  }

  List<AddressDto> getAllAddress() {
    return _addressBox.values.map(addressFromDb).toList();
  }

  AddressDto? getAddressById(int id) {
    final bookDb = _addressBox.get(id);
    if (bookDb != null) {
      return addressFromDb(bookDb);
    }
    return null;
  }

  Future<void> deleteAddressById(int id) async {
    await _addressBox.delete(id);
  }

  Future<void> deleteAllAddress() async {
    await _addressBox.clear();
  }

  AddressDto addressFromDb(AddressModel addressModel) => AddressDto(
      addressId: addressModel.addressId,
      addressTypeId: addressModel.addressTypeId,
      addressLine1: addressModel.addressLine1,
      addressLine2: addressModel.addressLine2,
      townId: addressModel.townId,
      postalCode: addressModel.postalCode,
      addressType: addressModel.addressType,
      addressTypeDto: addressModel.addressTypeModel != null
          ? _addressTypeRepository
              .addressTypeFromDb(addressModel.addressTypeModel!)
          : null);

  AddressModel addressToDb(AddressDto? addressDto) => AddressModel(
      addressId: addressDto!.addressId,
      addressTypeId: addressDto.addressTypeId,
      addressLine1: addressDto.addressLine1,
      addressLine2: addressDto.addressLine2,
      townId: addressDto.townId,
      postalCode: addressDto.postalCode,
      addressType: addressDto.addressType,
      addressTypeModel: addressDto.addressTypeDto != null
          ? _addressTypeRepository.addressTypeToDb(addressDto.addressTypeDto!)
          : null);
}
