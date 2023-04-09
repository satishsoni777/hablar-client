import 'package:take_it_easy/components/app_alert.dart';
import 'package:take_it_easy/resources/app_keys.dart';

class AppLoader {
  AppLoader._();
  static showLoader() {
    AppAlert.of(navigatorKey.currentContext!).dialog();
    // navigatorKey.currentContext?.loaderOverlay.show(
    //     widget: Column(
    //   children: [
    //     SizedBox(
    //       height: 50,
    //     ),
    //     CircularProgressIndicator()
    //   ],
    // ));
  }

  static hideLoader() async {
    AppAlert.popDialog();
    // navigatorKey.currentContext?.loaderOverlay.hide();
  }
}
