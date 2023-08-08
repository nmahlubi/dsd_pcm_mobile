import 'dart:convert';
import 'dart:io';
import 'package:dsd_pcm_mobile/model/pcm/programme_module_dto.dart';
import 'package:http_interceptor/http/intercepted_client.dart';

import '../../domain/repository/assessment/victim_detail_repository.dart';
import '../../domain/repository/assessment/victim_organisation_repository.dart';
import '../../util/app_url.dart';
import '../../util/auth_intercept/authorization_interceptor.dart';
import '../../util/http_client_service.dart';
import '../../util/shared/apierror.dart';
import '../../util/shared/apiresponse.dart';
import '../intake/person_service.dart';

class ProgramModuleService {
  final client =
      InterceptedClient.build(interceptors: [AuthorizationInterceptor()]);
  final _httpClientService = HttpClientService();

  Future<ApiResponse> getProgrammeModuleById(int? programmeModuleId) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final response = await client.get(Uri.parse(
          "${AppUrl.pcmURL}/ProgrammeModule/ProgrammeModule/$programmeModuleId"));
      switch (response.statusCode) {
        case 200:
          apiResponse.Data =
              ProgrammeModuleDto.fromJson(json.decode(response.body));
          break;
        default:
          apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
          break;
      }
    } on SocketException {
      apiResponse.ApiError = ApiError(error: "Connection Error. Please retry");
    }
    return apiResponse;
  }
}
