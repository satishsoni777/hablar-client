import 'dart:core';
import 'dart:html';

import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride;
import 'package:flutter/material.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class WrtcManage {
  AudioElement? _recorderAudioChannel;
  WrtcManage.init() {
    if (WebRTC.platformIsDesktop) {
      debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
    } else if (WebRTC.platformIsAndroid) {
      WidgetsFlutterBinding.ensureInitialized();
      startForegroundService();
    }
  }

  Future<bool> startForegroundService() async {
    final androidConfig = FlutterBackgroundAndroidConfig(
      notificationTitle: 'Title of the notification',
      notificationText: 'Text of the notification',
      notificationImportance: AndroidNotificationImportance.Default,
      notificationIcon: AndroidResource(
          name: 'background_icon',
          defType: 'drawable'), // Default is ic_launcher from folder mipmap
    );
    return FlutterBackground.initialize(androidConfig: androidConfig);
  }
}
