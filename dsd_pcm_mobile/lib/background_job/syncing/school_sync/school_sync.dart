import 'dart:io';

import 'package:flutter/foundation.dart';

import '../../../domain/repository/school/grade_repository.dart';
import '../../../domain/repository/school/school_type_repository.dart';
import '../../../model/intake/grade_dto.dart';
import '../../../model/intake/school_dto.dart';
import '../../../model/intake/school_type_dto.dart';
import '../../../service/intake/school_service.dart';
import '../../../util/shared/apiresponse.dart';

class SchoolSync {
  final _schoolService = SchoolService();
  final _gradeRepository = GradeRepository();
  final _schoolTypeRepository = SchoolTypeRepository();

  late ApiResponse apiResponse = ApiResponse();
  late List<GradeDto> gradesDto = [];
  late List<SchoolTypeDto> schoolTypesDto = [];
  late List<SchoolDto> schoolsDto = [];

  Future<void> syncGrades() async {
    try {
      apiResponse = await _schoolService.getSchoolGradesOnline();
      if ((apiResponse.ApiError) == null) {
        gradesDto = (apiResponse.Data as List<GradeDto>);
        await _gradeRepository.deleteAllGrades();
        await _gradeRepository.saveGradeItems(gradesDto);
      }
    } on SocketException catch (_) {
      if (kDebugMode) {
        print('Unable to access _schoolService.syncGrades endpoint');
      }
    }
  }

  Future<void> syncSchoolTypes() async {
    try {
      apiResponse = await _schoolService.getSchoolTypesOnline();
      if ((apiResponse.ApiError) == null) {
        schoolTypesDto = (apiResponse.Data as List<SchoolTypeDto>);
        if (schoolTypesDto.isNotEmpty) {
          await _schoolTypeRepository.saveSchoolTypeItems(schoolTypesDto);
        }
      }
    } on SocketException catch (_) {
      if (kDebugMode) {
        print('Unable to access _schoolService.syncSchoolTypes endpoint');
      }
    }
  }
}
