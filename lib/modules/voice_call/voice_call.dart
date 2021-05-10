import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:take_it_easy/rtc/agora_rtc/voice_call_managar.dart';
import 'package:take_it_easy/rtc/webrtc/voice_call/voice_call_manager.dart';

class VoiceCall extends StatefulWidget {
  const VoiceCall();

  @override
  _VoiceCallState createState() => _VoiceCallState();
}

class _VoiceCallState extends State<VoiceCall> {
  VoiceCallManager _voiceCallManager;
  RTCVideoRenderer _rtcVideoRenderer;
  AgoraVoiceManager agoraVoiceManager;
  @override
  void initState() {
    agoraVoiceManager = AgoraVoiceManager();
    // _voiceCallManager = VoiceCallManager();
    _init();
    super.initState();
  }

  _init() async {
    if (_voiceCallManager == null) return;
    _rtcVideoRenderer = await _voiceCallManager.init();
    await _voiceCallManager.makeCall();
    setState(() {});
  }

  @override
  dispose() {
    _voiceCallManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: _rtcVideoRenderer == null
            ? CircularProgressIndicator()
            : RTCVideoView(
                _rtcVideoRenderer,
                mirror: true,
              ));
  }
}
