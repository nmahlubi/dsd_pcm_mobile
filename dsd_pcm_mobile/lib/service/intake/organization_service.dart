import 'dart:convert';
import 'dart:io';
import 'package:dsd_pcm_mobile/model/intake/organization_dto.dart';
import 'package:http_interceptor/http/intercepted_client.dart';
import '../../util/app_url.dart';
import '../../util/auth_intercept/authorization_interceptor.dart';
import '../../util/shared/apierror.dart';
import '../../util/shared/apiresponse.dart';

class OrganizationService {
  final client =
      InterceptedClient.build(interceptors: [AuthorizationInterceptor()]);

  Future<ApiResponse> getOrganizationByLocalMunicipalityId(int? localMunicipalityId, int? organizationTypeId) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final response = await client
          .get(Uri.parse("${AppUrl.intakeURL}/LookUp/Organization/GetAll/$localMunicipalityId/$organizationTypeId"));

      switch (response.statusCode) {
        case 200:
          List<OrganizationDto> offenceTypeDtoResponse =
              (json.decode(response.body) as List)
                  .map((data) => OrganizationDto.fromJson(data))
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
