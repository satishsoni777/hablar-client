import 'dart:core';

import 'package:take_it_easy/webservice/http_manager/http_manager.dart';
import 'package:take_it_easy/websocket/socket-io.dart';

abstract class SinglaingService {
  Future<void> createRoom(SocketIO socket, Map<String, dynamic> data);
  Future<void> callEnd(SocketIO socket, Map<String, dynamic> data);
  Future<void> toggle();
}

class SignallingImpl extends HttpManager implements SinglaingService {

  @override
  Future<void> createRoom(SocketIO socket, Map<String, dynamic> data) async {
    final Map<String, dynamic> msg = <String, dynamic>{
      "countryCode": "IN",
      "stateCode": "KR",
      "type": "join-random-call"
    };
    socket.sendMessage(msg);
  }

  @override
  Future<void> callEnd(SocketIO socket, Map<String, dynamic> data) async {
    final Map<String, dynamic> msg = <String, dynamic>{
      "countryCode": "IN",
      "stateCode": "KR",
      "type": "join-random-call"
    };
    socket.sendMessage(msg);
  }

  @override
  Future<void> toggle() {
    // TODO: implement toggle
    throw UnimplementedError();
  }
}
