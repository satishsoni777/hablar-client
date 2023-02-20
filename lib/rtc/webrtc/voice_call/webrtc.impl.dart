import 'dart:core';

import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:take_it_easy/modules/dialer/bloc/rtc_bloc.dart';
import 'package:take_it_easy/modules/model/user_data.dart';
import 'package:take_it_easy/rtc/rtc_interface.dart';

class WebRtcManagerImpl extends RtcInterface {
  WebRtcManagerImpl() {
    init();
  }
  MediaStream? _localStream;
  RTCVideoRenderer? _localRenderer;
  bool _inCalling = false;
  bool _isTorchOn = false;
  MediaRecorder? _mediaRecorder;
  bool get _isRec => _mediaRecorder != null;
  List<MediaDeviceInfo>? _mediaDevicesList;
  MediaStream? _stream;
  Future<RTCVideoRenderer> init() async {
    _localRenderer = RTCVideoRenderer();
    await _localRenderer?.initialize();
    return _localRenderer!;
  }

  @override
  Future makeVoiceCall(UserConnectionData data) async {
    final mediaConstraints = <String, dynamic>{
      'audio': true,
      'video': {
        'mandatory': {
          'minWidth':
              '1280', // Provide your own width, height and frame rate here
          'minHeight': '720',
          'minFrameRate': '30',
        },
        'facingMode': 'user',
        'optional': [],
      }
    };

    try {
      _stream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
      _stream?.dispose();
      _mediaDevicesList = await navigator.mediaDevices.enumerateDevices();
      _localStream = _stream;
     final l= _stream?.getAudioTracks().first.enableSpeakerphone(true);
      _localRenderer?.srcObject = _localStream;
    } catch (e) {}
  }

  @override
  void enableAudio() {
    RTCFactoryNative.instance.mediaRecorder();
    // TODO: implement enableAudio
  }

  @override
  Future getCallDuration() {
    // TODO: implement getCallDuration
    throw UnimplementedError();
  }

  @override
  Future initialize() {
    // TODO: implement initialize
    throw UnimplementedError();
  }

  dispose() async {
    await _localRenderer?.dispose();
    await _stream?.dispose();
  }

  @override
  void disconnect() {
    // TODO: implement disconnect
  }
}
