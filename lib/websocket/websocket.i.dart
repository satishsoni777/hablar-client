import 'dart:convert';
import 'dart:io';
import 'package:web_socket_channel/io.dart';

abstract class AppWebSocket {
  
  Function(dynamic)? onMessageCallback;

  void connect(String url, {String? header});

  Function(WebSocketConnectionStatus)? status;

  void onMessage(Function (dynamic) data);

  Future<bool>? sendMessage(Map<String, dynamic> message);

  void close();
}

class WebSocketImpl extends AppWebSocket {
  IOWebSocketChannel? _channel;
  WebSocketConnectionStatus? _webSocketConnectionStatus;
  @override
  void connect(String url, {String? header}) async {
    _webSocketConnectionStatus =
        WebSocketConnectionStatus("", WebSocketStatus.Connecting);
    status?.call(_webSocketConnectionStatus!);
    try {
      if (_channel != null) _channel?.sink.close();
      _channel = IOWebSocketChannel.connect(url);
      _init();
    } catch (_) {
      print(_);
    }
  }

  void _init() {
    _channel?.changeStream((stream) {
      stream.listen((event) {
          print(event);
        _webSocketConnectionStatus =
            WebSocketConnectionStatus("", WebSocketStatus.Connected);
        status?.call(_webSocketConnectionStatus!);
        onMessageCallback?.call(event);
      }, onDone: () {
        status?.call(WebSocketConnectionStatus("", WebSocketStatus.Connected));
      }, onError: (err) {
        status?.call(
            WebSocketConnectionStatus(err.toString(), WebSocketStatus.Error));
      });
      return stream;
    });
  }

  @override
  Future<bool>? sendMessage(Map<String, dynamic> message) {
    _channel?.sink.add(jsonEncode(message));
    _channel?.sink.add(jsonEncode("asdfasd"));
    return Future.value(true);
  }

  @override
  void close() {
    _channel?.sink.close();
    _webSocketConnectionStatus =
        WebSocketConnectionStatus("", WebSocketStatus.Closed);
    status?.call(_webSocketConnectionStatus!);
  }
  
  @override
  void onMessage(Function(dynamic) data) {
   data.call("");
  }
}

class WebSocketConnectionStatus {
  WebSocketConnectionStatus(this.error, this.webSocketStatus);
  String? error;
  WebSocketStatus? webSocketStatus;
}

enum WebSocketStatus { Connecting, Connected, Closed, Error, Disconnected }
