import 'dart:convert';
import 'dart:io';
import 'package:dsd_pcm_mobile/model/pcm/programme_module_dto.dart';
import 'package:dsd_pcm_mobile/util/app_url.dart';
import 'package:dsd_pcm_mobile/util/auth_intercept/authorization_interceptor.dart';
import 'package:dsd_pcm_mobile/util/http_client_service.dart';
import 'package:dsd_pcm_mobile/util/shared/apierror.dart';
import 'package:dsd_pcm_mobile/util/shared/apiresponse.dart';
import 'package:http_interceptor/http/intercepted_client.dart';

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
