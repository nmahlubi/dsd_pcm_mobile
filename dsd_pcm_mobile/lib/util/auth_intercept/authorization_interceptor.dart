import 'package:http_interceptor/http_interceptor.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../prefs.dart';

class AuthorizationInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    try {
      String? token = Prefs.getString('token');
      data.headers['authorization'] = 'Bearer $token';
      data.headers['content-type'] = 'application/json';
    } catch (e) {
      // print(e);
    }
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    return data;
  }
}

class ExpiredTokenRetryPolicy extends RetryPolicy {
  @override
  //int maxRetryAttempts = 2;

  @override
  Future<bool> shouldAttemptRetryOnResponse(ResponseData response) async {
    if (response.statusCode == 401) {
      await FirebaseAuth.instance.currentUser!.getIdTokenResult(true);
      return true;
    }
    return false;
  }
}
