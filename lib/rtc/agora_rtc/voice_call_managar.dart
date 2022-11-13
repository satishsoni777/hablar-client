import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:take_it_easy/config/agora_config.dart';
import 'package:take_it_easy/rtc/rtc_interface.dart';

//Working
class AgoraVoiceManager extends RtcInterface {
  RtcEngine? _engine;

  _enableAudio() async {
    await _engine?.enableAudio();
    await _engine?.setEnableSpeakerphone(true);
  }

  @override
  Future makeVoiceCall() async {
    ChannelMediaOptions options = const ChannelMediaOptions(
      clientRoleType: ClientRoleType.clientRoleBroadcaster,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    );
    try {
      _engine?.joinChannel(
          token: 'AgoraConfig.tokenTeasy,',
          channelId: AgoraConfig.channelName,
          uid: 0,
          options: options);
    } catch (e) {
      print("Failed to connect::: ## $e");
    }
  }

  @override
  Future getCallDuration() {
    // TODO: implement getCallDuration
    throw UnimplementedError();
  }

  @override
  Future initialize() async {
    _engine?.initialize(RtcEngineContext(appId: AgoraConfig.appId));
    final permistin = await Permission.microphone.request();
    if (!permistin.isGranted) return;
    _engine?.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint("local user ${connection.localUid} joined");
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint("remote user $remoteUid joined");
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          debugPrint("remote user $remoteUid left channel");
        },
        onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
          debugPrint(
              '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
        },
      ),
    );
    await _enableAudio();
  }

  @override
  void dispose() async{
  await _engine?.leaveChannel();
  }
}
