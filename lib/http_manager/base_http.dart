abstract class HttpManager {
 Future<dynamic> sendRequest(HttpMethod httpMethod,{
  Map<String,dynamic> body,
  String endPoint,
  ///Optional
  String baseUrl
 }); 
 Future<dynamic> setHeaders();
}
enum HttpMethod{GET,POST,DELETE,PUT}