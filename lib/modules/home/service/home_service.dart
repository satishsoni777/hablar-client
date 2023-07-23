import 'package:take_it_easy/resources/strings/app_strings.dart';
import 'package:take_it_easy/webservice/http_manager/http_manager.dart';

abstract class HomeService {
  Future<dynamic> toggleOnline(bool onOff);
}

class HomeServiceImp extends HttpManager implements HomeService {
  @override
  Future<dynamic> toggleOnline(bool online) async {
    final Map<String, dynamic> req = <String, dynamic>{"online": online};
    return await sendRequest(HttpMethod.POST, endPoint: Endpoints.toggleOffOn, queryParameters: req);
  }
}
