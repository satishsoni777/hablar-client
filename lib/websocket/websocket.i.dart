import 'dart:async';

abstract class AppWebSocket {
  Function(dynamic)? onMessageCallback;

  void connect({String? header});

  Function(WebSocketConnectionStatus)? status;

  Function(dynamic)? onMessage;

  Function(dynamic)? userJoined;

  Function(dynamic)? join;

  Function(dynamic)? callStart;

  Function(dynamic)? callStarted;

  Function(dynamic)? answerSdp;

  Function(dynamic)? offerSdp;

  Function(dynamic)? userLeft;

  Function(dynamic)? onConnected;

  bool get isConnected;

  void leaveRoom(Map<String, dynamic> message);

  Future<bool>? sendMessage(Map<String, dynamic> message,
      {String? meetingPayloadEnum});

  Future<void> createRoom();

  void close();
}

// class W
class WebSocketConnectionStatus {
  WebSocketConnectionStatus(this.error, this.webSocketStatus);
  String? error;
  WebSocketStatus? webSocketStatus;
}

enum WebSocketStatus { Connecting, Connected, Closed, Error, Disconnected }
