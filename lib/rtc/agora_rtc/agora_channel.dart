import 'package:agora_rtm/agora_rtm.dart';
import 'package:take_it_easy/config/config.dart';

class AgoraChannel {
  AgoraRtmClient agoraRtmClient;
  init() async {
    agoraRtmClient = await AgoraRtmClient.createInstance(ConfigAgora.appId);
    agoraRtmClient.login(ConfigAgora.token, 'ConfigAgora.');
  }

  sendMessage() {
    // agoraRtmClient.send
  }
}
