// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:convert';
import 'dart:io';
import 'package:dsd_pcm_mobile/model/intake/district_dto.dart';
import 'package:http_interceptor/http/intercepted_client.dart';

import '../../util/app_url.dart';
import '../../util/auth_intercept/authorization_interceptor.dart';
import '../../util/shared/apierror.dart';
import '../../util/shared/apiresponse.dart';

class DistrictService {
  final client =
      InterceptedClient.build(interceptors: [AuthorizationInterceptor()]);

  Future<ApiResponse> getDistrictByProvinceId(int? provinceId) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final response = await client
          .get(Uri.parse("${AppUrl.intakeURL}/LookUp/District/GetAll/$provinceId"));

      switch (response.statusCode) {
        case 200:
          List<DistrictDto> offenceTypeDtoResponse =
              (json.decode(response.body) as List)
                  .map((data) => DistrictDto.fromJson(data))
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
