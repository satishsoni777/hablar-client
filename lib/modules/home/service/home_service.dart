import 'package:take_it_easy/resources/strings/app_strings.dart';
import 'package:take_it_easy/utils/extensions.dart';
import 'package:take_it_easy/webservice/http_manager/http_manager.dart';

abstract class HomeService {
  Future<dynamic> toggleOnline(bool onOff);
  Future<dynamic> subFeedback(double rating, {String? comment});
}

class HomeServiceImp extends HttpManager implements HomeService {
  @override
  Future<dynamic> toggleOnline(bool online) async {
    final Map<String, dynamic> req = <String, dynamic>{"online": online};
    return await sendRequest(HttpMethod.POST,
        endPoint: Endpoints.toggleOffOn, queryParameters: req);
  }

  @override
  Future<dynamic> subFeedback(double rating, {String? comment}) async {
    final req = {"rating": rating, "comment": comment};
    final result = await sendRequest(HttpMethod.POST,
        endPoint: Endpoints.subFeedback, queryParameters: req);
    if (result.isSuccesFull()) {
      return result;
    } else
      throw result;
  }
}
