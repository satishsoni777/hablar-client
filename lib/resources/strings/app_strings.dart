import 'package:flutter/material.dart';

class Endpoints {
  Endpoints._();
  static const rtcToken = '/rtcBuilder/rtcToken';
  static const startMeeting = '/api/meeting/start';
  static const join = "/join";
}

class AppStrings {
  AppStrings._();
  static AppStrings _instance = AppStrings._();
  static AppStrings of(BuildContext context) {
    return _instance;
  }

  get startTalkingBuddy => 'Start talking with a stranger';
}
