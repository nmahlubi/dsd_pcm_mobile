import 'dart:convert';
import 'dart:io';
import 'package:dsd_pcm_mobile/domain/repository/school/grade_repository.dart';
import 'package:dsd_pcm_mobile/model/intake/school_type_dto.dart';
import 'package:http_interceptor/http/intercepted_client.dart';

import '../../domain/repository/school/school_repository.dart';
import '../../domain/repository/school/school_type_repository.dart';
import '../../model/intake/grade_dto.dart';
import '../../model/intake/school_dto.dart';
import '../../util/app_url.dart';
import '../../util/auth_intercept/authorization_interceptor.dart';
import '../../util/shared/apierror.dart';
import '../../util/shared/apiresponse.dart';

class SchoolService {
  final client =
      InterceptedClient.build(interceptors: [AuthorizationInterceptor()]);
  final gradeRepository = GradeRepository();
  final schoolTypeRepository = SchoolTypeRepository();
  final schoolRepository = SchoolRepository();

  Future<ApiResponse> getSchoolGradesOnline() async {
    ApiResponse apiResponse = ApiResponse();
    final response =
        await client.get(Uri.parse("${AppUrl.intakeURL}/School/Grades"));
    switch (response.statusCode) {
      case 200:
        apiResponse.Data = (json.decode(response.body) as List)
            .map((data) => GradeDto.fromJson(data))
            .toList();
        break;
      default:
        apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
        break;
    }
    return apiResponse;
  }

  Future<ApiResponse> getSchoolGrades() async {
    ApiResponse apiResponse = ApiResponse();
    try {
      if (gradeRepository.getAllGrades().isNotEmpty) {
        apiResponse.Data = gradeRepository.getAllGrades();
        return apiResponse;
      }
      apiResponse = await getSchoolGradesOnline();
      if (apiResponse.ApiError == null) {
        List<GradeDto> gradesDtoResponse = apiResponse.Data as List<GradeDto>;
        apiResponse.Data = gradesDtoResponse;
        gradeRepository.saveGradeItems(gradesDtoResponse);
      }
    } on SocketException {
      apiResponse.Data = gradeRepository.getAllGrades();
    }
    return apiResponse;
  }

  Future<ApiResponse> getSchoolTypesOnline() async {
    ApiResponse apiResponse = ApiResponse();
    final response =
        await client.get(Uri.parse("${AppUrl.intakeURL}/School/Type/GetAll"));
    switch (response.statusCode) {
      case 200:
        apiResponse.Data = (json.decode(response.body) as List)
            .map((data) => SchoolTypeDto.fromJson(data))
            .toList();
        break;
      default:
        apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
        break;
    }
    return apiResponse;
  }

  Future<ApiResponse> getSchoolTypes() async {
    ApiResponse apiResponse = ApiResponse();
    try {
      if (schoolTypeRepository.getAllSchoolTypes().isNotEmpty) {
        apiResponse.Data = schoolTypeRepository.getAllSchoolTypes();
        return apiResponse;
      }
      apiResponse = await getSchoolTypesOnline();
      if (apiResponse.ApiError == null) {
        List<SchoolTypeDto> schoolTypeDtoResponse =
            apiResponse.Data as List<SchoolTypeDto>;
        apiResponse.Data = schoolTypeDtoResponse;
        schoolTypeRepository.saveSchoolTypeItems(schoolTypeDtoResponse);
      }
    } on SocketException {
      apiResponse.Data = schoolTypeRepository.getAllSchoolTypes();
    }
    return apiResponse;
  }
  //dfdfdf

  Future<ApiResponse> getSchoolsByTypeIdOnline(int? schoolTypeId) async {
    ApiResponse apiResponse = ApiResponse();
    final response = await client
        .get(Uri.parse("${AppUrl.intakeURL}/School/GetAll/$schoolTypeId"));
    switch (response.statusCode) {
      case 200:
        apiResponse.Data = (json.decode(response.body) as List)
            .map((data) => SchoolDto.fromJson(data))
            .toList();
        break;
      default:
        apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
        break;
    }
    return apiResponse;
  }

  Future<ApiResponse> getSchoolsByTypeId(int? schoolTypeId) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      if (schoolRepository.getSchoolsByType(schoolTypeId).isNotEmpty) {
        apiResponse.Data = schoolRepository.getSchoolsByType(schoolTypeId);
        return apiResponse;
      }
      apiResponse = await getSchoolsByTypeIdOnline(schoolTypeId);
      if (apiResponse.ApiError == null) {
        List<SchoolDto> schoolDtoResponse = apiResponse.Data as List<SchoolDto>;
        apiResponse.Data = schoolDtoResponse;
        schoolRepository.saveSchoolItems(schoolDtoResponse);
      }
    } on SocketException {
      apiResponse.Data = schoolRepository.getSchoolsByType(schoolTypeId);
    }
    return apiResponse;
  }
}
