// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:convert';
import 'dart:io';
import 'package:dsd_pcm_mobile/model/pcm/programmes_dto.dart';
import 'package:http_interceptor/http/intercepted_client.dart';
import '../../util/app_url.dart';
import '../../util/auth_intercept/authorization_interceptor.dart';
import '../../util/shared/apierror.dart';
import '../../util/shared/apiresponse.dart';

class ProgrammesService {
  final client =
      InterceptedClient.build(interceptors: [AuthorizationInterceptor()]);

  Future<ApiResponse> getProgrammesByOrganizationId(int? organizationId) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final response = await client
          .get(Uri.parse("${AppUrl.intakeURL}/LookUp/Programmes/GetAll/$organizationId"));

      switch (response.statusCode) {
        case 200:
          List<ProgrammesDto> offenceTypeDtoResponse =
              (json.decode(response.body) as List)
                  .map((data) => ProgrammesDto.fromJson(data))
                  .toList();
          apiResponse.Data = offenceTypeDtoResponse;
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
