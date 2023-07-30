import 'dart:async';
import 'package:take_it_easy/di/di_initializer.dart';
import 'package:take_it_easy/enums/socket-io-events.dart';
import 'package:take_it_easy/modules/signin/model/gmail_user_data.dart';
import 'package:take_it_easy/storage/shared_storage.dart';
import 'package:take_it_easy/utils/extensions.dart';
import 'package:take_it_easy/utils/flovor.dart';
import 'package:take_it_easy/websocket/websocket.i.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

final int PING_DURATION = 4;

class SocketIO extends AppWebSocket {
  IO.Socket? socket;
  Timer? _timer;
  int? userId;
  final SharedStorage _pref = DI.inject<SharedStorage>();
  @override
  void connect({String? header, Function? revereCallback}) async {
    try {
      final String token = await _pref.getToken() ?? '';
      userId = (await DI.inject<SharedStorage>().getUserData()).userId;
      final String url = Flavor.internal().baseUrl.getUrl;
      if (socket?.connected ?? false) return;
      socket?.close();
      socket = IO.io(
        url + '?userId=$userId',
        IO.OptionBuilder()
            .setTransports(<String>['websocket'])
            .setExtraHeaders(<String, dynamic>{"authorization": "Bearer $token"})
            .setReconnectionAttempts(2000)
            .build(),
      );
      socket?.connect();
    } catch (_) {
      print('error $_');
    }

    socket?.onConnect((_) {
      print("Socket IO connected");
      onConnected?.call(WebSocketStatus.Connected);
    });

    socket?.onReconnect((data) {
      print("On onReconnect");
    });

    socket?.onConnecting((data) => print("On Connecting"));

    socket?.onDisconnect((_) {
      print("On Disconnect");
      onConnected?.call(WebSocketStatus.Disconnected);
    });

    _onMessage();
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
        socket?.emit("message", message);
        break;
      case MeetingPayloadEnum.JOIN_RANDOM_CALL:
        socket?.emit("message", message);
        break;
    }
    return Future<bool>.value(true);
  }

  void _pingPong() {
    userId = DI.inject<UserData>().userId;
    _timer?.cancel();
    final pingMessage = {"type": "ping", "userId": userId};
    _timer = Timer.periodic(Duration(seconds: PING_DURATION), (Timer a) {
      if (isConnected) {
        print("Send Ping $pingMessage");
        socket?.emit(MeetingPayloadEnum.PING, pingMessage);
      } else {
        // connect();
      }
    });
  }

  void _onMessage() {
    socket?.onPing((data) => null);
    socket?.onPong((data) => null);
    socket?.on(MeetingPayloadEnum.ANSWER_SDP, (data) {
      print("on ANSWER_SDP $data");
      answerSdp?.call(data);
    });
    socket?.on(MeetingPayloadEnum.USER_LEFTL, (data) {
      print("on USER_LEFTL $data");
      userLeft?.call(data);
    });
    socket?.on(MeetingPayloadEnum.USER_JOINED, (data) {
      print("on USER_JOINED $data");
      userJoined?.call(data);
    });
    socket?.on(MeetingPayloadEnum.JOIN, (data) {
      print("on JOIED $data");
      join?.call(data);
    });
    socket?.on(MeetingPayloadEnum.CREATE_ROOM, (data) {
      print("MeetingPayloadEnum.CREATE_ROOM $data");
      roomCreated?.call(data);
    });
    socket?.on(MeetingPayloadEnum.CALL_STARTED, (data) {
      print("MeetingPayloadEnum.CALL_STARTED $userId");
      callStarted?.call(data);
    });
    socket?.on("message", (data) => onMessage?.call(data));
  }

  @override
  Future<void> joinRandomCall() async {
    if (isConnected) {
      final Map<String, dynamic> msg = <String, dynamic>{"countryCode": "IN", "stateCode": "KR", "type": "join-random-call"};
      socket?.emit("message", msg);
    } else {
      connect();
      onConnected = (_) {
        joinRandomCall();
      };
    }
  }

  @override
  void leaveRoom(Map<String, dynamic> message) {
    if (isConnected) {
      message["userId"] = userId;
      message["type"] = "leave-room";
      socket?.emit("message", message);
    } else {
      connect();
      onConnected = (_) {
        leaveRoom(message);
      };
    }
  }

  @override
  bool get isConnected => socket?.connected ?? false;
}
