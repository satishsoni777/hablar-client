import 'package:take_it_easy/config/agora_config.dart';
import 'package:take_it_easy/http_manager/base_http.dart';

abstract class RtcBuilder {
  Future getRtcToken();
}

class RtcBuilderImpl extends RtcBuilder {
  RtcBuilderImpl(this.httpManager);
  final HttpManager httpManager;
  @override
  Future getRtcToken() async {
    final res = await httpManager.sendRequest(HttpMethod.GET,
        body: {"channelName": AgoraConfig.channelName});
  }
}
