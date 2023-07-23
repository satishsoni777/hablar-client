import 'package:flutter/foundation.dart';
import 'package:take_it_easy/di/di_initializer.dart';
import 'package:take_it_easy/modules/calling/webrtc/signaling.dart';
import 'package:take_it_easy/storage/db/firebase_db.dart';
import 'package:take_it_easy/storage/shared_storage.dart';
import 'package:take_it_easy/utils/string_utils.dart';
import 'package:take_it_easy/websocket/websocket.i.dart';

class CallingController extends ChangeNotifier {
  CallingController(this._signaling);
  Signaling _signaling;
  Signaling get signaling => _signaling;
  void joinRandomCall(Signaling signaling) async {
    final String roomId = await DI.inject<SharedStorage>().getStringPreference(StorageKey.roomId) ?? '';
    await FirebaseDbUtil.instance.deleteRoomIfExist(roomId);
    if (isNullOrEmpty(roomId)) {
      DI.inject<AppWebSocket>().leaveRoom(<String, dynamic>{"roomId": roomId});
    }

    signaling.joinRandomCall();
  }

  void toggleAudio() {}

  Future<void> callEnd(Signaling signaling) async {
    await signaling.callEnd();
  }

  void onNavigationChanged() {}
}
