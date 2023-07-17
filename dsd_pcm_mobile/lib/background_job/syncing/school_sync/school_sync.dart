import 'dart:io';

import 'package:flutter/foundation.dart';

import '../../../domain/repository/school/grade_repository.dart';
import '../../../domain/repository/school/school_repository.dart';
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
  final _schoolRepository = SchoolRepository();
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
        //await _schoolTypeRepository.deleteAllSchoolTypes();
        //await _schoolTypeRepository.saveSchoolTypeItems(schoolTypesDto);
        if (schoolTypesDto.isNotEmpty) {
          for (var schoolTypeDto in schoolTypesDto) {
            await _schoolRepository
                .deleteSchoolByType(schoolTypeDto.schoolTypeId);
            await _schoolTypeRepository
                .deleteSchoolType(schoolTypeDto.schoolTypeId!);
            await _schoolTypeRepository.saveSchoolType(schoolTypeDto);
            await syncSchoolBySchoolType(schoolTypeDto.schoolTypeId);
          }
        }
      }
    } on SocketException catch (_) {
      if (kDebugMode) {
        print('Unable to access _schoolService.syncSchoolTypes endpoint');
      }
    }
  }

  Future<void> syncSchoolBySchoolType(int? schoolTypeId) async {
    try {
      apiResponse = await _schoolService.getSchoolsByTypeIdOnline(schoolTypeId);
      if ((apiResponse.ApiError) == null) {
        schoolsDto = (apiResponse.Data as List<SchoolDto>);
        await _schoolRepository.saveSchoolItems(schoolsDto);
      }
    } on SocketException catch (_) {
      if (kDebugMode) {
        print(
            'Unable to access _schoolService.syncSchoolBySchoolType endpoint');
      }
    }
  }
}
