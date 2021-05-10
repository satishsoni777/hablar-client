import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:take_it_easy/config/agora_config.dart';

class AgoraVoiceManager {
  int _uid;
  RtcEngine _engine;
  initPlatformState() async {
    await Permission.microphone.request();

    
    RtcEngineConfig config = RtcEngineConfig(AgoraConfig.appId);
    _engine = await RtcEngine.createWithConfig(config);
    await _enableAudio();
    _engine.setEventHandler(RtcEngineEventHandler(
        joinChannelSuccess: (String channel, int uid, int elapsed) {
      print('joinChannelSuccess######### ${channel} ${uid}');
      _uid = uid;
    }, userJoined: (int uid, int elapsed) {
      _uid = uid;
    }, userOffline: (int uid, UserOfflineReason reason) {
      _uid = uid;
    }));
    await _engine.joinChannelWithUserAccount(
        AgoraConfig.token, AgoraConfig.channelName, 'satish754ss@gmail.com');
  }

  _enableAudio() async {
    await _engine.enableDualStreamMode(true);
    await _engine.enableAudio();
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine.setClientRole(ClientRole.Broadcaster);
    await _engine.setEnableSpeakerphone(true);
  }

  getAudio() {
    _engine.getAudioMixingPlayoutVolume();
    // _engine.audtiotr
  }

  dispose() async {
    await _engine?.destroy();
  }
}
