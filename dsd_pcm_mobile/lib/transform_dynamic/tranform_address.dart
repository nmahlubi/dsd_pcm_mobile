import '../model/intake/address_type_dto.dart';
import '../service/intake/address_service.dart';
import '../util/shared/apiresponse.dart';

class AddressTransform {
  final _addressServiceClient = AddressService();
  late ApiResponse apiResponse = ApiResponse();
  late List<AddressTypeDto> addressTypesDto = [];

  Future<List<AddressTypeDto>> transformAddressTypesDto() async {
    apiResponse = await _addressServiceClient.getAddressTypes();
    if ((apiResponse.ApiError) == null) {
      addressTypesDto = (apiResponse.Data as List<AddressTypeDto>);
    }
    return addressTypesDto;
  }
}
