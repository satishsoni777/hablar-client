import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:take_it_easy/components/loader.dart';
import 'package:take_it_easy/navigation/navigation_manager.dart';
import 'package:take_it_easy/rtc/signaling.i.dart';
import 'package:take_it_easy/websocket/websocket.i.dart';

class SignalingController extends ChangeNotifier {
  SignalingController(this._signaling, this._appWebSocket, this._userId);

  final SignalingI<dynamic> _signaling;
  final AppWebSocket _appWebSocket;
  SignalingI<dynamic> get signaling => _signaling;
  CallStatus? _callStatus = CallStatus.None;
  String? _roomId;
  bool _mute = false, _speaker = false;
  int _userId;
  int? _duration = 0;
  Function(dynamic)? submitFeedback;

  void createRoomId() async {
    _appWebSocket.createRoom();
  }

  void _onSocketMessage() {
    _appWebSocket.join = (dynamic data) {
      _roomId = data["roomId"];
      _callStatus = CallStatus.Connecting;
      notifyListeners();
    };
    _appWebSocket.callStarted = (dynamic data) {
      if (_callStatus != CallStatus.CallStarted) {
        signaling.startCall(roomId: data["roomId"], userId: _userId);
        notifyListeners();
      }
    };
    _appWebSocket.userLeft = (dynamic data) {
      AppLoader.hideLoader();
    };
  }

  void _onSignalingMessage() {
    _signaling.callStatus =
        (CallStatus callStatus, {Map<String, dynamic>? data}) {
      _callStatus = callStatus;
      switch (callStatus) {
        case CallStatus.CallEnded:
          _duration = data?["duration"];
          callEnd();
          break;
        case CallStatus.Start:
          createRoomId();
          break;
        case CallStatus.Connecting:
          break;
        case CallStatus.Disconnected:
        case CallStatus.Mute:
        case CallStatus.UserLeft:
        case CallStatus.None:
        case CallStatus.CallStarted:
      }
      notifyListeners();
    };
  }

  void init() async {
    _onSocketMessage();
    _onSignalingMessage();
    await _signaling.initialize();
  }

  Future<void> callEnd() async {
    // close();
  }

  void close() async {
    AppLoader.showLoader();
    await _signaling.disconnect();
    _appWebSocket.leaveRoom(<String, dynamic>{"roomId": _roomId});
    await Future<void>.delayed(const Duration(seconds: 1));
    AppLoader.hideLoader();
    NavigationManager.instance.pop(false);
  }

  void mute(bool value) {
    _mute = !value;
    _signaling.mute(_mute);
    notifyListeners();
  }

  void onSpeaker(bool value) {
    _speaker = !value;
    _signaling.speaker(_speaker);
    notifyListeners();
  }

  CallStatus? get callStatus => _callStatus;
  bool get muted => _mute;
  bool get speaker => _speaker;
}
