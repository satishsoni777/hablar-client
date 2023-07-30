import 'dart:async';

abstract class AppWebSocket {
  Function(dynamic)? onMessageCallback;

  void connect({String? header});

  Function(WebSocketConnectionStatus)? status;

  Function(dynamic)? onMessage;

  Function(dynamic)? userJoined;

  Function(dynamic)? createRoom;

  Function(dynamic)? join;

  Function(dynamic)? callStarted;

  Function(dynamic)? userLeft;

  Function(dynamic)? onConnected;

  Function(dynamic)? callEnd;

  bool get isConnected;

  void leaveRoom(Map<String, dynamic> message);

  Future<bool>? sendMessage(Map<String, dynamic> message, {String? meetingPayloadEnum});

  Future<void> joinRandomCall();

  void close();
}

class WebSocketConnectionStatus {
  WebSocketConnectionStatus(this.error, this.webSocketStatus);
  String? error;
  WebSocketStatus? webSocketStatus;
}

enum WebSocketStatus { Connecting, Connected, Closed, Error, Disconnected }
