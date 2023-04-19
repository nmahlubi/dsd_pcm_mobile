import 'dart:convert';
import 'dart:io';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

import '../../model/intake/auth_token.dart';
import '../../util/app_url.dart';
import '../../util/shared/apierror.dart';
import '../../util/shared/apiresponse.dart';

class AuthenticateUser {
  Future<ApiResponse> login(String username, String password, String deviceId,
      String deviceName) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final Map<String, dynamic> loginData = {
        'username': username,
        'password': password,
        'deviceId': deviceId,
        'deviceName': deviceName,
        'module': 'pcmmobile'
      };
      final response = await http.post(
        Uri.parse("${AppUrl.intakeURL}/Login/Mobile"),
        body: json.encode(loginData),
        headers: {'Content-Type': 'application/json'},
      );

      switch (response.statusCode) {
        case 200:
          AuthToken tokenResponse =
              AuthToken.fromJson(json.decode(response.body));
          apiResponse.Data = tokenResponse;
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

  Future<ApiResponse> loginOffline(String username, String password,
      String deviceId, String deviceName) async {
    ApiResponse apiResponse = ApiResponse();
    final Map<String, dynamic> loginData = {
      'username': username,
      'password': password,
      'deviceId': deviceId,
      'deviceName': deviceName,
      'module': 'pcmmobile'
    };
    final response = await http.post(
      Uri.parse("${AppUrl.intakeURL}/Login/Mobile"),
      body: json.encode(loginData),
      headers: {'Content-Type': 'application/json'},
    );

    switch (response.statusCode) {
      case 200:
        AuthToken tokenResponse =
            AuthToken.fromJson(json.decode(response.body));
        apiResponse.Data = tokenResponse;
        break;
      default:
        apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
        break;
    }
    return apiResponse;
  }
}
