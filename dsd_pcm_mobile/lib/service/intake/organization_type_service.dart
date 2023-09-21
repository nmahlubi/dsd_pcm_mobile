// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:convert';
import 'dart:io';
import 'package:http_interceptor/http/intercepted_client.dart';
import '../../model/intake/organization_type_dto.dart';
import '../../util/app_url.dart';
import '../../util/auth_intercept/authorization_interceptor.dart';
import '../../util/shared/apierror.dart';
import '../../util/shared/apiresponse.dart';

class OrganizationTypeService {
  final client =
      InterceptedClient.build(interceptors: [AuthorizationInterceptor()]);

  Future<ApiResponse> getOrganizationTypes() async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final response = await client
          .get(Uri.parse("${AppUrl.intakeURL}/LookUp/OrganizationTypes"));

      switch (response.statusCode) {
        case 200:
          List<OrganizationTypeDto> offenceTypeDtoResponse =
              (json.decode(response.body) as List)
                  .map((data) => OrganizationTypeDto.fromJson(data))
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
