import 'package:flutter/material.dart';
import 'package:take_it_easy/modules/video_call/video_call.dart';
import 'package:take_it_easy/modules/voice_call/voice_call.dart';

class Routes {
  static final videoCall = '/video_call';
  static final voiceCall = '/voice_call';
  static Map<String, Widget Function(BuildContext context)> getRoutes() => {
        Routes.voiceCall: (context) => VoiceCall(),
        Routes.videoCall: (context) => VideoCall()
      };
}
