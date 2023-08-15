import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:take_it_easy/config/agora_config.dart';
import 'package:take_it_easy/resources/strings/app_strings.dart';
import 'package:take_it_easy/rtc/signaling.i.dart';
import 'package:take_it_easy/webservice/http_manager/http_manager.dart';

class AgoraManager extends HttpManager implements SignalingI<dynamic> {
  AgoraManager();
  RtcEngine? _engine;
  Function(CallStatus callStatus, {Map<String, dynamic>? data})? _callStatus;
  @override
  Future<dynamic> startCall(
      { String? roomId, int? userId}) async {
    try {
      ChannelMediaOptions options = const ChannelMediaOptions(
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
        channelProfile: ChannelProfileType.channelProfileCommunication,
      );

      final Response<dynamic> response = await sendRequest(
        HttpMethod.GET,
        endPoint: Endpoints.agoraToken,
        queryParameters: <String, dynamic>{"channelName": roomId, "uid": 0},
      );

      final String token = response.data["rtcToken"];

      await _engine?.joinChannelWithUserAccount(
        token: token,
        channelId: roomId ?? '',
        options: options,
        userAccount: userId.toString(),
      );

      _engine?.registerEventHandler(
        RtcEngineEventHandler(
          onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
            _callStatus?.call(CallStatus.CallStarted);
            debugPrint("local user ${connection.localUid} joined  $elapsed");
          },
          onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
            _callStatus?.call(CallStatus.CallStarted);
            debugPrint(
                " onUserJoine dremote user $remoteUid ${connection.toJson()}  $elapsed");
          },
          onUserAccountUpdated: (RtcConnection connection, int a, String s) {},
          onConnectionLost: (RtcConnection rtc) {},
          onLeaveChannel: (RtcConnection a, RtcStats b) {
            _callStatus?.call(CallStatus.CallEnded,
                data: <String, dynamic>{"duration": b.duration});
            debugPrint("onLeaveChannel user ${a.channelId}  ${b.duration}");
          },
          onUserStateChanged: (r, a, aa) {},
          onUserOffline: (RtcConnection connection, int remoteUid,
              UserOfflineReasonType reason) {
            // _callStatus?.call(CallStatus.Connecting);
            debugPrint("onUserOffline remote user $remoteUid left channel");
          },
          onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
            debugPrint("connection: ${connection.toJson()}, token: $token");
          },
          onError: (ErrorCodeType a, String e) {
            debugPrint("on error: ${a}, token: $e");
          },
          onUserMuteAudio: (value, a, vale) {},
          onAudioMixingStateChanged:
              (AudioMixingStateType a, AudioMixingReasonType c) {
            print("### ### # # # ##");
          },
        ),
      );
    } catch (e) {
      print("Failed to connect::: ## $e");
    }
  }

  @override
  Future<void> initialize() async {
    try {
      final PermissionStatus permistin = await Permission.microphone.request();
      final PermissionStatus camera = await Permission.camera.request();
      if (!permistin.isGranted && !camera.isGranted) return;

      _engine = createAgoraRtcEngine();
      await _engine?.initialize(const RtcEngineContext(
        appId: AgoraConfig.appId,
      ));
      await _engine?.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
      await _engine
          ?.setChannelProfile(ChannelProfileType.channelProfileCommunication);
      await _engine?.enableVideo();
      await _engine?.enableAudio();
      await _engine?.enableWebSdkInteroperability(true);
      _callStatus?.call(CallStatus.Start);
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<void> disconnect() async {
    await _engine?.disableAudio();
    await _engine?.disableVideo();
    await _engine?.leaveChannel();
  }

  RtcEngine? get rtcEngine => _engine;

  @override
  CallType get callType => throw UnimplementedError();

  @override
  Function(CallStatus callStatus, {Map<String, dynamic>? data})
      get callStatus => _callStatus!;

  @override
  set callStatus(
      Function(CallStatus p1, {Map<String, dynamic>? data})? _callStatus) {
    this._callStatus = _callStatus;
  }

  @override
  Future<bool> mute(bool value) async {
    await _engine?.muteLocalAudioStream(value);
    return true;
  }

  @override
  Future<void> speaker(bool value) async {
    await _engine?.setEnableSpeakerphone(value);
  }
  
  @override
  Future<int> getCallDuration() {
    // TODO: implement getCallDuration
    throw UnimplementedError();
  }
}
