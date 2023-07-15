import 'package:flutter/foundation.dart';
import 'package:take_it_easy/modules/calling/webrtc/signaling.dart';

class CallingController extends ChangeNotifier {
  Signaling _signaling = Signaling();
  void joinRandomCall() async {
    _signaling.joinRandomCall();
  }

  void toggleAudio() {}

  void callEnd() {
    _signaling.callEnd();
  }
}
