import 'dart:core';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class VoiceCallManager {
  MediaStream _localStream;
  final _localRenderer = RTCVideoRenderer();
  bool _inCalling = false;
  bool _isTorchOn = false;
  MediaRecorder _mediaRecorder;
  bool get _isRec => _mediaRecorder != null;

  List<MediaDeviceInfo> _mediaDevicesList;
  MediaStream _stream;
  void makeCall() async {
    final mediaConstraints = <String, dynamic>{
      'audio': false,
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
      _stream.dispose();
      _mediaDevicesList = await navigator.mediaDevices.enumerateDevices();
      _localStream = _stream;
      _localRenderer.srcObject = _localStream;
    } catch (e) {
      print(e.toString());
    }
  }

  dipose() async {
    await _stream.dispose();
  }
}
