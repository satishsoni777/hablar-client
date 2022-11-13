import 'package:take_it_easy/config/agora_config.dart';
import 'package:take_it_easy/http_manager/base_http.dart';
import 'package:take_it_easy/resources/strings/app_strings.dart';

abstract class RtcBuilder {
  Future getRtcToken();
}

class RtcBuilderRequest extends HttpManager implements RtcBuilder {
  RtcBuilderRequest();
  @override
  Future getRtcToken() async {
    final res = await this.sendRequest(HttpMethod.GET,
        endPoint: Endpoints.rtcToke,
        body: {"channelName": AgoraConfig.channelName});
  }
}
