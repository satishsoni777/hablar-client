import 'package:flutter/material.dart';

class Endpoints {
  Endpoints._();
  static const String rtcToken = 'rtcBuilder/rtcToken';
  static const String startMeeting = 'meeting/start';
  static const String join = "join";
  static const String sigin = 'authentication/sign_in';
  static const String toggleOffOn = 'callStream/toggleOffOn';
  static const String leaveRoom = 'callStream/leaveRoom';
  static const String joinRandomRoom = 'callStream/joinRandomRoom';
}

class AppStrings {
  AppStrings._();
  static AppStrings _instance = AppStrings._();
  static AppStrings of(BuildContext context) {
    return _instance;
  }

  get startTalkingBuddy => 'Start talking with a stranger';
}
