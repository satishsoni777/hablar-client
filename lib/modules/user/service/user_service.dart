import 'package:take_it_easy/resources/strings/app_strings.dart';
import 'package:take_it_easy/utils/extensions.dart';
import 'package:take_it_easy/webservice/http_manager/http_manager.dart';

abstract class UserService {
  Future<dynamic> updateUserData(String data);
}

class UserServiceImpl extends HttpManager implements UserService {
  @override
  Future<dynamic> updateUserData(String data) async {
    try {
      final res = await sendRequest(HttpMethod.POST, endPoint: Endpoints.updateUserData);
      if (res.isSuccesFull()) {
        return res.data;
      } else
        throw res;
    } catch (e) {
      throw e;
    }
  }
}
