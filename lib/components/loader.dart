import 'package:loader_overlay/loader_overlay.dart';
import 'package:take_it_easy/resources/app_keys.dart';

class AppLoader {
  AppLoader._();
  static showLoader() {
    navigatorKey.currentContext?.loaderOverlay.show();
  }

  static hideLoader() {
    navigatorKey.currentContext?.loaderOverlay.hide();
  }
}
