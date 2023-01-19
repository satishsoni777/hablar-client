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
      final arg = IO.OptionBuilder()
          .setTransports(['websocket']) // for Flutter or Dart VM
          // optional
          .build();
      socket = IO.io(Flavor.internal().baseUrl, arg);
    } catch (_) {
      print('error $_');
    }

    // socket = socket?.connect();
    socket?.onConnect((_) {
      print('connected');
      // socket.emit('msg', 'test');
    });

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
    socket?.emit("message", "gdfhjdfgh");
    return Future.value(true);
  }

  @override
  void onMessage(Function(dynamic p1) call) {
    socket?.on('event', (data) {
      call.call(data);
    });
  }
}
