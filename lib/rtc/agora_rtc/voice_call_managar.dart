import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:take_it_easy/config/agora_config.dart';
import 'package:take_it_easy/di/di_initializer.dart';
import 'package:take_it_easy/modules/authentication/model/gmail_user_data.dart';
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
        _uid = uid;
        print("############# User Success ############# $uid");
      },
      userJoined: (int uid, int elapsed) {
        print("############# User joined ############# $uid");
        _uid = uid;
      },
      leaveChannel: (RtcStats rtcStats) async {
        print("############# User leaved ############# ${rtcStats.users}");
        await _engine.sendStreamMessage(_uid, 'message');
      },
      userOffline: (int uid, UserOfflineReason reason) {
        _uid = uid;
        print("############# User offline ############# $uid ${reason}");
      },
      activeSpeaker: (a) {
        print("################ active user ########### $a");
      },
      userInfoUpdated: (value, userInfo) {},
    ));
    GmailUserData gmailUserData =
        (await DI.inject<SharedStorage>().getUserData());

    try {
      await _engine.joinChannel(
          AgoraConfig.tokenTeasy, AgoraConfig.channelName, null, 0);
      print(_uid);
    } catch (e) {
      print("Failed to connect::: ## $e");
    }
  }

  _enableAudio() async {
    await _engine.enableDualStreamMode(true);
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine.setClientRole(ClientRole.Broadcaster);
    await _engine.setEnableSpeakerphone(true);
  }

  getAudio() {
    _engine.getAudioMixingPlayoutVolume();
  }

  muteAUser() {
    _engine.muteRemoteAudioStream(111, true);
  }

  dispose() async {
    await _engine?.destroy();
  }

  Future<int> getAudioMixingCurrentPosition() async {
    return await _engine.getAudioMixingCurrentPosition();
  }

  sendMessage() async {
    // _engine..sendStreamMessage(streamId, message);
    _engine..sendStreamMessage(23, 'Hi how are you');
  }

  getUser() {}
}
