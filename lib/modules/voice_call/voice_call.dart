import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:take_it_easy/modules/model/user_data.dart';
import 'package:take_it_easy/rtc/agora_rtc/voice_call_managar.dart';
import 'package:take_it_easy/rtc/rtc_interface.dart';
import 'package:take_it_easy/rtc/webrtc/voice_call/webrtc.impl.dart';

class VoiceCall extends StatefulWidget {
  const VoiceCall();

  @override
  _VoiceCallState createState() => _VoiceCallState();
}

class _VoiceCallState extends State<VoiceCall> {
  WebRtcManagerImpl? _voiceCallManager;
  RTCVideoRenderer? _rtcVideoRenderer;
  late RtcInterface rtcInterface;
  @override
  void initState() {
    rtcInterface = AgoraManager();
    // agoraVoiceManager = AgoraVoiceManager();
    // // _voiceCallManager = VoiceCallManager();
    _init();
    rtcInterface.initialize();
    super.initState();
  }

  _init() async {
    if (_voiceCallManager == null) return;
    _rtcVideoRenderer = await _voiceCallManager?.init();
    await _voiceCallManager?.makeVoiceCall(UserConnectionData());
    setState(() {});
  }

  @override
  dispose() {
    _voiceCallManager?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: _rtcVideoRenderer == null
            ? CircularProgressIndicator()
            : RTCVideoView(
                _rtcVideoRenderer!,
                mirror: true,
              ));
  }
}
