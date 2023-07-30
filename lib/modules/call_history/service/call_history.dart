import 'package:take_it_easy/webservice/http_manager/http_manager.dart';

abstract class CallHistoryService {
  Future<void> getCalls();
}

class CallHistoryImpl extends HttpManager implements CallHistoryService {
  @override
  Future<void> getCalls() {
    throw UnimplementedError();
  }
}
