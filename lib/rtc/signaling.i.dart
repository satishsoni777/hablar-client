import 'dart:async';

abstract class SignalingI<T> {
  Future<void> startCall({ String? roomId, int? userId});

  Future<void> initialize();

  Future<T> getCallDuration();

  Future<void> disconnect();

  Function(CallStatus, {Map<String, dynamic>? data})? callStatus;

  Future<bool> mute(bool value);

  Future<void> speaker(bool value);

  CallType get callType;
}

enum ConnectionStatus { Connected, Failed, Disconnect, Connecting }

enum CallStatus {
  None,
  Start,
  Connecting,
  CallStarted,
  CallEnded,
  Mute,
  Disconnected,
  UserLeft
}

enum CallType { Video, Audio }

enum HostType { Callee, Caller }
