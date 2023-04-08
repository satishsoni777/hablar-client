import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:take_it_easy/di/di_initializer.dart';
import 'package:take_it_easy/modules/dialer/service/meeting_api_impl.dart';
import 'package:take_it_easy/modules/model/user_data.dart';
import 'package:take_it_easy/rtc/rtc_interface.dart';
import 'package:flutter_webrtc_wrapper/flutter_webrtc_wrapper.dart';
import 'package:take_it_easy/storage/shared_storage.dart';
import 'package:take_it_easy/utils/utils.dart';

class WebRtcManager extends RtcInterface with ChangeNotifier {
  WebRTCMeetingHelper? _webRTCMeetingHelper;
  MediaStream? mediaStream;
  RTCVideoRenderer? _localRenderer = RTCVideoRenderer();
  BuildContext? context;
  @override
  Future<void> initialize() async {}

  void initiateCall(BuildContext context, UserConnectionData data) async {
    try {
      data.userId = await Utils.userId();
      final res = await MeetingServiceImpl().startMeeting();
      data.meetingId = "";
      data.name = (await DI.inject<SharedStorage>().getUserData()).displayName;
    } catch (_) {
      print("makeMicCall Errors $_");
    }
    this.context = context;
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
    try {
      await _initRender();
      _webRTCMeetingHelper = WebRTCMeetingHelper(url: "http://localhost:8082", autoConnect: true, meetingId: "ztvYn2b45FQmNsXlSvOZQNUu0H32", name: data.name, userId: data.userId);
      _webRTCMeetingHelper?.autoConnect = true;
      mediaStream = await navigator.mediaDevices.getUserMedia(data.mediaConstraint());
      _localRenderer?.srcObject = mediaStream;
      _webRTCMeetingHelper?.stream = mediaStream;
    } catch (e) {
      print(e);
    }

    _onMessage();

    notifyListeners();
  }

  void _onMessage() {
    _webRTCMeetingHelper?.on("open", context, (ev, context) {
      print("@#!@#@#");
      isConnected(ConnectionStatus.Connected);
    });
    _webRTCMeetingHelper?.on("connection", context, (ev, context) {
      print("connection @#!@#@#");
    });
    _webRTCMeetingHelper?.on("user-left", context, (ev, context) {
      print("user @#!@#@#");
    });
    _webRTCMeetingHelper?.on("video-toggle", context, (ev, context) {
      print("video @#!@#@#");
    });
    _webRTCMeetingHelper?.on("connection-setting-changed", context, (ev, context) {
      print("connection @#!@#@#");
      isConnected(ConnectionStatus.Failed);
    });
  }

  WebRTCMeetingHelper? get webRTCMeetingHelper => _webRTCMeetingHelper;

  Future<void> _initRender() async {
    await _localRenderer?.initialize();
  }

  RTCVideoRenderer? get localRenderer {
    return _localRenderer;
  }

  RTCVideoRenderer? get connectionRenderer {
    return _webRTCMeetingHelper?.connections.first.renderer;
  }

  @override
  void disconnect() {
    _webRTCMeetingHelper?.destroy();
    _webRTCMeetingHelper?.clear();
    _localRenderer?.dispose();
    _localRenderer = null;
    mediaStream?.dispose();
    _webRTCMeetingHelper = null;
  }
}
