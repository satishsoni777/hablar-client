import 'package:flutter/material.dart';

class Endpoints {}

class AppStrings {
  AppStrings._();
  static AppStrings _instance = AppStrings._();
  static AppStrings of(BuildContext context) {
    return _instance;
  }

  get startTalkingBuddy => 'Start talking with a stranger';
}
