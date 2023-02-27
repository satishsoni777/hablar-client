import 'package:dio/dio.dart';
import 'package:take_it_easy/utils/flovor.dart';

abstract class BaseHttp {
}

abstract class HttpManager extends BaseHttp {
  final Dio http = Dio();

  Map<String, dynamic> _headers = {};
  Future<Response> sendRequest(
    HttpMethod httpMethod, {
    Map<String, dynamic>? request,
    Map<String, dynamic>? queryParameters,
    required String endPoint,
    String? baseUrl,
  }) async {
    setHeaders();
    return _send(httpMethod, endPoint, baseUrl: baseUrl, request: request, queryParameters: queryParameters);
  }

  void setHeaders({String? arg}) {
    _headers["content-type"] = 'application/json';
  }

  Future<Response> _send(HttpMethod httpMethod, String endPoint, {String? baseUrl, Map<String, dynamic>? request, Map<String, dynamic>? queryParameters}) async {
    switch (httpMethod) {
      case HttpMethod.GET:
        return http.get((baseUrl ?? Flavor.internal().baseUrl) + endPoint, queryParameters: queryParameters);
      case HttpMethod.POST:
        return http.post((baseUrl ?? Flavor.internal().baseUrl) + endPoint, data: request);
      case HttpMethod.DELETE:
        return http.delete(
          (baseUrl ?? Flavor.internal().baseUrl) + endPoint,
        );
      case HttpMethod.PUT:
        return http.put(
          (baseUrl ?? Flavor.internal().baseUrl) + endPoint,
        );
    }
  }
}

enum HttpMethod {
  GET,
  POST,
  DELETE,
  PUT
}
