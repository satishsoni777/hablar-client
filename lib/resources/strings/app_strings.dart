import 'package:flutter/material.dart';

class Endpoints {
  Endpoints._();
  static const String rtcToken = 'rtcBuilder/rtcToken';
  static const String startMeeting = 'meeting/start';
  static const String join = "join";
  static const String sigin = 'authentication/signIn';
  static const String toggleOffOn = 'signaling/toggle_online';
  static const String leaveRoom = 'signaling/leaveRoom';
  static const String joinRandomRoom = 'signaling/joinRandomRoom';
  static const String updateUserData = 'users/updateUserData';
  static const String agoraToken = 'agora/rtc_token';
}

class AppStrings {
  AppStrings._();
  static AppStrings _instance = AppStrings._();
  static AppStrings of(BuildContext context) {
    return _instance;
  }

  get startTalkingBuddy => 'Start talking with a stranger';
  get aboutUs => "About us";
}
