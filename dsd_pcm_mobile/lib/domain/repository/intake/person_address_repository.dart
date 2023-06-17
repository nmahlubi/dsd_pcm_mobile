import 'package:hive_flutter/adapters.dart';

import '../../../model/intake/person_address_dto.dart';
import '../../db_model_hive/intake/person_address.model.dart';
import 'address_repository.dart';

const String personAddressBox = 'personAddresBox';

class PersonAddressRepository {
  PersonAddressRepository._constructor();
  final _addressRepository = AddressRepository();

  static final PersonAddressRepository _instance =
      PersonAddressRepository._constructor();

  factory PersonAddressRepository() => _instance;

  late Box<PersonAddressModel> _personAddresssBox;

  Future<void> initialize() async {
    await Hive.initFlutter();
    Hive.registerAdapter<PersonAddressModel>(PersonAddressModelAdapter());
    _personAddresssBox =
        await Hive.openBox<PersonAddressModel>(personAddressBox);
  }

  Future<void> savePersonAddressItems(
      List<PersonAddressDto> personAddresssDto) async {
    for (var personAddressDto in personAddresssDto) {
      await _personAddresssBox.put(
          personAddressDto.addressId,
          (PersonAddressModel(
              personId: personAddressDto.personId,
              addressId: personAddressDto.addressId,
              addressModel: personAddressDto.addressDto != null
                  ? _addressRepository.addressToDb(personAddressDto.addressDto)
                  : null)));
    }
  }

  Future<void> savePersonAddress(PersonAddressDto personAddressDto) async {
    await _personAddresssBox.put(
        personAddressDto.addressId,
        PersonAddressModel(
            personId: personAddressDto.personId,
            addressId: personAddressDto.addressId,
            addressModel: personAddressDto.addressDto != null
                ? _addressRepository.addressToDb(personAddressDto.addressDto)
                : null));
  }

  List<PersonAddressDto> getPersonAddressByPersonId(int? personId) {
    var personAddressDtoItems = _personAddresssBox.values
        .where((address) => address.personId == personId)
        .toList();
    return personAddressDtoItems.map(personAddressFromDb).toList();
  }

  List<PersonAddressDto> getAllPersonAddresss() {
    return _personAddresssBox.values.map(personAddressFromDb).toList();
  }

  PersonAddressDto? getPersonAddressById(int id) {
    final bookDb = _personAddresssBox.get(id);
    if (bookDb != null) {
      return personAddressFromDb(bookDb);
    }
    return null;
  }

  Future<void> deletePersonAddress(int id) async {
    await _personAddresssBox.delete(id);
  }

  Future<void> deleteAllPersonAddresss() async {
    await _personAddresssBox.clear();
  }

  PersonAddressDto personAddressFromDb(PersonAddressModel personAddressModel) =>
      PersonAddressDto(
          personId: personAddressModel.personId,
          addressId: personAddressModel.addressId,
          addressDto: personAddressModel.addressModel != null
              ? _addressRepository
                  .addressFromDb(personAddressModel.addressModel!)
              : null);

  PersonAddressModel personAddressToDb(PersonAddressDto? personAddressDto) =>
      PersonAddressModel(
          personId: personAddressDto?.personId,
          addressId: personAddressDto?.addressId,
          addressModel: personAddressDto?.addressDto != null
              ? _addressRepository.addressToDb(personAddressDto?.addressDto!)
              : null);
}
