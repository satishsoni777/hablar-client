import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:take_it_easy/modules/model/user_data.dart';
import 'package:take_it_easy/rtc/rtc_interface.dart';
import 'package:flutter_webrtc_wrapper/flutter_webrtc_wrapper.dart';
import 'package:take_it_easy/utils/flovor.dart';

class WebRtcManager extends RtcInterface with ChangeNotifier {
  WebRTCMeetingHelper? webRTCMeetingHelper;
  MediaStream? mediaStream;
  RTCVideoRenderer? _renderer = RTCVideoRenderer();
  BuildContext? context;
  @override
  Future<void> initialize() async {
    webRTCMeetingHelper = WebRTCMeetingHelper(url: Flavor.internal().baseUrl, autoConnect: true);
  }

  void makeMicCall(BuildContext context, UserConnectionData data) async {
    this.context = context;
    await _initRender();
    makeVoiceCall(data);
  }

  @override
  void enableAudio() {
    // TODO: implement enableAudio
  }

  @override
  Future getCallDuration() {
    // TODO: implement getCallDuration
    throw UnimplementedError();
  }

  @override
  Future<void> makeVoiceCall(UserConnectionData data) async {
    webRTCMeetingHelper?.userId = data.userId;
    webRTCMeetingHelper?.name = data.name;
    mediaStream = await navigator.mediaDevices.getUserMedia(data.mediaConstraint());
    _renderer?.srcObject = mediaStream;
    webRTCMeetingHelper?.stream = mediaStream;
    webRTCMeetingHelper?.on("open", context, (ev, context) {
      isConnected(ConnectionStatus.Connected);
    });
    webRTCMeetingHelper?.on("connection", context, (ev, context) {});
    webRTCMeetingHelper?.on("user-left", context, (ev, context) {});
    webRTCMeetingHelper?.on("video-toggle", context, (ev, context) {});
    webRTCMeetingHelper?.on("connection-setting-changed", context, (ev, context) {
      isConnected(ConnectionStatus.Failed);
    });
    notifyListeners();
  }

  Future<void> _initRender() async {
    await _renderer?.initialize();
  }

  RTCVideoRenderer? get rtcVideoRenderer {
    return _renderer;
  }

  @override
  void disconnect() {
    webRTCMeetingHelper?.destroy();
    webRTCMeetingHelper?.clear();
    _renderer?.dispose();
    _renderer = null;
    mediaStream?.dispose();
    webRTCMeetingHelper = null;
  }
}
