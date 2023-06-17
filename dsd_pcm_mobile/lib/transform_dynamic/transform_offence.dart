import '../model/intake/offence_category_dto.dart';
import '../model/intake/offence_schedule_dto.dart';
import '../model/intake/offence_type_dto.dart';
import '../service/intake/offence_service.dart';
import '../util/shared/apiresponse.dart';

class OffenceTransform {
  final _offenceServiceClient = OffenceService();
  late ApiResponse apiResponse = ApiResponse();
  late List<OffenceTypeDto> offenceTypesDto = [];
  late List<OffenceScheduleDto> offenceSchedulesDto = [];
  late List<OffenceCategoryDto> offenceCategoriesDto = [];

  Future<List<OffenceCategoryDto>> transformOffenceCategoryDto() async {
    apiResponse = await _offenceServiceClient.getOffenceCategories();
    if ((apiResponse.ApiError) == null) {
      offenceCategoriesDto = (apiResponse.Data as List<OffenceCategoryDto>);
    }
    return offenceCategoriesDto;
  }

  Future<List<OffenceScheduleDto>> transformOffenceScheduleDto() async {
    apiResponse = await _offenceServiceClient.getOffenceSchedules();
    if ((apiResponse.ApiError) == null) {
      offenceSchedulesDto = (apiResponse.Data as List<OffenceScheduleDto>);
    }
    return offenceSchedulesDto;
  }

  Future<List<OffenceTypeDto>> transformOffenceTypeDto() async {
    apiResponse = await _offenceServiceClient.getOffenceTypes();
    if ((apiResponse.ApiError) == null) {
      offenceTypesDto = (apiResponse.Data as List<OffenceTypeDto>);
    }
    return offenceTypesDto;
  }
}
