import 'dart:convert';
import 'dart:io';

import 'package:dsd_pcm_mobile/model/pcm/home_based_supervision_dto.dart';

import 'package:http_interceptor/http/intercepted_client.dart';

import '../../util/app_url.dart';
import '../../util/auth_intercept/authorization_interceptor.dart';
import '../../util/shared/apierror.dart';
import '../../util/shared/apiresponse.dart';


class HomeBasedSupervisionService{
  
   final client = InterceptedClient.build(interceptors: [AuthorizationInterceptor()]);

  Future<ApiResponse> getHomeBasedSupervisionDetailsByAssessmentId(
    
    int? intakeAssessmentId,int? probationOfficerId) async 
    {
      ApiResponse apiResponse = ApiResponse();
      try {
        final response = await client.get(Uri.parse(
            "${AppUrl.pcmURL}/HomeBasedSupervison/GetAll/$intakeAssessmentId/$probationOfficerId"));

        switch (response.statusCode) {
          case 200:
            apiResponse.Data = (json.decode(response.body) as List)
                .map((data) => HomeBasedSupervionDto.fromJson(data))
                .toList();
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