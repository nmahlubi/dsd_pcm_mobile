import '../model/intake/grade_dto.dart';
import '../model/intake/school_dto.dart';
import '../model/intake/school_type_dto.dart';
import '../service/intake/school_service.dart';
import '../util/shared/apiresponse.dart';

class SchoolTransform {
  final _schoolServiceClient = SchoolService();
  late ApiResponse apiResponse = ApiResponse();
  late List<GradeDto> gradesDto = [];
  late List<SchoolTypeDto> schoolTypesDto = [];
  late List<SchoolDto> schoolsDto = [];

  Future<List<GradeDto>> transformGradesDto() async {
    apiResponse = await _schoolServiceClient.getSchoolGrades();
    if ((apiResponse.ApiError) == null) {
      gradesDto = (apiResponse.Data as List<GradeDto>);
    }
    return gradesDto;
  }

  Future<List<SchoolTypeDto>> transformSchoolTypesDto() async {
    apiResponse = await _schoolServiceClient.getSchoolTypes();
    if ((apiResponse.ApiError) == null) {
      schoolTypesDto = (apiResponse.Data as List<SchoolTypeDto>);
    }
    return schoolTypesDto;
  }

  Future<List<SchoolDto>> transformSchoolsDto(int? schoolTypeId) async {
    apiResponse = await _schoolServiceClient.getSchoolsByTypeId(schoolTypeId);
    if ((apiResponse.ApiError) == null) {
      schoolsDto = (apiResponse.Data as List<SchoolDto>);
    }
    return schoolsDto;
  }
}
