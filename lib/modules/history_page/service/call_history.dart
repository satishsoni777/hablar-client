import 'package:take_it_easy/webservice/http_manager/http_manager.dart';

abstract class CallHistory {
  Future<void> getCalls();
}

class CallHistoryImpl extends HttpManager implements CallHistory {
  @override
  Future<void> getCalls() {
    throw UnimplementedError();
  }
}
