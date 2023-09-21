// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:convert';
import 'dart:io';
import 'package:http_interceptor/http/intercepted_client.dart';
import '../../model/intake/local_municipality_dto.dart';
import '../../util/app_url.dart';
import '../../util/auth_intercept/authorization_interceptor.dart';
import '../../util/shared/apierror.dart';
import '../../util/shared/apiresponse.dart';

class LocalMunicipalityService {
  final client =
      InterceptedClient.build(interceptors: [AuthorizationInterceptor()]);

  Future<ApiResponse> getLocalMunicipalitiesByDistrictId(int? districtId) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final response = await client
          .get(Uri.parse("${AppUrl.intakeURL}/LookUp/LocalMunicipalities/GetAll/$districtId"));

      switch (response.statusCode) {
        case 200:
          List<LocalMunicipalityDto> offenceTypeDtoResponse =
              (json.decode(response.body) as List)
                  .map((data) => LocalMunicipalityDto.fromJson(data))
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
