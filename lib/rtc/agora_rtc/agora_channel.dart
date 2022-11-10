// import 'package:agora_rtm/agora_rtm.dart';
import 'package:take_it_easy/config/agora_config.dart';
import 'package:take_it_easy/di/di_initializer.dart';
import 'package:take_it_easy/storage/shared_storage.dart';

class AgoraChannel {
  // AgoraRtmClient _agoraRtmClient;
  String _uid;
  init() async {
    // _agoraRtmClient = await AgoraRtmClient.createInstance(AgoraConfig.appId);
    _uid = (await DI.inject<SharedStorage>().getUserData()).uid;
    // _agoraRtmClient.onConnectionStateChanged = (a, v) {

    // };
    // _agoraRtmClient.onMessageReceived=(a,b){
    // };
  }

  sendMessage() {
    // _agoraRtmClient.sendMessageToPeer(peerId, message);
  }
}
