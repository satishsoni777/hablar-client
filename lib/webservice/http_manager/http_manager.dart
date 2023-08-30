import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:take_it_easy/auth/google_auth.dart';
import 'package:take_it_easy/di/di_initializer.dart';
import 'package:take_it_easy/modules/signin/model/gmail_user_data.dart';
import 'package:take_it_easy/storage/shared_storage.dart';
import 'package:take_it_easy/utils/flovor.dart';

abstract class BaseHttp {}

abstract class HttpManager extends BaseHttp with FlutterAuth {
  final Dio http = Dio();

  Map<String, dynamic> _headers = {};
  Options? options;
  Future<Response> sendRequest(
    HttpMethod httpMethod, {
    Map<String, dynamic>? request,
    Map<String, dynamic>? queryParameters,
    required String endPoint,
    String? baseUrl,
  }) async {
    await _setHeaders(baseUrl: baseUrl);
    final dynamic req = request != null ? jsonEncode(request) : "";
    return _send(httpMethod, endPoint,
        baseUrl: baseUrl, request: req, queryParameters: queryParameters);
  }

  Future<void> _setHeaders({String? baseUrl}) async {
    final String? token = await DI.inject<SharedStorage>().getToken();
    http.options
      ..baseUrl = baseUrl ?? (Flavor.internal().baseUrl)
      ..headers = {"Content-Type": "application/json", "Authorization": "Bearer $token"};
  }

  Future<Response> _send(HttpMethod httpMethod, String endPoint,
      {String? baseUrl, request, Map<String, dynamic>? queryParameters}) async {
    switch (httpMethod) {
      case HttpMethod.GET:
        return http.get((baseUrl ?? Flavor.internal().baseUrl) + endPoint,
            queryParameters: queryParameters);
      case HttpMethod.POST:
        return await http.post(endPoint,
            data: request, queryParameters: queryParameters, options: options);
      case HttpMethod.DELETE:
        return http.delete((baseUrl ?? Flavor.internal().baseUrl) + endPoint);
      case HttpMethod.PUT:
        return http.put((baseUrl ?? Flavor.internal().baseUrl) + endPoint);
    }
  }
}

mixin FlutterAuth {
  Future<bool> logout({LogOutType logOutType = LogOutType.GMAIL}) async {
    if (logOutType == LogOutType.GMAIL) {
      try {
        DI.inject<UserData>().setData(null);
        final result = await GoogleAuthService().logout();
        return result;
      } catch (_) {}
    }
    return true;
  }
}

enum LogOutType { GMAIL, OTP, FIREBASE }

enum HttpMethod { GET, POST, DELETE, PUT }
