import 'dart:convert';
import 'dart:io';
import 'package:http_interceptor/http/intercepted_client.dart';
import '../../model/pcm/programme_module_dto.dart';
import '../../util/app_url.dart';
import '../../util/auth_intercept/authorization_interceptor.dart';
import '../../util/shared/apierror.dart';
import '../../util/shared/apiresponse.dart';

class ProgrammeModuleService {
  final client =
      InterceptedClient.build(interceptors: [AuthorizationInterceptor()]);

  Future<ApiResponse> getProgrammeModuleByModuleId(
      int? programmemooduleId) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final response = await client.get(Uri.parse(
          "${AppUrl.pcmURL}/Diversion/programmemodule/GetAll/$programmemooduleId"));

      switch (response.statusCode) {
        case 200:
          apiResponse.Data = (json.decode(response.body) as List)
              .map((data) => ProgrammeModuleDto.fromJson(data))
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

  // Future<ApiResponse> addProgrammeModule(
  //     ProgrammeModuleDto programmeModuleDto) async {
  //   ApiResponse apiResponse = ApiResponse();
  //   try {
  //     final response = await client.post(
  //         Uri.parse("${AppUrl.pcmURL}/Diversion/programmemodule/Add"),
  //         body: json.encode(programmeModuleDto),
  //         headers: {'Content-Type': 'application/json'});

  //     switch (response.statusCode) {
  //       case 200:
  //         ApiResults apiResults =
  //             ApiResults.fromJson(json.decode(response.body));
  //         apiResponse.Data = apiResults;
  //         break;
  //       default:
  //         apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
  //         break;
  //     }
  //   } on SocketException {
  //     apiResponse.ApiError = ApiError(error: "Connection Error. Please retry");
  //   }
  //   return apiResponse;
  // }
}
