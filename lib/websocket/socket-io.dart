import 'package:take_it_easy/di/di_initializer.dart';
import 'package:take_it_easy/utils/call_streaming/rtc_util.dart';
import 'package:take_it_easy/utils/flovor.dart';
import 'package:take_it_easy/websocket/websocket.i.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketIO extends AppWebSocket {
  IO.Socket? socket;
  @override
  void connect(String url, {String? header}) {
    // Dart client
    try {
      if (socket?.connected ?? false) return;
      socket?.close();
      final arg = IO.OptionBuilder().setTransports([
        'websocket'
      ]).build();
      socket = IO.io(Flavor.internal().baseUrl, arg);
    } catch (_) {
      print('error $_');
    }

    // socket = socket?.connect();
    socket?.onConnect((_) {
      print('connected');
    });
    _onMessage();
    socket?.onDisconnect((_) => print('disconnect'));
    // socket?.on('fromServer', (_) => print(_));
  }

  @override
  void close() {
    socket?.clearListeners();
    socket?.close();
  }

  @override
  Future<bool>? sendMessage(Map<String, dynamic> message) {
    message["email_id"] = "satk754@gmail.com";
    socket?.emit("voiceMessageFromClient", message);
    return Future.value(true);
  }

  void _onMessage() {
    socket?.on('voiceMessageToClient', (data) {
      print("on voiceMessageToClient $data");
      DI.inject<RtcUtil>().play(data);
    });
  }

  void _sendEvent(Map<String, dynamic> message) {
    final eventType = message["event"];
  }

  @override
  void onMessage(Function(dynamic p1) call) {}
}
