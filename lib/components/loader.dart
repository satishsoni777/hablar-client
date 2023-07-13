import 'dart:async';

import 'package:take_it_easy/components/app_alert.dart';

class AppLoader {
  AppLoader._();
  static Timer? timer;
  static bool _hasLoader = true;
  static showLoader() {
    _hasLoader = true;
    AppAlert.dialog();
    timer?.cancel();
    timer = Timer(const Duration(seconds: 5), () {
      hideLoader();
    });
  }

  static hideLoader() async {
    if (!_hasLoader) return;
    AppAlert.popDialog();
    _hasLoader = false;
  }
}
