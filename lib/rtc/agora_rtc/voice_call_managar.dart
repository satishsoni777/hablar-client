import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:take_it_easy/config/agora_config.dart';
import 'package:take_it_easy/di/di_initializer.dart';
import 'package:take_it_easy/modules/authentication/model/gmail_user_data.dart';
import 'package:take_it_easy/modules/dialer/service/rtc_builder_request.dart';
import 'package:take_it_easy/rtc/rtc_interface.dart';
import 'package:take_it_easy/storage/shared_storage.dart';

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
      final email = (await DI.inject<SharedStorage>().getUserData()).email;
      await _engine?.joinChannelWithUserAccount(
          token: token,
          channelId: AgoraConfig.channelName,
          options: ChannelMediaOptions(
            clientRoleType: ClientRoleType.clientRoleBroadcaster,
          ),
          userAccount: email ?? '');
      // await _engine?.joinChannel(
      //     token: token,
      //     channelId: AgoraConfig.channelName,
      //     uid: 0,
      //     options: options);
    } catch (e) {
      print("Failed to connect::: ## $e");
    }
  }

  @override
  Future getCallDuration() async {
    await _engine?.getAudioMixingDuration();
  }

  @override
  Future initialize() async {
    // final permistin = await Permission.microphone.request();
    // if (!permistin.isGranted) return;
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
        onUserInfoUpdated: (a, v) {},
        onRtcStats: (r, a) {},
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          debugPrint("remote user $remoteUid left channel");
          debugPrint("User joined channel ${connection.channelId}");
        },
        onTokenPrivilegeWillExpire:
            (RtcConnection connection, String token) async {
          await DI.inject<RtcBuilder>().reGenerateRtcToken();
          debugPrint(
              '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
        },
        onAudioMixingStateChanged: (a, c) {
          print("### ### # # # ##");
        },
        onError: (e, s) {
          print("#### Errror ### $s");
        },
        onLeaveChannel: (a, s) {},
        onAudioDeviceStateChanged: (s, a, v) {},
        onRequestToken: (e) {},
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
