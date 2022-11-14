import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:take_it_easy/config/agora_config.dart';
import 'package:take_it_easy/di/di_initializer.dart';
import 'package:take_it_easy/modules/dialer/service/rtc_builder_request.dart';
import 'package:take_it_easy/rtc/rtc_interface.dart';

//Working
class AgoraManager extends RtcInterface {
  RtcEngine? _engine;

  _enableAudio() async {
    await _engine?.enableAudio();
    // await _engine?.setEnableSpeakerphone(true);
  }

  @override
  Future makeVoiceCall() async {
    ChannelMediaOptions options = const ChannelMediaOptions(
      clientRoleType: ClientRoleType.clientRoleBroadcaster,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    );
    try {
      final token = await DI.inject<RtcBuilder>().getRtcToken();
      _engine?.joinChannel(
          token: token,
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
    final permistin = await Permission.microphone.request();
    if (!permistin.isGranted) return;
    _engine = createAgoraRtcEngine();
    await _engine?.initialize(RtcEngineContext(appId: AgoraConfig.appId));
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
        onAudioMixingStateChanged: (a, c) {
          print("### ### # # # ##");
        },
      ),
    );

    await _engine?.setClientRole(
        role: ClientRoleType.clientRoleAudience,
        options: ClientRoleOptions(
            audienceLatencyLevel:
                AudienceLatencyLevelType.audienceLatencyLevelLowLatency));
    await _enableAudio();
    await makeVoiceCall();
    _engine!.getAudioMixingCurrentPosition();
  }

  @override
  void dispose() {
    _engine?.leaveChannel();
    _engine?.disableAudio();
  }

  @override
  void enableAudio() {
    // TODO: implement enableAudio
  }

  @override
  void disconnect() {
    // TODO: implement disconnect
  }
}
