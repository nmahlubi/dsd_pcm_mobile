// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:convert';
import 'dart:io';
import 'package:http_interceptor/http/intercepted_client.dart';

import '../../domain/repository/intake/offence_category_repository.dart';
import '../../domain/repository/intake/offence_schedule_repository.dart';
import '../../domain/repository/intake/offence_type_repository.dart';
import '../../model/intake/offence_category_dto.dart';
import '../../model/intake/offence_schedule_dto.dart';
import '../../model/intake/offence_type_dto.dart';
import '../../util/app_url.dart';
import '../../util/auth_intercept/authorization_interceptor.dart';
import '../../util/shared/apierror.dart';
import '../../util/shared/apiresponse.dart';

class OffenceService {
  final client =
      InterceptedClient.build(interceptors: [AuthorizationInterceptor()]);
  final _offenceTypeRepository = OffenceTypeRepository();
  final _offenceCategoryRepository = OffenceCategoryRepository();
  final _offenceScheduleRepository = OffenceScheduleRepository();

  Future<ApiResponse> getOffenceTypes() async {
    ApiResponse apiResponse = ApiResponse();
    try {
      if (_offenceTypeRepository.getAllOffenceTypes().isNotEmpty) {
        apiResponse.Data = _offenceTypeRepository.getAllOffenceTypes();
        return apiResponse;
      }
      final response = await client
          .get(Uri.parse("${AppUrl.intakeURL}/Offence/Type/GetAll"));

      switch (response.statusCode) {
        case 200:
          List<OffenceTypeDto> offenceTypeDtoResponse =
              (json.decode(response.body) as List)
                  .map((data) => OffenceTypeDto.fromJson(data))
                  .toList();
          apiResponse.Data = offenceTypeDtoResponse;
          _offenceTypeRepository.saveOffenceTypeItems(offenceTypeDtoResponse);
          break;
        default:
          apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
          break;
      }
    } on SocketException {
      apiResponse.Data = _offenceTypeRepository.getAllOffenceTypes();
    }
    return apiResponse;
  }

  Future<ApiResponse> getOffenceTypesByCategorySchedule(
      int? offenceCategoryId, int? offenceScheduleId) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      if (_offenceTypeRepository.getAllOffenceTypes().isNotEmpty) {
        apiResponse.Data = _offenceTypeRepository.getAllOffenceTypes();
        return apiResponse;
      }
      final response = await client.get(Uri.parse(
          "${AppUrl.intakeURL}/Offence/Type/Category/Schedule/${offenceCategoryId}/${offenceScheduleId}"));

      switch (response.statusCode) {
        case 200:
          apiResponse.Data = (json.decode(response.body) as List)
              .map((data) => OffenceTypeDto.fromJson(data))
              .toList();

          List<OffenceTypeDto> offenceTypeDtoResponse =
              (json.decode(response.body) as List)
                  .map((data) => OffenceTypeDto.fromJson(data))
                  .toList();
          apiResponse.Data = offenceTypeDtoResponse;
          _offenceTypeRepository.saveOffenceTypeItems(offenceTypeDtoResponse);
          break;
        default:
          apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
          break;
      }
    } on SocketException {
      apiResponse.Data = _offenceTypeRepository.getAllOffenceTypes();
    }
    return apiResponse;
  }

  Future<ApiResponse> getOffenceCategories() async {
    ApiResponse apiResponse = ApiResponse();
    try {
      if (_offenceCategoryRepository.getAllOffenceCategorys().isNotEmpty) {
        apiResponse.Data = _offenceCategoryRepository.getAllOffenceCategorys();
        return apiResponse;
      }
      final response = await client
          .get(Uri.parse("${AppUrl.intakeURL}/Offence/Category/GetAll"));

      switch (response.statusCode) {
        case 200:
          List<OffenceCategoryDto> offenceCategoryDtoDtoResponse =
              (json.decode(response.body) as List)
                  .map((data) => OffenceCategoryDto.fromJson(data))
                  .toList();
          apiResponse.Data = offenceCategoryDtoDtoResponse;
          _offenceCategoryRepository
              .saveOffenceCategoryItems(offenceCategoryDtoDtoResponse);
          break;
        default:
          apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
          break;
      }
    } on SocketException {
      apiResponse.Data = _offenceCategoryRepository.getAllOffenceCategorys();
    }
    return apiResponse;
  }

  Future<ApiResponse> getOffenceSchedules() async {
    ApiResponse apiResponse = ApiResponse();
    try {
      if (_offenceScheduleRepository.getAllOffenceSchedules().isNotEmpty) {
        apiResponse.Data = _offenceScheduleRepository.getAllOffenceSchedules();
        return apiResponse;
      }
      final response = await client
          .get(Uri.parse("${AppUrl.intakeURL}/Offence/Schedule/GetAll"));

      switch (response.statusCode) {
        case 200:
          apiResponse.Data = (json.decode(response.body) as List)
              .map((data) => OffenceScheduleDto.fromJson(data))
              .toList();

          List<OffenceScheduleDto> offenceScheduleDtoResponse =
              (json.decode(response.body) as List)
                  .map((data) => OffenceScheduleDto.fromJson(data))
                  .toList();
          apiResponse.Data = offenceScheduleDtoResponse;
          _offenceScheduleRepository
              .saveOffenceScheduleItems(offenceScheduleDtoResponse);
          break;
        default:
          apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
          break;
      }
    } on SocketException {
      apiResponse.Data = _offenceScheduleRepository.getAllOffenceSchedules();
    }
    return apiResponse;
  }
}
