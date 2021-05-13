
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:take_it_easy/config/agora_config.dart';
import 'package:take_it_easy/di/di_initializer.dart';
import 'package:take_it_easy/storage/shared_storage.dart';

//Working
class AgoraVoiceManager {
  int _uid;
  RtcEngine _engine;
  initPlatformState() async {
    await Permission.microphone.request();
    RtcEngineConfig config = RtcEngineConfig(AgoraConfig.apIdTeasy);
    _engine = await RtcEngine.createWithConfig(config);
    await _enableAudio();
    _engine.setEventHandler(RtcEngineEventHandler(
      joinChannelSuccess: (String channel, int uid, int elapsed) {
        print('joinChannelSuccess######### ${channel} ${uid}');
        _uid = uid;
      },
      userJoined: (int uid, int elapsed) {
         print('joinChannelSuccess######### ${elapsed} ${uid}');
        _uid = uid;
      },
      leaveChannel: (RtcStats rtcStats) async {
        await _engine.sendStreamMessage(_uid, 'message');
      },
      userOffline: (int uid, UserOfflineReason reason) {
        _uid = uid;
      },
      userInfoUpdated: (value, userInfo) {},
    ));
    var uid=(await DI.inject<SharedStorage>().getUserData()).uid;
    await _engine.joinChannelWithUserAccount(
        AgoraConfig.tokenTeasy, AgoraConfig.chennelTeasy, uid);
  }
  _enableAudio() async {
    await _engine.enableAudio();
    await _engine.enableDualStreamMode(true);
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine.setClientRole(ClientRole.Broadcaster);
    await _engine.setEnableSpeakerphone(true);
  }

  getAudio() {
    _engine.getAudioMixingPlayoutVolume();
    // _engine.getAudioMixingDuration();
    // _engine.audtiotr
  }

  dispose() async {
    await _engine?.destroy();
  }

  sendMessage() async {
    // _engine..sendStreamMessage(streamId, message);
    _engine..sendStreamMessage(23, 'Hi how are y9ou');
  }
}
