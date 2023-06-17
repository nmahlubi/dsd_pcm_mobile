import 'package:hive_flutter/adapters.dart';

import '../../../model/intake/address_type_dto.dart';
import '../../db_model_hive/intake/address_type.model.dart';

const String addressTypeBox = 'addressTypeBox';

class AddressTypeRepository {
  AddressTypeRepository._constructor();

  static final AddressTypeRepository _instance =
      AddressTypeRepository._constructor();

  factory AddressTypeRepository() => _instance;

  late Box<AddressTypeModel> _addressTypesBox;

  Future<void> initialize() async {
    await Hive.initFlutter();
    Hive.registerAdapter<AddressTypeModel>(AddressTypeModelAdapter());
    _addressTypesBox = await Hive.openBox<AddressTypeModel>(addressTypeBox);
  }

  Future<void> saveAddressTypeItems(
      List<AddressTypeDto> addressTypesDto) async {
    for (var addressTypeDto in addressTypesDto) {
      await _addressTypesBox.put(
          addressTypeDto.addressTypeId,
          (AddressTypeModel(
              addressTypeId: addressTypeDto.addressTypeId,
              description: addressTypeDto.description)));
    }
  }

  Future<void> saveAddressType(AddressTypeDto addressTypeDto) async {
    await _addressTypesBox.put(
        addressTypeDto.addressTypeId,
        AddressTypeModel(
            addressTypeId: addressTypeDto.addressTypeId,
            description: addressTypeDto.description));
  }

  Future<void> deleteAddressType(int id) async {
    await _addressTypesBox.delete(id);
  }

  Future<void> deleteAllAddressTypes() async {
    await _addressTypesBox.clear();
  }

  List<AddressTypeDto> getAllAddressTypes() {
    return _addressTypesBox.values.map(addressTypeFromDb).toList();
  }

  AddressTypeDto? getAddressTypeById(int id) {
    final bookDb = _addressTypesBox.get(id);
    if (bookDb != null) {
      return addressTypeFromDb(bookDb);
    }
    return null;
  }

  AddressTypeDto addressTypeFromDb(AddressTypeModel addressTypeModel) =>
      AddressTypeDto(
          addressTypeId: addressTypeModel.addressTypeId,
          description: addressTypeModel.description);

  AddressTypeModel addressTypeToDb(AddressTypeDto? addressTypeDto) =>
      AddressTypeModel(
          addressTypeId: addressTypeDto?.addressTypeId,
          description: addressTypeDto?.description);
}
