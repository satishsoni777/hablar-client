import 'package:agora_rtm/agora_rtm.dart';
import 'package:take_it_easy/config/agora_config.dart';

class AgoraChannel {
  AgoraRtmClient agoraRtmClient;
  init() async {
    agoraRtmClient = await AgoraRtmClient.createInstance(AgoraConfig.appId);
    agoraRtmClient.login(AgoraConfig.token, 'ConfigAgora.');
  }

  sendMessage() {
    // agoraRtmClient.send
  }
}
