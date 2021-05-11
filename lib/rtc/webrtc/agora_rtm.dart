import 'package:agora_rtm/agora_rtm.dart';
import 'package:take_it_easy/config/agora_config.dart';

class AgoraRtm {
  AgoraRtmClient _client;
  AgoraRtmChannel _agoraRtmChannel;
  init() async {
    _client = await AgoraRtmClient.createInstance(AgoraConfig.appId);
  }

  logIn() {
    _client.login(AgoraConfig.token, '1234');
  }

  join() async {
    _agoraRtmChannel = await _client.createChannel(AgoraConfig.channelName);
    await _agoraRtmChannel.join();
  }

  leave() {
    _agoraRtmChannel?.leave();
  }

  close() {
    _agoraRtmChannel?.close();
  }

  _sendMessage({String message}) async {
     _agoraRtmChannel..sendMessage(AgoraRtmMessage.fromText(message));
  }
}
