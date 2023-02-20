import 'dart:async';

import 'package:take_it_easy/modules/model/user_data.dart';

abstract class RtcInterface<T> {
  Future<void> makeVoiceCall(UserConnectionData data);
  Future<void> initialize();
  Future<T> getCallDuration();
  void dispose();
  void enableAudio();
  void disconnect();
  StreamController<ConnectionStatus> _stream = StreamController<ConnectionStatus>.broadcast();
  StreamController<ConnectionStatus> get connectionStatus => _stream;
  StreamController<Duration> _streamDuration = StreamController<Duration>.broadcast();
  StreamController<Duration> get streamDuration => _streamDuration;
  void isConnected(ConnectionStatus status) {
    _stream.add(status);
  }

  void setStreamDuration(Duration duration) {
    _streamDuration.add(duration);
  }
}

enum ConnectionStatus {
  Connected,
  Failed,
  Disconnect,
  Connecting
}
