import 'package:take_it_easy/utils/flovor.dart';

import 'package:http/http.dart' as http;

abstract class BaseHttp {}

abstract class HttpManager extends BaseHttp {
  Map<String, dynamic> _headers = {};
  Future<dynamic> sendRequest(HttpMethod httpMethod,
      {required Map<String, dynamic>? body,required String endPoint, String? baseUrl}) async {
    return _send(httpMethod, endPoint);
  }

  Future<dynamic>? setHeaders() {
    // _headers["Authentication"]
  }

  Future<dynamic> _send(HttpMethod httpMethod, String endPoint,
      {String? baseUrl}) async {
    switch (httpMethod) {
      case HttpMethod.GET:
        return await http.get(Flavor.internal().baseUrl);
      case HttpMethod.POST:
        return await http.get(Flavor.internal().baseUrl);
      case HttpMethod.DELETE:
        return await http.get(Flavor.internal().baseUrl);
      case HttpMethod.PUT:
        return await http.get(Flavor.internal().baseUrl);
    }
  }
}

enum HttpMethod { GET, POST, DELETE, PUT }
