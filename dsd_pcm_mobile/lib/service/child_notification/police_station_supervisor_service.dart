import 'dart:convert';
import 'dart:io';
import 'package:http_interceptor/http/intercepted_client.dart';

import '../../model/child_notification/user_access_rights_dto.dart';
import '../../util/app_url.dart';
import '../../util/auth_intercept/authorization_interceptor.dart';
import '../../util/shared/apierror.dart';
import '../../util/shared/apiresponse.dart';

class PoliceStationSupervisor {
  final client =
      InterceptedClient.build(interceptors: [AuthorizationInterceptor()]);

  Future<ApiResponse> getAccessRightsByUsername(String? username) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final response = await client.get(
          Uri.parse(
              "${AppUrl.childNotificationURL}/PoliceStationSupervisor/AccessRights/$username"),
          headers: {'Content-Type': 'application/json'});

      switch (response.statusCode) {
        case 200:
          UserAccessRightsDto userAccessRightsResponse =
              UserAccessRightsDto.fromJson(json.decode(response.body));
          apiResponse.Data = userAccessRightsResponse;
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
