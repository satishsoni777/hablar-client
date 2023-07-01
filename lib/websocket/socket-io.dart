import 'package:take_it_easy/di/di_initializer.dart';
import 'package:take_it_easy/enums/socket-io.dart';
import 'package:take_it_easy/utils/call_streaming/rtc_util.dart';
import 'package:take_it_easy/utils/flovor.dart';
import 'package:take_it_easy/websocket/websocket.i.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketIO extends AppWebSocket {
  IO.Socket? socket;
  @override
  void connect({String? header}) {
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
      print('Socket ios connected');
    });
    _onMessage();
    socket?.onDisconnect((_) => print('disconnect'));
  }

  @override
  void close() {
    socket?.clearListeners();
    socket?.close();
  }

  @override
  Future<bool>? sendMessage(Map<String, dynamic> message, {String? meetingPayloadEnum}) {
    switch (meetingPayloadEnum) {
      case MeetingPayloadEnum.OFFER_SDP:
        socket?.emit(MeetingPayloadEnum.OFFER_SDP, message);
        break;
      case MeetingPayloadEnum.JOIN_RANDOM_CALL:
        socket?.emit(MeetingPayloadEnum.OFFER_SDP, message);
        break;
    }
    message["email_id"] = "satk754@gmail.com";
    socket?.emit("voiceMessageFromClient", message);
    return Future.value(true);
  }

  void _onMessage() {
    socket?.on(MeetingPayloadEnum.ANSWER_SDP, (data) {
      print("on voiceMessageToClient $data");
    });
    socket?.on(MeetingPayloadEnum.USER_LEFTL, (data) {
      print("on voiceMessageToClient $data");
    });
    socket?.on(MeetingPayloadEnum.USER_JOINED, (data) {
      print("on voiceMessageToClient $data");
    });
  }

  @override
  void onMessage(Function(dynamic p1) data, {String? meetingPayloadEnum}) {
    // TODO: implement onMessage
  }
}
